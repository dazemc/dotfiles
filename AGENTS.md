# Dotfiles

An Arch Linux workstation defined as files and activated by symlinks. The
checkout is live: `~/.config/hypr`, `~/.bashrc`, `~/.tmux.conf`, and the other
paths below point straight into this tree. An edit here is an edit to the
running session, so the rules about the live system come before convenience.

## Non-negotiables

- Never run `setup.sh`, `update.sh`, or `private/setup.sh` without the user's
  explicit go-ahead in chat. `setup.sh` moves live paths aside and runs
  `private/setup.sh` under sudo; `update.sh` moves every submodule. Either can
  take the session down.
- Never switch this checkout's branch while the session is live. Markdown
  commits go through `./docs.sh` and a short-lived `master` worktree. A branch
  switch has already served older Hyprland files to a running session
  (2026-11-20: `conf.monitor` not found, monitor fell back to 60 Hz).
- Never log out, restart, or stop the graphical session. When a test needs the
  bar restarted, restart only the trickster process.
- Never print or commit secrets from `private/` or `msmtp/smtp.env`. Reading
  them by name/path for verification is allowed; values stay out of chat,
  logs, and commits.
- Never copy a file into `~/.config` to "test" it. Fix the link map in
  `setup.sh` and `.llm/structure.md` instead.

## Layout

- `hyprland/hypr/` — Hyprland config in Lua: `hyprland.lua` requires
  `conf/*.lua`, plus `scripts/*` and `hypridle.conf`. Symlinked to
  `~/.config/hypr`. Autostart launches trickster; `hypridle` is disabled.
- `shell/` — `bash/.bashrc`, `.alias`, `bash/lsp_util.sh`, and the macOS-only
  `zsh/.zshrc`. Linked into `~` individually.
- `tmux/` — `.tmux.conf` plus plugin submodules. tpm is not used; explicit
  `run-shell` lines load the plugins. `tmux-battery` is pinned but not loaded.
- `nvim/` — git submodule owned upstream (`lazy.nvim`); this repo only pins it.
- `private/` — git submodule of machine secrets and system config, applied by
  `private/setup.sh` under sudo.
- `environment.d/` — `99-hyprland.conf` (`HYPRLAND_CONFIG`, Qt logging rule),
  linked to `~/.config/environment.d`; read at login, not live-reloaded.
- `msmtp/config` — file linked into `~/.config/msmtp/`; auth comes from
  `private/bash/.env` and `msmtp/smtp.env` by variable name only.
- `arch/` — curated package lists and `install.sh` / `backup.sh`;
  `server-install.sh` provisions a headless target over SSH from
  `server-pkglist.txt`. Installing packages needs a go-ahead.
- `archive/` — retired config (`quickshell/`, `spotify-player/`). Never linked
  or autostarted; `archive/README.md` states the policy.
- `docs.sh` — process tooling for markdown commits; never linked.
- `.llm/` — workflow, structure map, queue, suggestions, org chart. Never
  linked.

## Workflow

- `master` is stable. `working` carries the config of the current phase.
- Config lands on `working`. Markdown (`AGENTS.md`, every `.llm/*.md`, README)
  lands on `master`, immediately, one file per commit, and is pushed.
- Markdown commits use the worktree helper:

  ```sh
  wt="$(./docs.sh)"
  cd "$wt"
  git add <one-markdown-file> && git commit -m "docs: ..."
  git push origin master
  cd -
  ./docs.sh --close      # merge master into working, remove the worktree
  ```

- Never commit config and markdown together, and never two markdown files in
  one commit.
- `.llm/todo.md` grants exactly the steps it lists, top-down. Work one step at
  a time; remove it only after implementation, live verification, and any
  docs updates. Never check steps off.
- Starting a new phase and merging `working` into `master` both wait for the
  user's explicit go-ahead.
- `.llm/suggestions.md` is non-authoritative. Entries inform decisions but
  bind nothing until the user escalates them to the queue.

## Verify

- Shell: `bash -n`, `shellcheck` when installed; source in a fresh test shell.
- Hyprland: `luac -p` the Lua files; `hyprctl configerrors` read-only; a
  reload only with a go-ahead. An invalid config keeps last-good state in most
  paths, but confirm the compositor is healthy afterwards.
- tmux: `tmux source-file ~/.tmux.conf` — live and non-destructive.
- trickster: `trickster --check`; restart only the bar process.
- Link map and secrets: `./diagnose.sh` (read-only, exit 1 on failure).
- nvim: changes belong upstream; here only verify the pin resolves.
- When a change needs eyes (bar layout, feel, lock/idle), hand the user the
  exact run-and-look commands and wait for their verdict. Evidence beats a
  screenshot, and a claim without a command is not evidence.

## Agent team

`.llm/org-chart.md` defines the operating model: CEO/Partner, Chief of Staff,
senior engineers, juniors, testers, security, release, and archive/docs. The
primary agent is the CEO/Partner: it stays available to the user, delegates
audits and edits, and integrates only work that passed an independent test.

## Instruction precedence

From most to least authoritative: this file, `.llm/workflow.md`, the other
`.llm/*.md` domain notes, `.llm/todo.md`, `.llm/suggestions.md`. A lower file
never overrides a higher one; on a conflict the higher file wins and the lower
one is corrected in the same session.
