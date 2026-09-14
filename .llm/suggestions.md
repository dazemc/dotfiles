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

- **msmtp auth has no documented provider.** `msmtp/config` needs env vars whose
  only sources are `msmtp/smtp.env` (gitignored) and `private/bash/.env`
  (unreadable by policy), so no agent can verify mail config end-to-end.
  Document which file provides what (names only) in `.llm/structure.md`.
- **README documents nothing.** It holds one submodule command; install order
  (submodule init → `setup.sh` → sudo `private/setup.sh`), `update.sh`, and
  `arch/` scripts are undiscoverable. Write the 10-line install/verify order
  before the next fresh checkout has to rediscover it.
