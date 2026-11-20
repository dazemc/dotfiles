# Dotfiles workflow

Process interpretation of `AGENTS.md`. On a conflict the constitution wins and
this file is corrected.

## Branches and slices

- `master` is stable; `working` carries the config phase at the top of
  `.llm/todo.md` that still has steps.
- Config commits land on `working`. Markdown commits land on `master` through
  the `./docs.sh` worktree, one file per commit, and are pushed. After each
  markdown commit, merge `master` back into `working` so the live tree reads
  current docs.
- A step is finished only when it is implemented, verified in the live session
  without breaking it, and removed from `.llm/todo.md`. Never check a step off;
  remove it. Never remove an unverified step.
- Never batch steps. One action, one done-criterion, one config commit, then
  the matching markdown commits.
- Do not start a phase or merge `working` into `master` without the user's
  explicit go-ahead in chat.
- When a phase is complete: merge `master` into `working` so the PR carries
  config only, merge `working` into `master` through a pull request, then reset
  `working` to the updated `master` for the next phase. No branch per phase.
- Commits use the contributor's identity and `scope: summary` in the
  imperative.

## Markdown commits

The live session reads this checkout through symlinks, and `master` is older
than `working` for config. A `git checkout master` in the live tree can serve
stale Hyprland/shell/tmux files to the running session; this broke a reload on
2026-11-20. Use the worktree instead:

```sh
wt="$(./docs.sh)"                 # creates/reuses $TMPDIR/dotfiles-docs on master
cd "$wt"
git add <one-markdown-file> && git commit -m "docs: ..."
git push origin master
cd -                              # live checkout, still on working
./docs.sh --close                 # merge master into working, remove the worktree
```

`docs.sh` refuses to run unless the live checkout is on `working`; if it says
the worktree is not on `master`, stop and inspect instead of switching the
live checkout.

## setup.sh and update.sh

Both wait for the user's explicit go-ahead. `setup.sh` backs up and replaces
live paths (`~/.bashrc`, `~/.tmux.conf`, `~/.config/nvim`, `~/.config/hypr`,
…), fills an unset global Git identity, and invokes `private/setup.sh` under
sudo. Run it only when the link map itself changed, and say so first.

`update.sh` fast-forwards every submodule to its branch tip. Review each pin
move as its own step; never commit the batch blind. A first checkout needs
`git submodule update --init --recursive`, `setup.sh`, and the Arch packages;
day-to-day config work re-runs none of them.

## Verifying without breaking the live session

- Shell: `bash -n`; `shellcheck` when installed. Source in a fresh test shell,
  never by re-sourcing the login shell mid-session.
- tmux: `tmux source-file ~/.tmux.conf`.
- Hyprland: `luac -p`; `hyprctl configerrors` (read-only); reload only with a
  go-ahead, then confirm the compositor and monitor are healthy.
- trickster: `trickster --check`; restart only the bar process, never the
  compositor.
- Link map and secrets: `./diagnose.sh`, read-only, exit 1 on failure.
- nvim: only verify the submodule pin resolves; edits belong upstream.
- msmtp / `private/`: verify by variable name and path. Never cat credentials,
  never send test mail with real auth until asked.

When a change cannot be verified headless, give the user the exact run-and-look
commands and wait for their verdict. Do not route around missing eyes with
screenshots or assumptions.

## Graphical session and privacy

Never log out, terminate, restart, or stop the user's local session on their
behalf. Restart only the trickster process when the bar must be tested; wait
for explicit confirmation before touching session targets, the display
manager, reboot, or power off.

`private/` and `msmtp/smtp.env` are readable for verification and link-map
work; values are never printed, logged, or committed. A change that needs a
secret value stops at the variable name and hands the run-and-look step to the
user.
