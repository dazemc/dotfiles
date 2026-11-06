#!/usr/bin/env bash
# lsp_util.sh — open a read-only copy of a file under /tmp.
# Usage: lsp_util.sh <file> <language>
set -euo pipefail

filename="${1:?usage: lsp_util.sh <file> <language>}"
lang="${2:?usage: lsp_util.sh <file> <language>}"
tempFile="$(mktemp --suffix=".$lang")"

cp "$filename" "$tempFile"
chmod -w "$tempFile"
exec nvim "$tempFile"
