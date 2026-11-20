# Dotfiles suggestions

Agent-proposed, user-reviewed suggestions. If you see something the queue, the
constitution, or the config gets wrong — a dead symlink, a live-system hazard,
a config inconsistency, a docs gap — propose it here so the next session sees
it. Standing rules belong in `AGENTS.md`, not here.

Non-authoritative: entries inform decisions but bind nothing until the user
escalates them to `.llm/todo.md` (see `AGENTS.md` → Instruction precedence).

## Rules

- Entries must be **absolutely needed**: they prevent a future mistake,
  unblock queued work, or record a decision with its reason.
- One entry per issue. Keep it to five lines: what, where, why, and what to do.
- Append after every change; findings never live only in the transcript.
- Remove an entry in the same change that resolves it.
- After finishing a step, re-read this file and update it only if something
  meets the bar above. Silence is a valid review outcome.
- At a phase boundary, walk every open entry with the user and settle it —
  keep, condense, move, escalate, or dismiss — before the next phase starts.

## Open suggestions

- **ccls ESP include paths are pinned to one toolchain build.**
  `nvim/lua/daze/lspconfig.lua` hardcodes `esp-15.2.0_20251204` and libstdc++
  paths; after an ESP-IDF update ccls points at missing headers. Derive the
  newest `~/.espressif/tools/xtensa-esp-elf/*` directory or use the project's
  `compile_commands.json`.
- **Snacks image docs lack a norg parser.** `:checkhealth snacks` warns that
  `norg` is missing and `nvim-treesitter` main does not ship it, so norg
  document images will not render. Install a standalone norg parser or set
  `image.doc.enabled = false` if that feature is not wanted.
- **Curated package list has unused entries.** `arch/pkglist.txt` still lists
  `hyprpaper` and `spotify-launcher` (the latter is no longer installed), while
  `quickshell` and `waybar` are installed but unused. Remove the entries with a
  go-ahead, then review `arch/backup.sh` output before committing a regeneration.
