# dotfiles

Arch Linux workstation defined as files and activated by symlinks (`setup.sh`).
`AGENTS.md` is the constitution; `.llm/` holds the workflow, structure map,
queue, suggestions, and agent org chart.

## Fresh checkout

```sh
git clone --recurse-submodules git@github.com:dazemc/dotfiles.git ~/GitHub/dotfiles
cd ~/GitHub/dotfiles
git submodule update --init --recursive
bash -n setup.sh && shellcheck setup.sh  # verify first: it rewrites live paths
./setup.sh                                # go-ahead only: backs up live config, relinks, runs private/setup.sh under sudo
```

## Day to day

- Markdown commits (`AGENTS.md`, `.llm/`, docs) go through `./docs.sh`:
  `wt="$(./docs.sh)"`, commit and push from `$wt`, then `./docs.sh --close`.
  The live checkout stays on `working`; never switch its branch.
- `./update.sh` fast-forwards every submodule to its branch tip — review each
  pin move as its own step.
- `arch/backup.sh` writes full explicit package snapshots; `pkglist.txt` and
  `foreignpkglist.txt` are curated install lists, so review the diff before
  committing a regeneration. `arch/install.sh` installs from them plus the aura
  AUR helper.
- Verify without reinstalling: `./diagnose.sh`, `hyprctl configerrors` (read
  only), restart only the trickster process, `tmux source-file ~/.tmux.conf`.

## Server install

`arch/server-install.sh` provisions a headless Arch target over SSH from
`arch/server-pkglist.txt`:

```sh
./arch/server-install.sh --host daze@10.100.0.20 --check  # read-only report
./arch/server-install.sh --host daze@10.100.0.20 --dry-run
./arch/server-install.sh --host daze@10.100.0.20          # packages + links
```

It ranks pacman mirrors with `reflector` before installing (backs up
`/etc/pacman.d/mirrorlist` and enables `reflector.timer`; `--no-mirrors` skips
this). Auth is SSH key or an interactive prompt; the remote sudo password is
prompted on the TTY and never stored. `--no-config` installs packages only;
`--no-packages` links shell/tmux/nvim only. Server-local `~/.tmux.conf` and
`~/.config/msmtp/config` are preserved, and a dirty checkout skips updates. It
never runs `private/setup.sh`.

## Layout

Live configs are symlinked from `hyprland/`, `shell/`, `tmux/`, `nvim/`,
`msmtp/`, and `environment.d/`. Retired config lives in `archive/` and is never
linked. Agent roles and delegation are in `.llm/org-chart.md`.
