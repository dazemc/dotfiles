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

- **trickster bar is WIP, not queue work yet.** `~/GitHub/trickster` will
  replace `waybar/` and `quickshell/`, but it is still under construction.
  Leave both legacy bars untouched until it ships; re-escalate the landing
  (autostart + link map + retire legacy) when it runs.
- **hypridle DPMS calls use the wrong hyprctl vehicle.**
  `hyprland/hypr/hypridle.conf` and `scripts/hypridle-dpms-off` send Lua
  (`hl.dsp.dpms(...)`, valid API in 0.56) via `hyprctl dispatch`, which only
  takes dispatcher names — Lua goes through `hyprctl eval`. Swap the
  vehicle, keep the code (verified `hl.dsp.dpms` exists via eval asserts).
- **Two dead screenshot-dir vars with mismatched names.** `conf/envars.lua`
  sets `HYPERSHOT_DIR` while `enviroment.d/99-hyperland.conf` sets
  `HYPRSHOT_DIR`; `hyprcap` reads neither (takes `-o` or XDG defaults, and
  the binds pass no `-o`). Delete both or wire one through with `-o`.
- **tmux `w` names every window literally `%%`.** `tmux/.tmux.conf` binds `w`
  to `new-window -n '%%'`, but `%%` only expands inside `command-prompt`
  (like the `t` bind below it). Drop the `-n` flag or prompt for a name.
- **SSH access recipe lives only in the config.** `private/ssh/sshd_config`
  runs PAM-only auth (no pubkey, no password) on port 2020 for `daze`, and
  `private/setup.sh` overwrites the live files — a bad edit or PAM failure
  locks out remote access. Record the login recipe and recovery path.
