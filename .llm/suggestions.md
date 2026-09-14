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

- **No read-only health check for the link map.** The dead `quickshell`
  link label shipped silently because nothing verifies the map — `setup.sh`
  is the only consumer and it needs a go-ahead. Add a read-only
  `diagnose.sh` (symlinks resolve, pins resolve, required binaries present,
  no secrets staged) runnable anytime without sudo.
- **Backups have no restore path.** `setup.sh` and `private/setup.sh` now
  move replaced config to timestamped dirs, but nothing can put them back.
  Add a restore step (re-link from a chosen backup dir) under the same
  go-ahead rule, before the first real backup is ever needed.
- **trickster bar is WIP, not queue work yet.** `~/GitHub/trickster` will
  replace `waybar/` and `quickshell/`, but it is still under construction.
  Leave both legacy bars untouched until it ships; re-escalate the landing
  (autostart + link map + retire legacy) when it runs.
