# Dotfiles suggestions

Agent-proposed, user-reviewed suggestions. If you see something the queue,
the constitution, or the config gets wrong — a dead symlink, a live-system
hazard, a config inconsistency, a docs gap — propose it here so the next
session sees it. Standing rules and instructions belong in `AGENTS.md`, not
here.

Non-authoritative: entries inform decisions but bind nothing until the user
escalates them to `.llm/todo.md` (see `AGENTS.md` → Instruction precedence).

## Rules

- Entries must be **absolutely needed**: they prevent a future mistake,
  unblock queued work, or record a decision with its reason. Brainstorming,
  nice-to-haves, and restatements of `.llm/todo.md` do not belong here.
- One entry per issue. Keep it to five lines: what, where, why, and what
  to do about it.
- Append after every change: review the touched code for misses and add
  entries that meet the bar; findings never live only in the transcript.
- Remove an entry in the same change that resolves it — same discipline as
  `.llm/todo.md`.
- After finishing any `.llm/todo.md` step, re-read this file and update it, but
  only if something meets the bar above. No obligatory edits. Silence is a
  valid review outcome.
- At a phase boundary, walk every open entry with the user and settle its
  decision — keep, condense, move, escalate, or dismiss — before the next
  phase starts.

## Open suggestions

- **Trickster config is not tracked.** The live bar reads
  `~/.config/trickster/{settings.json,outputs.conf}`, but those files are
  outside this checkout and `setup.sh` does not link them. Decide whether to
  track them here or in `~/GitHub/trickster`.
- **Arch lists are curated, `backup.sh` is a full snapshot.** Running
  `arch/backup.sh` (or the pacman hook) replaces the curated install list
  with every explicit package. Decide whether to split curated install lists
  from full snapshots before running it.
- **SSH is 2FA, not TOTP-only.** `private/pam.d/sshd` requires TOTP plus the
  account password via `system-remote-login`. If TOTP-only is intended, drop
  the `auth include system-remote-login` line in the private repo and retest
  from a local TTY before relying on it.
- **ccls ESP include paths are pinned to one toolchain build.**
  `nvim/lua/daze/lspconfig.lua` hardcodes `esp-15.2.0_20251204` and libstdc++
  15.2.0 paths; after an ESP-IDF update ccls points at missing headers. Derive
  from the newest `~/.espressif/tools/xtensa-esp-elf/*` or compile_commands.
- **waybar package remains installed after its config was removed.**
  `pacman -Q waybar` is still present; `arch/backup.sh` would put it back in a
  full snapshot. Remove it with a go-ahead if it is no longer wanted.
- **spotify-player config is unused.** `spotify_player` is not installed while
  `spotify-launcher` is; `~/.config/spotify-player` and the `spty` alias have
  no consumer. Install the TUI or remove both.
