#!/usr/bin/env bash
set -euo pipefail

# Ensure submodules are initialized
git submodule init

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

# Stage updated submodule SHAs in the superproject
git add .

# Commit if there are changes
if ! git diff --cached --quiet; then
    git commit -m 'Update submodules to latest'
else
    echo "No submodule updates found."
fi

