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

## Layout

Live configs are symlinked from `hyprland/`, `shell/`, `tmux/`, `nvim/`,
`msmtp/`, and `environment.d/`. Retired config lives in `archive/` and is never
linked. Agent roles and delegation are in `.llm/org-chart.md`.
