#!/usr/bin/env bash
# docs.sh — keep markdown commits out of the live checkout.
#
# The live session reads this checkout through symlinks (~/.config/hypr and
# friends). Switching it to master for a docs commit can serve older config to
# the running session, so markdown work happens in a short-lived worktree:
#
#   ./docs.sh                 # create/reuse the master worktree and print it
#   cd "$(./docs.sh)"         # edit and commit there
#   git -C "$wt" push origin master
#   ./docs.sh --close         # merge master into working, remove the worktree
#
# One file per commit, never config in the same commit.
set -euo pipefail

root="$(cd "$(dirname "$0")" && pwd)"
wt="${TMPDIR:-/tmp}/dotfiles-docs"

case "${1:-}" in
  "")
    if [[ "$(git -C "$root" branch --show-current)" != "working" ]]; then
      echo "docs.sh: run from the live checkout on 'working'" >&2
      exit 1
    fi
    if git -C "$root" worktree list --porcelain | grep -qx "worktree $wt"; then
      if [[ "$(git -C "$wt" rev-parse --abbrev-ref HEAD)" != "master" ]]; then
        echo "docs.sh: $wt exists but is not on master" >&2
        exit 1
      fi
    else
      git -C "$root" worktree add "$wt" master
    fi
    git -C "$wt" pull --ff-only origin master
    echo "$wt"
    ;;
  --close)
    git -C "$root" merge master --no-edit
    git -C "$root" worktree remove "$wt"
    echo "docs.sh: master merged into working; $wt removed"
    ;;
  *)
    echo "usage: $0 [--close]" >&2
    exit 2
    ;;
esac
