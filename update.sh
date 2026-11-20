#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

# Refuse to move a submodule that has uncommitted work; checkout would fail
# halfway through the batch and leave the pins inconsistent.
if ! git submodule foreach --quiet 'git diff --quiet && git diff --cached --quiet'; then
  echo "One or more submodules have uncommitted changes; commit or stash them first." >&2
  exit 1
fi

# Ensure submodules are initialized
git submodule update --init --recursive

# Update each submodule to its configured branch
git submodule foreach "
  branch=\$(git config -f \$toplevel/.gitmodules submodule.\$name.branch)
  if [ -z \"\$branch\" ]; then
    branch=master   # fallback if branch not defined
  fi
  echo Updating submodule \$name on branch \$branch
  git fetch origin \$branch
  git checkout \$branch
  git pull --ff-only origin \$branch
"

