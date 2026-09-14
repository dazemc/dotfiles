# dotfiles

Arch workstation defined as files, activated by symlinks (`setup.sh`).
`AGENTS.md` is the constitution; `.llm/` holds the workflow and work queue.

## Fresh checkout

```sh
git clone --recurse-submodules git@github.com:dazemc/dotfiles.git ~/GitHub/dotfiles
cd ~/GitHub/dotfiles
git submodule update --init --recursive
bash -n setup.sh && shellcheck setup.sh  # verify first: it rewrites live paths
./setup.sh                                # explicit go-ahead only: backs up live config, relinks, sets git identity, runs private/setup.sh under sudo
```

## Day to day

- `./update.sh` fast-forwards every submodule to its branch tip — review each pin move as its own step.
- `arch/backup.sh` regenerates the pacman lists; `arch/install.sh` reinstalls from them (plus the aura AUR helper).
- Verify without reinstalling: `hyprctl reload`, restart only the shell process for Quickshell, `tmux source-file ~/.tmux.conf`.
