# Dotfiles repository workflow

This file interprets `AGENTS.md` (see its Instruction precedence section) and
never overrides it; on a conflict the constitution wins and this file is
corrected.

- `master` is the stable branch. Exactly one working branch, `working`, exists
  beside it and carries the config steps of the phase at the top of
  `.llm/todo.md` that still has steps. No other branches exist.
- Config lands on `working`; markdown lands on `master`. `AGENTS.md`, every file
  under `.llm/`, and docs pages commit directly on `master`, immediately, one
  file per commit, and are pushed. After each markdown commit, merge `master`
  back into `working` so the tree keeps reading current docs.
- Every step is one action with one done-criterion; split work that spans
  Hyprland, Quickshell, shell, and tmux into separate steps. Never batch multiple
  steps into one change.
- Commit every finished TODO step as a slice: one config commit on `working`,
  then one commit per touched markdown file on `master` (switch to `master`,
  commit, push, switch back, merge `master` into `working`). A step is
  finished only when it is implemented, verified in the live session without
  breaking it, and removed from `.llm/todo.md`. Markdown never shares a
  commit with config or with another markdown file.
- Never start a new phase without the user's explicit go-ahead in chat: no
  branch, no first step, until asked. Merging a finished phase likewise
  waits for confirmation.
- When a phase's steps are all landed and removed, merge `master` into
  `working` first so the PR carries config only, merge `working` into `master`
  through a pull request, then reset `working` to the updated `master` for the
  next phase. No branch is created per phase.
- Commits use the contributor's configured Git identity. Follow
  `scope: summary` in the imperative.
- Any update to `AGENTS.md` itself is committed immediately on `master`, in
  its own commit, in the same session — a constitution change never sits
  uncommitted in the tree. The same applies to every file under `.llm/`.
- Keep the tree syntax-clean. Check what you touch (`bash -n` /
  `shellcheck`, `hyprctl reload` semantics, `tmux source-file`) before pushing.
- Submodule changes (pin moves in `nvim/`, `private/`, `tmux/.tmux/plugins/`)
  are config changes: they land on `working` as their own step, never bundled
  with the config edits that motivated them, and never via `update.sh`
  without a go-ahead (it pulls every submodule to its branch tip).
- After every change, review the touched config for misses (dead symlinks,
  live/legacy confusion, secret leaks, docs gaps) and append anything that meets
  the bar to `.llm/suggestions.md`; findings never live only in the
  transcript.
- After each phase is merged, walk every open suggestion with the user and
  settle its decision — keep, condense, move, escalate, or dismiss — before
  the next phase starts.
- Networked Git/GitHub commands (`fetch`, `push`, `gh`) run outside any
  sandbox; sandboxed credential or network failures are not authoritative.

## setup.sh and update.sh

Both scripts are session-level operations, not verification tools, and both
wait for the user's explicit go-ahead in chat.

- `setup.sh` deletes live paths (`rm -rf` on `~/.bashrc`, `~/.tmux`,
  `~/.tmux.conf`, `~/.config/nvim`, `~/.config/hypr`, …) before relinking,
  sets global git identity, and invokes `private/setup.sh` under sudo.
  Run it only when the link map itself changed (see `.llm/structure.md`),
  say so first, and confirm the user has a way back (working shell,
  committed tree) before it runs.
- `update.sh` initializes and fast-forwards every submodule to its
  configured branch tip. It moves `nvim/`, `private/`, and all tmux
  plugins at once; review each resulting pin move as its own step instead
  of committing the batch blind.
- A first checkout needs both (plus network): `git submodule update --init
  --recursive`, then `setup.sh`, then the Arch package install. Those three
  are install-time only. Day-to-day config work never re-runs them.

## Verifying without breaking the live session

The checkout is symlinked into the running session, so verification is
always targeted and non-destructive, per area:

- Shell: `bash -n` on what you touched; source only in a fresh test shell,
  never by re-sourcing the login shell mid-session. `shellcheck` when
  installed.
- tmux: `tmux source-file ~/.tmux.conf` — live and non-destructive.
- Hyprland: `hyprctl reload`, only with a go-ahead; an invalid config keeps
  last-good state in most paths, but confirm the compositor is healthy
  afterwards.
- Quickshell: restart only the shell process (`qs`), never the compositor.
- nvim: changes belong upstream; here, only verify the pin still resolves
  (`git submodule status nvim`).
- msmtp / `private/`: verify by name and path only. Never cat credentials,
  never send test mail with real auth, until the user asks.

When a change cannot be verified headless (bar layout, keybindings feel,
lock/idle behavior), hand the user the exact run-and-look commands and wait
for their verdict instead of routing around it.

## Graphical session control

Never log out, terminate, restart, or otherwise stop the user's local
graphical session on the user's behalf. When testing requires restarting the
bar, restart only the Quickshell process — never the compositor — and wait for
explicit confirmation before touching session targets, the display manager,
reboot, or power off.

## Privacy

`private/` (SSH configs, pam.d, msmtp credentials) and `msmtp/smtp.env`
are never read, printed, summarized, or committed. Refer to them by name
only. A change that needs a secret value (msmtp auth, API tokens) stops at
the variable name and hands the run-and-look step to the user.
