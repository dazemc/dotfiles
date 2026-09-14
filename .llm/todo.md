# Dotfiles TODO

The work list, in build order. `AGENTS.md` is the constitution; this file is
the queue. Remove items as they land — do not check them off, do not let it
rot.

Authorized work only: the queue grants exactly the steps it lists, top-down,
and never overrides the constitution, `.llm/workflow.md`, or the domain notes
(see `AGENTS.md` → Instruction precedence).

Every step is one action with its own done-criteria. Work top-down, one step
at a time: implement it, verify it in the live session without breaking it
(see `AGENTS.md` → Verify), then remove it. Never remove an unverified step;
never batch multiple steps into one change.

Sizes: S <1 day, M 1–3 days, L 3+ days.

## Authorized work

1. [S] Back up live config in `setup.sh` instead of deleting. Replace the
   `rm -rf` of `~/.bashrc`, `~/.tmux*`, `~/.config/nvim|hypr|…` in
   `clearExistingConfig` with a move to a timestamped backup dir, and keep
   the go-ahead rule. Done when a dry run shows every live path either
   relinked or present in the backup, verified with `bash -n` and without
   running `setup.sh` on the live session.
2. [S] Link tmux paths explicitly in `setup.sh`. Replace the `tmux/.*` glob
   with direct links for `~/.tmux` and `~/.tmux.conf`. Done when a fresh-
   shell check shows both links resolving and `tmux source-file
   ~/.tmux.conf` succeeds without touching home.
3. [S] Land `trickster` (`~/GitHub/trickster`, WIP) as the live bar. It
   replaces both `waybar/` and `quickshell/`; until it ships, leave both
   untouched. Wire it into autostart and the link map, then delete the
   legacy bars or leave one-line pointers. Done when the running session
   shows exactly one live bar launched from autostart.
4. [S] Wire `shell/zsh/.zshrc` per OS in `setup.sh`. It is macOS-only
   (Homebrew paths) and never linked — `setup.sh` detects the OS and
   links it on macOS, skips on Arch. Done when a dry run links it only
   on macOS, verified with `bash -n` and without running `setup.sh`
   on the live session.
5. [S] Fix stale paths from the older layout. Correct the `lspread` alias
   to `shell/bash/lsp_util.sh` and replace the hardcoded `/home/username/`
   in `enviroment.d/99-hyperland.conf` (flag the misspelled dir/file names
   while there). Done when both paths resolve on the live tree, checked
   without executing anything.
6. [S] Pin the `nvim` submodule branch in `.gitmodules`. It omits `branch =`,
   so `update.sh` guesses `master` and aborts under `set -euo pipefail` when
   wrong. Done when `git submodule update --init nvim` resolves cleanly
   against the pinned branch.
7. [S] Document the msmtp auth providers by name in `.llm/structure.md`.
   `msmtp/config` needs env vars from `msmtp/smtp.env` (gitignored) and
   `private/bash/.env` — record which file provides what, names only,
   never values. Done when an agent can trace every required var to its
   source file without reading secrets.
