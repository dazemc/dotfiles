#!/usr/bin/env bash
# shellcheck disable=SC2087,SC2029  # heredocs and remote paths expand locally on purpose
# server-install.sh — provision a headless Arch host over SSH.
#
# Auth: SSH key or an interactive ssh prompt. sudo prompts on the remote TTY.
# This script never accepts or stores a password; do not put one on the
# command line or in the repo. Prefer `ssh-copy-id` and a passphrase-protected
# key, and rotate any password that was shared in chat.
#
# Usage:
#   ./arch/server-install.sh --host daze@10.100.0.20 --check
#   ./arch/server-install.sh --host daze@10.100.0.20 --dry-run
#   ./arch/server-install.sh --host daze@10.100.0.20
#   ./arch/server-install.sh --host daze@host --no-config   # packages only
#   ./arch/server-install.sh --host daze@host --no-packages # links only
#
# The config step clones the dotfiles repo if absent, updates it only when the
# checkout is clean, and links shell/tmux/nvim. It never runs private/setup.sh
# and never links Hyprland, environment.d, msmtp, or the macOS zsh config.
set -euo pipefail

cd "$(dirname "$0")/.." || exit 1

host=""
check=false
dry_run=false
no_config=false
no_packages=false
pkglist="arch/server-pkglist.txt"
branch="master"
repo_url="git@github.com:dazemc/dotfiles.git"

usage() {
  cat <<'EOF'
Usage: arch/server-install.sh --host user@host [options]

  --host user@host   SSH target (required)
  --check            read-only report: OS, sudo mode, missing packages, links
  --dry-run          print the plan without connecting
  --no-config        install packages only
  --no-packages      link configs only
  --packages FILE    package list (default: arch/server-pkglist.txt)
  --branch NAME      dotfiles branch (default: master)
  --repo URL         dotfiles clone URL (default: git@github.com:dazemc/dotfiles.git)
  -h, --help         show this help

Auth is SSH key or an interactive ssh prompt. The script never accepts a
password argument; sudo prompts once on the remote TTY. Use --check first.
EOF
}

while (($#)); do
  case "$1" in
    --host)
      host="${2:?--host needs user@host}"
      shift 2
      ;;
    --check)
      check=true
      shift
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --no-config)
      no_config=true
      shift
      ;;
    --no-packages)
      no_packages=true
      shift
      ;;
    --packages)
      pkglist="${2:?--packages needs a file}"
      shift 2
      ;;
    --branch)
      branch="${2:?--branch needs a name}"
      shift 2
      ;;
    --repo)
      repo_url="${2:?--repo needs a URL}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "server-install: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$host" ]] || { echo "server-install: --host is required" >&2; exit 2; }
[[ "$host" != -* ]] || { echo "server-install: invalid host" >&2; exit 2; }
[[ -f "$pkglist" ]] || { echo "server-install: package list not found: $pkglist" >&2; exit 1; }

mapfile -t packages < <(grep -vE '^[[:space:]]*(#|$)' "$pkglist")
if ((${#packages[@]} == 0)); then
  echo "server-install: package list is empty: $pkglist" >&2
  exit 1
fi

control_dir="${XDG_RUNTIME_DIR:-/tmp}/dotfiles-ssh"
mkdir -p "$control_dir"
chmod 700 "$control_dir"
control_path="$control_dir/%r@%h:%p"
ssh_opts=(
  -o ConnectTimeout=10
  -o ControlMaster=auto
  -o ControlPath="$control_path"
  -o ControlPersist=10m
)

remote_tmp=""
close_master() {
  ssh "${ssh_opts[@]}" -O exit "$host" >/dev/null 2>&1 || true
}
cleanup() {
  if [[ -n "$remote_tmp" ]]; then
    ssh "${ssh_opts[@]}" "$host" "rm -f $remote_tmp" >/dev/null 2>&1 || true
  fi
  close_master
}
trap cleanup EXIT

if $dry_run; then
  echo "target: $host"
  echo "packages: ${#packages[@]} from $pkglist"
  printf '  %s\n' "${packages[@]}"
  if ! $no_config; then
    echo "configs: clone/update $repo_url on $branch if clean, then link"
    echo "  ~/.alias ~/.bashrc ~/.tmux ~/.tmux.conf ~/.config/nvim"
  fi
  echo "auth: ssh key/interactive; sudo password prompt on the remote TTY"
  exit 0
fi

echo "preflight: $host"
ssh "${ssh_opts[@]}" "$host" 'bash -s' <<'EOF'
set -euo pipefail
grep -q '^ID=arch$' /etc/os-release || { echo "server-install: target is not Arch" >&2; exit 1; }
command -v pacman >/dev/null || { echo "server-install: pacman missing" >&2; exit 1; }
command -v sudo >/dev/null || { echo "server-install: sudo missing" >&2; exit 1; }
EOF

if $check; then
  ssh "${ssh_opts[@]}" "$host" 'bash -s' <<EOF
set -euo pipefail
echo "host: \$(hostname)"
grep '^PRETTY_NAME=' /etc/os-release
printf 'kernel: '; uname -r
df -h / | tail -1
if sudo -n true 2>/dev/null; then echo "sudo: passwordless"; else echo "sudo: password required"; fi
missing=0
for p in ${packages[*]}; do
  if ! pacman -Q "\$p" >/dev/null 2>&1; then
    echo "missing: \$p"
    missing=\$((missing + 1))
  fi
done
echo "missing packages: \$missing/${#packages[@]}"
repo="\$HOME/GitHub/dotfiles"
if [ -d "\$repo/.git" ]; then
  echo "repo: \$repo"
  git -C "\$repo" status --short --branch | head -5
  git -C "\$repo" log --oneline -1
else
  echo "repo: absent (config step will clone it)"
fi
for link in "\$HOME/.bashrc" "\$HOME/.alias" "\$HOME/.tmux" "\$HOME/.tmux.conf" "\$HOME/.config/nvim"; do
  printf '%s -> %s\n' "\$link" "\$(readlink "\$link" 2>/dev/null || echo real/absent)"
done
EOF
  exit 0
fi

if ! $no_packages; then
  echo "installing ${#packages[@]} packages on $host; sudo may prompt..."
  pkg_args=$(printf '%q ' "${packages[@]}")
  ssh -tt "${ssh_opts[@]}" "$host" "sudo pacman -Syu --needed -- $pkg_args"
fi

if ! $no_config; then
  echo "linking server-safe dotfiles on $host..."
  remote_tmp="/tmp/dotfiles-server-config.$$.sh"
  ssh "${ssh_opts[@]}" "$host" "cat > $remote_tmp" <<EOF
set -euo pipefail
repo="\$HOME/GitHub/dotfiles"
if [ ! -d "\$repo/.git" ]; then
  git clone "$repo_url" "\$repo"
fi
cd "\$repo"
if [ -z "\$(git status --porcelain)" ]; then
  git fetch origin "$branch"
  git checkout "$branch"
  git merge --ff-only "origin/$branch"
  git submodule update --init nvim
  while read -r _ path; do
    case "\$path" in
      nvim|tmux/*) git submodule update --init "\$path" ;;
    esac
  done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path\$')
else
  echo "WARN: \$repo has local changes; skipping checkout update" >&2
fi
backup="\$HOME/.config/dotfiles-backup-\$(date +%Y%m%d-%H%M%S)"
mkdir -p "\$backup"
chmod 700 "\$backup"
link() {
  local src="\$1" dst="\$2"
  if [ -L "\$dst" ] && [ "\$(readlink "\$dst")" = "\$src" ]; then
    return 0
  fi
  if [ -e "\$dst" ] || [ -L "\$dst" ]; then
    mv "\$dst" "\$backup/"
  fi
  mkdir -p "\$(dirname "\$dst")"
  ln -s "\$src" "\$dst"
}
link "\$repo/shell/.alias" "\$HOME/.alias"
link "\$repo/shell/bash/.bashrc" "\$HOME/.bashrc"
link "\$repo/tmux/.tmux" "\$HOME/.tmux"
link "\$repo/tmux/.tmux.conf" "\$HOME/.tmux.conf"
link "\$repo/nvim" "\$HOME/.config/nvim"
echo "linked shell, tmux, and nvim; start a new login shell"
EOF
  ssh "${ssh_opts[@]}" "$host" "bash $remote_tmp"
  ssh "${ssh_opts[@]}" "$host" "rm -f $remote_tmp"
  remote_tmp=""
fi

echo "done: $host"
