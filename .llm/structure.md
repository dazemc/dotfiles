# Dotfiles structure

The live system reads this checkout through symlinks installed by `setup.sh`.
`setup.sh` is the implementation; this map is the contract. When they disagree,
fix the script in the same session and record the finding.

## Symlink map (repo path → live path)

| Repo path | Live path | Status |
| --- | --- | --- |
| `shell/.alias` | `~/.alias` | live (linked unconditionally) |
| `shell/bash/.bashrc` | `~/.bashrc` | live |
| `nvim/` | `~/.config/nvim` | live (submodule) |
| `tmux/.tmux/` + `tmux/.tmux.conf` | `~/.tmux/` + `~/.tmux.conf` | live, explicit links |
| `msmtp/config` | `~/.config/msmtp/config` | live (the dir is created; only the file is linked) |
| `hyprland/hypr/` | `~/.config/hypr` | live (directory link) |
| `environment.d/` | `~/.config/environment.d` | live (directory link; read at login) |
| `shell/zsh/.zshrc` | `~/.zshrc` | macOS-only; backed up and linked only when `uname -s` is Darwin |
| `archive/quickshell/` | (nowhere) | retired QML; trickster is the live bar |
| `archive/spotify-player/` | (nowhere) | unused TOML for the absent `spotify_player` TUI |
| `arch/`, `archive/`, `.llm/`, `docs.sh`, `update.sh`, `README.md` | (nowhere) | tooling and docs, never linked |

`setup.sh` also runs `private/setup.sh` under sudo and fills in the global Git
identity only when it is unset. Both are go-ahead operations.

## Submodules

| Path | Upstream | Branch pin |
| --- | --- | --- |
| `nvim` | `git@github.com:dazemc/nvim.git` | `master` |
| `private` | `git@github.com:dazemc/private_dotfiles.git` | `master` |
| `tmux/.tmux/plugins/tmux-battery` | `tmux-plugins/tmux-battery` | `master` |
| `tmux/.tmux/plugins/tmux-cpu` | `tmux-plugins/tmux-cpu` | `master` |
| `tmux/.tmux/plugins/tmux-df` | `tassaron/tmux-df` | `main` |
| `tmux/.tmux/plugins/tmux-online-status` | `tmux-plugins/tmux-online-status` | `master` |
| `tmux/.tmux/plugins/tmux-ping` | `ayzenquwe/tmux-ping` | `master` |
| `tmux/.tmux/plugins/tmux-prefix-highlight` | `tmux-plugins/tmux-prefix-highlight` | `master` |

`tmux-battery` stays pinned but is not loaded: the host has no battery, its
status segment is commented out, and the load line/options were removed.

## Area contracts

- **Hyprland:** `hyprland/hypr/hyprland.lua` requires `conf.monitor`,
  `conf.autostart`, `conf.envars`, `conf.permissions`, `conf.aesthetics`,
  `conf.misc`, `conf.input`, `conf.keybindings`, and `conf.windows`;
  `conf/programs.lua` is shared by autostart and keybindings. Autostart starts
  trickster and never Quickshell. `hypridle` is intentionally disabled
  (2026-11-11); re-enable it in `autostart.lua` only after a locker and working
  DPMS are configured. The idle audio gate uses `scripts/audio-idle` (condition)
  and `scripts/audio-playing` (on-timeout guards).
- **Bar:** trickster is the live bar, configured in its own checkout outside
  this repo. `archive/quickshell/` is retired QML; do not extend it or wire it
  into autostart.
- **Shell:** `.bashrc` sources `~/.alias` and, if present,
  `private/bash/.env`. `lsp_util.sh` copies a file read-only into `/tmp` and
  removes it on exit. No tpm; plugins load through explicit `run-shell` lines.
- **tmux:** plugins are git submodules loaded by explicit `run-shell` lines.
  Do not reintroduce tpm. Battery is pinned but unloaded.
- **nvim:** owned upstream (`lazy.nvim`). This repo pins the commit only; edits
  belong in the nvim repository.
- **msmtp:** `msmtp/config` reads `SMTP_USER` from `msmtp/smtp.env` (gitignored,
  hardlinked by `private/setup.sh`) and evaluates `SMTP_PASS` from
  `private/bash/.env`. Verified by name; values never read or committed.
- **private:** machine-specific secrets and system config applied by
  `private/setup.sh` under sudo. Readable for verification; running it needs a
  go-ahead. `private/bash/.env` stays mode 600.
- **environment.d:** `99-hyprland.conf` exports `HYPRLAND_CONFIG` and the Qt
  Wayland logging rule. systemd reads it at login only; verify structurally
  (`readlink`, `cat`) until the next login.
- **archive:** `archive/` holds retired config and is never linked or
  autostarted. `archive/README.md` states the policy; restoring an entry is a
  reviewed step that re-adds its links.
- **Tools:** `diagnose.sh` verifies the map read-only (labels, sources,
  symlink targets, pins, binaries, secret modes), exits 1 on failure.
  `restore.sh [--dry-run] <backup-dir>` puts back config `setup.sh` moved aside;
  real runs need a go-ahead. `update.sh` moves every submodule and needs a
  go-ahead. `docs.sh` creates the short-lived master worktree for markdown
  commits; it is never linked.
- **arch:** `pkglist.txt` / `foreignpkglist.txt` are curated install lists.
  `backup.sh` regenerates full explicit snapshots into them, so review the diff
  before committing a regeneration. `install.sh` installs from them plus the
  aura AUR helper and must run as a normal user; installing needs a go-ahead.
