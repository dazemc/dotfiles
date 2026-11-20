# dotfiles

Arch workstation defined as files, activated by symlinks (`setup.sh`).
`AGENTS.md` is the constitution; `.llm/` holds the workflow and work queue.

## Fresh checkout

```sh
git clone --recurse-submodules git@github.com:dazemc/dotfiles.git ~/GitHub/dotfiles
cd ~/GitHub/dotfiles
git submodule update --init --recursive
bash -n setup.sh && shellcheck setup.sh  # verify first: it rewrites live paths
./setup.sh                                # explicit go-ahead only: backs up live config, relinks, fills unset git identity, runs private/setup.sh under sudo
```

## Day to day

- `./update.sh` fast-forwards every submodule to its branch tip — review each pin move as its own step.
- `arch/backup.sh` writes full explicit package snapshots; `pkglist.txt` and `foreignpkglist.txt` are curated install lists, so review the diff before committing a regeneration. `arch/install.sh` installs from them (plus the aura AUR helper).
- Verify without reinstalling: `./diagnose.sh`, `hyprctl configerrors` (read only), restart only the trickster process, `tmux source-file ~/.tmux.conf`.
- Agent roles and delegation live in `.llm/org-chart.md`. `archive/` holds retired config (`quickshell/`, `spotify-player/`); it is never linked.
