#!/usr/bin/env bash
# Regenerate the package lists from the current system.
# Writes next to this script, never into the caller's current directory.
set -euo pipefail

cd "$(dirname "$0")" || exit 1

tmp_native="$(mktemp)"
tmp_foreign="$(mktemp)"
trap 'rm -f "$tmp_native" "$tmp_foreign"' EXIT

pacman -Qqe >"$tmp_native"
pacman -Qqem | sed '/^aura$/d' >"$tmp_foreign"
mv "$tmp_native" pkglist.txt
mv "$tmp_foreign" foreignpkglist.txt
