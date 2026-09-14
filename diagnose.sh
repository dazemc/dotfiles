#!/usr/bin/env bash
# diagnose.sh — read-only health check for the dotfiles link map.
# Verifies without changing anything: no writes, no sudo, safe to run anytime.
# Exit 0 when the tree is healthy, 1 otherwise.
# Grep patterns in checks 2-3 target the literal texts $PWD/$HOME (intentional).
# shellcheck disable=SC2016
set -uo pipefail

cd "$(dirname "$0")" || exit 1
fails=0
warns=0

pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; fails=$((fails + 1)); }
warn() { echo "WARN: $1"; warns=$((warns + 1)); }
info() { echo "INFO: $1"; }

# 1. Every CONFIG_LIST label needs a matching case branch in linkDirectories.
#    Two labels are known-dead by owner decision (see comments); anything
#    else unmatched is a live bug of the same class.
mapfile -t labels < <(sed -n '/^CONFIG_LIST=(/,/^)/p' setup.sh | grep -o '"[^"]*"' | tr -d '"')
mapfile -t branches < <(grep -o '^[[:space:]]*"[^"]*")' setup.sh | grep -o '"[^"]*"' | tr -d '"')
for label in "${labels[@]}"; do
  case "$label" in
    "quickshell") info "known-dead: only branch is 'quickshell ' (trailing space; parked with trickster)" ;;
    "enviroment.d") info "known-dead label '$label' (misspelled; rename parked)" ;;
    *)
      if printf '%s\n' "${branches[@]}" | grep -qxF "$label"; then
        pass "label '$label' has a link branch"
      else
        fail "label '$label' has no matching case branch"
      fi
      ;;
  esac
done

# 2. Every $PWD link source in setup.sh must exist (literals and globs).
while IFS= read -r src; do
  if compgen -G ".$src" > /dev/null; then
    pass "source '$src' resolves"
  else
    fail "source '$src' matches nothing"
  fi
# The grep patterns below target the literal text $PWD (intentional).
done < <(grep -o '"\$PWD[^"]*"' setup.sh | tr -d '"' | sed 's/^\$PWD//')

# 3. CONFIG_LOCATION targets: report live state (missing and symlinks are fine).
while IFS= read -r target; do
  live="${target//\$HOME/$HOME}"
  if [ -L "$live" ]; then
    pass "target '$target' is a symlink -> $(readlink "$live")"
  elif [ -e "$live" ]; then
    warn "target '$target' is a real file/dir (setup.sh would back it up, not link over it)"
  else
    pass "target '$target' absent (nothing to back up)"
  fi
# The grep pattern below targets the literal text $HOME (intentional).
done < <(sed -n '/^CONFIG_LOCATION=(/,/^)/p' setup.sh | grep -o '"\$HOME[^"]*"' | tr -d '"')

# 4. Submodules initialized and branch-pinned.
while IFS= read -r line; do
  sha="${line:0:1}"
  path="$(echo "$line" | awk '{print $2}')"
  if [ "$sha" = "-" ]; then
    fail "submodule '$path' not initialized"
  else
    pass "submodule '$path' initialized"
  fi
done < <(git submodule status)

while IFS= read -r key; do
  name="${key#submodule.}"
  name="${name%.path}"
  if git config -f .gitmodules "submodule.$name.branch" >/dev/null; then
    pass "submodule '$name' branch-pinned ($(git config -f .gitmodules "submodule.$name.branch"))"
  else
    fail "submodule '$name' has no branch pin (update.sh would guess)"
  fi
done < <(git config -f .gitmodules --get-regexp '\.path$' | awk '{print $1}')

# 5. Required binaries present.
for bin in git hyprctl tmux nvim pacman; do
  if command -v "$bin" >/dev/null; then
    pass "binary '$bin' present"
  else
    fail "binary '$bin' missing"
  fi
done
for bin in uwsm rofi brightnessctl playerctl hyprcap spotify_player msmtp; do
  if command -v "$bin" >/dev/null; then
    pass "optional '$bin' present"
  else
    warn "optional '$bin' missing"
  fi
done

# 6. Secrets stay out of git.
if git check-ignore -q msmtp/smtp.env; then
  pass "msmtp/smtp.env is gitignored"
else
  fail "msmtp/smtp.env is NOT gitignored"
fi
if git diff --cached --name-only | grep -qx 'msmtp/smtp.env'; then
  fail "msmtp/smtp.env is staged for commit"
else
  pass "no secrets staged"
fi

echo "---"
echo "diagnose: $fails failure(s), $warns warning(s)"
[ "$fails" -eq 0 ]
