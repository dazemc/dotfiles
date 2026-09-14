# Dotfiles structure

Domain knowledge subordinate to `AGENTS.md` and `.llm/workflow.md` (see
`AGENTS.md` → Instruction precedence); on a conflict the higher document wins
and this file is corrected.

The live system reads this repo through symlinks installed by `setup.sh`.
`setup.sh` is the implementation; this map is the contract. When they
disagree, fix the script and record the finding.

## Symlink map (repo path → live path)

| Repo path | Live path | Status |
| --- | --- | --- |
| `shell/.alias` | `~/.alias` | live (linked unconditionally) |
| `shell/bash/.bashrc` | `~/.bashrc` | live |
| `nvim/` | `~/.config/nvim` | live (submodule, see below) |
| `tmux/.tmux/` + `tmux/.tmux.conf` | `~/.tmux/` + `~/.tmux.conf` | live, via a `tmux/.*` glob — fragile, see suggestions |
| `spotify-player/` | `~/.config/spotify-player` | live (directory link) |
| `msmtp/config` | `~/.config/msmtp/config` | live (file link; the dir is created, only the file is linked) |
| `hyprland/hypr/` | `~/.config/hypr` | live (directory link; covers `hyprland.lua`, `conf/`, `scripts/`, `hypridle.conf`) |
| `quickshell/` | `~/.config/quickshell` | BROKEN — `setup.sh` case label has a trailing space (`"quickshell "`) and never matches |
| `enviroment.d/` | `~/.config/enviroment.d/` | BROKEN — `setup.sh` case label says `"environment.d"` but the list entry is `"enviroment.d"`; also deleted with a trailing slash |
| `shell/zsh/.zshrc` | (nowhere) | not linked by `setup.sh` at all |
| `waybar/` | (nowhere) | legacy; superseded by Quickshell, not linked, not autostarted |
| `arch/`, `update.sh`, `README.md` | (nowhere) | tooling, never linked |

`setup.sh` also sets global git identity and runs `private/setup.sh` under
sudo — both side effects outside the link map, both reasons it needs a
go-ahead (see `.llm/workflow.md`).

## Submodules

| Path | Upstream | Branch pin |
| --- | --- | --- |
| `nvim` | `git@github.com:dazemc/nvim.git` | NONE — `update.sh` falls back to `master` |
| `private` | `git@github.com:dazemc/private_dotfiles.git` | `master` |
| `tmux/.tmux/plugins/tmux-battery` | `tmux-plugins/tmux-battery` | `master` |
| `tmux/.tmux/plugins/tmux-cpu` | `tmux-plugins/tmux-cpu` | `master` |
| `tmux/.tmux/plugins/tmux-df` | `tassaron/tmux-df` | `main` |
| `tmux/.tmux/plugins/tmux-online-status` | `tmux-plugins/tmux-online-status` | `master` |
| `tmux/.tmux/plugins/tmux-ping` | `ayzenquwe/tmux-ping` | `master` |
| `tmux/.tmux/plugins/tmux-prefix-highlight` | `tmux-plugins/tmux-prefix-highlight` | `master` |

## Area contracts

- Hyprland: `hyprland/hypr/hyprland.lua` requires `conf.*` modules
  (`monitor`, `autostart`, `envars`, `permissions`, `aesthetics`, `misc`,
  `input`, `keybindings`, `windows`); note `conf/programs.lua` exists but is
  only loaded via `autostart.lua`. Autostart launches the Quickshell process
  (`qs`) — never Waybar.
- Quickshell: `shell.qml` → `widgets/Bar.qml`; theme tokens in
  `themes/Colors.qml`, shared values in `config/Config.qml`, time service in
  `services/Time.qml`. This is the live bar.
- Shell: `.bashrc` sources `~/.alias` and, if present,
  `private/bash/.env`. `TMUX_PLUGIN_MANAGER_PATH` is exported but tpm is
  not used — plugins load via explicit `run-shell` lines in `.tmux.conf`.
- tmux: plugins are git submodules loaded by explicit `run-shell` lines.
  Do not reintroduce tpm.
- nvim: owned upstream (`lazy.nvim`-based). This repo only pins the commit;
  edits belong in the nvim repository.
- msmtp: `msmtp/config` (gmail account) requires exactly two env vars:
  `SMTP_USER` (`from`/`user`) and `SMTP_PASS` (`passwordeval`). `SMTP_USER`
  comes from `msmtp/smtp.env` (gitignored, hardlinked to `~/.config/msmtp/`
  by `private/setup.sh`) or the shell env; `SMTP_PASS` comes only from the
  shell env via `private/bash/.env` (sourced by `.bashrc` when present).
  Verified by name; values never read, never commit them.
- `private/`: machine-specific secrets and system config, applied by
  `private/setup.sh` under sudo. Readable for verification; never run
  without a go-ahead, never print or commit secrets. `bash/.env` exports
  `SMTP_USER`/`SMTP_PASS` (plus other machine creds); `msmtp/smtp.env`
  provides `SMTP_USER` and is hardlinked into `~/.config/msmtp/` by
  `private/setup.sh`.
- `private/ssh`: PAM-only access recipe. `sshd` listens on port 2020 for
  user `daze`: no pubkey, no password — keyboard-interactive TOTP from the
  enrolled authenticator device (`pam_google_authenticator` first in
  `pam.d/sshd`, `MaxAuthTries 3`). Login: `ssh -p 2020 daze@<host>`, then
  the verification code at the prompt. Lockout recovery is local-only:
  sign in on the machine itself (never over SSH), restore `/etc/ssh/*`
  from `/root/dotfiles-backup-*` or fix the repo files and re-run
  `private/setup.sh` (go-ahead required). No secrets or keys are recorded
  here by design.
- `diagnose.sh` verifies the map read-only (labels, sources, pins,
  binaries, secrets); run it anytime, no sudo, exit 1 on failure.
- `restore.sh [--dry-run] <backup-dir>` puts back config `setup.sh` moved
  aside; real runs need a go-ahead, dry runs anytime. System backups under
  `/root/` stay manual.
- `arch/`: `pkglist.txt` / `foreignpkglist.txt` are pacman package lists;
  `backup.sh` regenerates them, `install.sh` installs from them (plus an
  AUR helper build). Installing is a go-ahead operation.
