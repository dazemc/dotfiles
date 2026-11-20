# Dotfiles

An Arch Linux workstation defined as files, activated by symlinks.

The repository is checked out at `~/GitHub/dotfiles` and `setup.sh` links
each area into its live path (`~/.config/hypr`, `~/.config/nvim`,
`~/.tmux.conf`, …). There is no build step between an edit here and the
running system — a bad symlink or a bad config breaks the session that is
editing it. That is the whole discipline of this repo.

## Goal

One checkout reproduces the workstation: Hyprland compositor config,
the external trickster bar, shell, tmux, Neovim, and app configs, installed
by symlinking, never by copying. Every file is either live (symlinked into
`$HOME` or `$XDG_CONFIG_HOME`) or explicitly legacy. Nothing is both, and
nothing is neither.

The work queue lives in `.llm/todo.md`, in build order. Work it top-down one
step at a time, on the working branch (see Repository workflow):

1. Implement the step, nothing more.
2. Prove it without breaking the live session: syntax-check what you
   touched (`bash -n`, `shellcheck` where available, `hyprctl reload`
   semantics for Hyprland, `tmux source-file` for tmux, a trickster
   restart of the bar process only), and exercise what the step changed.
   A step that parses but misbehaves at runtime is not done. If the
   done-criteria needs eyes on screen, hand the user the exact run-and-look
   commands and wait for their verdict — never substitute screenshots.
3. Re-read the topical notes under `.llm/` and update the matching file —
   but only if something is absolutely needed. `.llm/suggestions.md` is for
   agent-proposed, user-reviewed findings that may escalate to `todo.md`.
   Silence is a valid review outcome; never add noise to justify the read.
4. Only then remove the step from `.llm/todo.md`.
5. Commit in slices: the config change is one commit; every LLM-maintained
   markdown file (`.llm/todo.md`, `.llm/suggestions.md`, docs) gets its own commit.
   Markdown never shares a commit with config, and two markdown files never
   share a commit with each other.

Never remove an unverified step. A step is one action with one done-criterion;
split work that spans Hyprland, trickster, shell, and tmux into separate steps.
Never batch multiple steps into one change. Never check steps off — remove
them. Do not let the queue rot.

## What it is

- Hyprland configuration in Lua: `hyprland/hypr/hyprland.lua` requiring
  `hypr/conf/*.lua` (monitor, autostart, envars, keybindings, …) plus
  `hypr/scripts/*` helpers and `hypridle.conf`. Symlinked to
  `~/.config/hypr` by `setup.sh`.
- The live bar is trickster, configured in its own checkout outside this
  repo. `archive/quickshell/` is retired QML kept for reference, is not
  linked, and is not autostarted; the old bar configuration has been removed.
- Shell config: `shell/bash/.bashrc`, `shell/bash/lsp_util.sh`,
  `shell/.alias`, `shell/zsh/.zshrc`.
- tmux config: `tmux/.tmux.conf` with plugins managed as git submodules
  under `tmux/.tmux/plugins/` (tpm is not used; do not reintroduce it).
- Neovim config as a git submodule at `nvim/` (`lazy.nvim`-based, owned
  upstream). Edits belong in the nvim repository, not as local overrides.
- App configs: `msmtp/config`, `environment.d/`.
- Machine provisioning: `arch/` package lists (`pkglist.txt`,
  `foreignpkglist.txt`) with `install.sh` / `backup.sh`.
- `private/` as a git submodule holding machine-specific secrets and
  system config (SSH configs, pam.d, msmtp credentials), applied by
  `private/setup.sh` under sudo.

## What it is not

- Not an installer distribution. `setup.sh` and `arch/install.sh` assume
  Arch Linux and this checkout layout; do not generalize them to other
  distros or turn them into interactive wizards.
- Not a public store. `msmtp/smtp.env` is gitignored and `private/` is a
  separate repository. Contents may be read for verification; never print
  or commit credentials, tokens, or mail auth.
- Not the bar. The live bar is trickster, configured outside this checkout;
  `archive/quickshell/` is retired QML and is not linked. Do not extend the
  legacy bar or wire it into autostart.
- Not a copy-based config. The live system reads these files through
  symlinks. Never copy a file into `~/.config` to "test" — fix the link
  map instead.
- Not the nvim config. The `nvim/` submodule is owned by its own repo;
  this repo only pins it.

## Architecture

```text
dotfiles
  setup.sh            symlink map: repo path -> live path (see .llm/structure.md)
  hyprland/hypr/      hyprland.lua + conf/*.lua + scripts/  -> ~/.config/hypr
  archive/            retired config (quickshell/), never linked
  shell/              .bashrc, .alias, zsh                   -> ~/, via individual links
  tmux/               .tmux.conf + plugin submodules         -> ~/
  nvim/               submodule                             -> ~/.config/nvim
  private/            submodule, sudo-applied               -> system paths
```

The symlink map in `.llm/structure.md` is authoritative for where each file
lands. `setup.sh` implements that map; when map and script disagree, fix the
script in the same session and record the finding.

## Configuration

Config languages are per-area and stay per-area: Lua for Hyprland,
shell for shell/tmux glue.
Do not invent a shared templating layer, a config generator, or a second
way to express the same setting.

Live reload is per-area and non-destructive: `hyprctl reload` for Hyprland,
restart only the trickster process, `tmux source-file ~/.tmux.conf`
for tmux, a new shell for shell changes. Invalid files keep last-good state
where the tool supports it; never leave the session without a working bar,
compositor config, or shell.

## Instruction precedence

One explicit hierarchy, from most to least authoritative. A lower file never
overrides a higher one; on a conflict the higher file wins and the lower one
is corrected in the same session.

```text
AGENTS.md             authoritative rules — the constitution
.llm/workflow.md      process interpretation of those rules
.llm/*.md             domain knowledge and contracts
.llm/todo.md          currently authorized work, in build order
.llm/suggestions.md   non-authoritative observations
```

- `AGENTS.md` is authoritative. It answers what the repo is and how every
  change is made.
- `.llm/workflow.md` interprets the process — branches, commits, phases — and
  never adds or bends a rule.
- `.llm/structure.md` holds the symlink map, submodule list, and area
  contracts derived from the constitution.
- `.llm/todo.md` grants exactly the work it lists, top-down, one step at a
  time; a step never authorizes more than itself.
- `.llm/suggestions.md` is non-authoritative. Entries inform decisions but
  bind nothing until the user escalates them.

## Repository workflow

- `master` is the stable branch. Exactly one working branch, `working`, exists
  beside it and carries the config steps of the phase at the top of
  `.llm/todo.md` that still has steps. No other branches exist.
- Config lands on `working`; markdown lands on `master`. `AGENTS.md`, every file
  under `.llm/`, and docs pages commit directly on `master`, immediately, one
  file per commit, and are pushed. Do this in the short-lived worktree created
  by `./docs.sh`; never switch the live checkout to `master`: `~/.config/hypr`
  and the other live paths read this tree, so a branch switch can serve older
  config to the running session. After each markdown commit, merge `master`
  back into `working` so the tree keeps reading current docs.
- Never start a new phase without the user's explicit go-ahead in chat: no
  branch, no first step, until asked. Merging a finished phase likewise
  waits for confirmation.
- Commit every finished TODO step as a slice: one config commit on `working`,
  then one commit per touched markdown file on `master` via the `./docs.sh`
  worktree (commit and push from there, then `./docs.sh --close` merges
  `master` into `working` and removes the worktree). A step is
  finished only when it is implemented, verified in the live session without
  breaking it, and removed from `.llm/todo.md`. Markdown never shares a
  commit with config or with another markdown file.
- When a phase's steps are all landed and removed, merge `master` into
  `working` first so the PR carries config only, merge `working` into `master`
  through a pull request, then reset `working` to the updated `master` for
  the next phase. No branch is created per phase.
- Commits use the contributor's configured Git identity. Follow
  `scope: summary` in the imperative.
- Any update to `AGENTS.md` itself is committed immediately on `master`, in
  its own commit, in the same session — a constitution change never sits
  uncommitted in the tree. The same applies to every file under `.llm/`.
- Keep the tree syntax-clean. Check what you touch (`bash -n` /
  `shellcheck`, `hyprctl reload` semantics, `tmux source-file`) before pushing.
- After every change, review the touched config for misses (dead symlinks,
  live/legacy confusion, secret leaks, docs gaps) and append anything that meets
  the bar to `.llm/suggestions.md`; findings never live only in the
  transcript.
- After each phase is merged, walk every open suggestion with the user and
  settle its decision — keep, condense, move, escalate, or dismiss — before
  the next phase starts.
- Networked Git/GitHub commands (`fetch`, `push`, `gh`) run outside any
  sandbox; sandboxed credential or network failures are not authoritative.

## Never break the live system

The checkout is symlinked into the running session. Every rule here follows
from that.

- Never run `setup.sh` or `update.sh` without the user's explicit go-ahead
  in chat. `setup.sh` deletes live paths (`rm -rf` on `~/.bashrc`,
  `~/.tmux.conf`, `~/.config/nvim`, …) before relinking, and invokes
  `private/setup.sh` under sudo. `update.sh` moves every submodule.
  Either one can take the session down; both wait for confirmation.
- Never switch the live checkout's branch. Markdown work goes through
  `./docs.sh`; a checkout of `master` in the live tree can break the running
  session (2026-11-20: `conf.monitor` not found and a 60 Hz fallback on the
  next reload).
- Prefer targeted verification over reinstalling: re-source, `hyprctl
  reload`, restart only the trickster process, `tmux source-file`. Reach
  for `setup.sh` only when the link map itself changed, and say so first.
- Never log out, terminate, restart, or otherwise stop the user's local
  graphical session on the user's behalf. When testing requires restarting
  the bar, restart only the trickster process — never the compositor — and
  wait for explicit confirmation before touching session targets, the display
  manager, reboot, or power off.
- Never touch `arch/install.sh` behavior without a go-ahead: it installs
  system packages and builds an AUR helper. Reading the package lists is
  fine; installing from them is not, until asked.
- Private is readable, secrets are not committable: traversing and reading
  `private/` and `msmtp/smtp.env` is allowed for verification and link-map
  work. Never print secrets (credentials, tokens, mail auth) into chat or
  logs, and never commit any file containing them. Running
  `private/setup.sh` still needs the user's explicit go-ahead in chat.

## Verify

```sh
bash -n shell/bash/.bashrc shell/.alias   # shell syntax, no execution
shellcheck setup.sh update.sh              # when shellcheck is installed
hyprctl reload                             # Hyprland, only with a go-ahead
tmux source-file ~/.tmux.conf              # tmux, live and non-destructive
trickster --check                          # bar preflight; restart only trickster
```

A first checkout requires network access (submodules, Arch packages);
subsequent edits reuse the tree. Verify visuals on the native Wayland
session only; when a change cannot be verified headless, hand the user the
exact run-and-look commands and wait for their verdict instead of routing
around it.
