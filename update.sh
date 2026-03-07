#!/usr/bin/env bash
set -euo pipefail

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

