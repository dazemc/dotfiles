#!/usr/bin/env bash
# restore.sh — put back config that setup.sh moved to a backup dir.
# Usage: ./restore.sh [--dry-run] <backup-dir>
#   --dry-run prints what would happen without touching anything (safe anytime).
# A real run rewrites live paths like setup.sh does: it runs only with the
# user's explicit go-ahead in chat — never as verification for another step.
#
# Backup entries are matched to live paths by basename (that is how
# clearExistingConfig stores them). Live symlinks are replaced; live real
# files are moved aside to a fresh safety backup first, never deleted.
# System backups under /root/dotfiles-backup-* are out of scope here:
# restoring those touches /etc and stays manual with a go-ahead.
set -uo pipefail

cd "$(dirname "$0")" || exit 1

CONFIG_LOCATION=(
  "$HOME/.bashrc"
  "$HOME/.zshrc"
  "$HOME/.tmux"
  "$HOME/.tmux.conf"
  "$HOME/.config/nvim"
  "$HOME/.config/spotify-player"
  "$HOME/.config/msmtp"
  "$HOME/.config/hypr"
  "$HOME/.config/quickshell"
  "$HOME/.config/enviroment.d/"
)

DRY_RUN=false
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=true
  shift
fi

BACKUP_DIR="${1:-}"
if [ -z "$BACKUP_DIR" ] || [ ! -d "$BACKUP_DIR" ]; then
  echo "Usage: $0 [--dry-run] <backup-dir>" >&2
  exit 1
fi

SAFETY_DIR="$HOME/.config/dotfiles-restore-$(date +%Y%m%d-%H%M%S)"
safety_ready=false

run() {
  if [ "$DRY_RUN" = true ]; then
    echo "would run: $*"
  else
    "$@"
  fi
}

for target in "${CONFIG_LOCATION[@]}"; do
  entry="$BACKUP_DIR/$(basename "$target")"
  if [ ! -e "$entry" ] && [ ! -L "$entry" ]; then
    echo "Skipping (no backup entry): $target"
    continue
  fi
  if [ -L "$target" ]; then
    echo "Restoring: $entry -> $target (replacing symlink)"
    run rm "$target"
    run mv "$entry" "$target"
  elif [ -e "$target" ]; then
    if [ "$safety_ready" = false ]; then
      run mkdir -p "$SAFETY_DIR"
      safety_ready=true
    fi
    echo "Restoring: $entry -> $target (live file moved aside to $SAFETY_DIR/)"
    run mv "$target" "$SAFETY_DIR/"
    run mv "$entry" "$target"
  else
    echo "Restoring: $entry -> $target"
    run mv "$entry" "$target"
  fi
done
