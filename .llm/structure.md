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
| `shell/.alias` | `~/.alias` | live (backed up and linked unconditionally) |
| `shell/bash/.bashrc` | `~/.bashrc` | live |
| `nvim/` | `~/.config/nvim` | live (submodule, see below) |
| `tmux/.tmux/` + `tmux/.tmux.conf` | `~/.tmux/` + `~/.tmux.conf` | live, explicit links |
| `msmtp/config` | `~/.config/msmtp/config` | live (file link; the dir is created, only the file is linked) |
| `hyprland/hypr/` | `~/.config/hypr` | live (directory link; covers `hyprland.lua`, `conf/`, `scripts/`, `hypridle.conf`) |
| `environment.d/` | `~/.config/environment.d` | live (directory link; systemd reads this spelling) |
| `shell/zsh/.zshrc` | `~/.zshrc` | macOS-only; backed up and linked only when `uname -s` is Darwin (Linux leaves the user's file alone) |
| `archive/quickshell/` | (nowhere) | retired QML; trickster is the live bar, not linked or autostarted |
| `arch/`, `archive/`, `.llm/`, `docs.sh`, `update.sh`, `README.md` | (nowhere) | tooling and docs, never linked |

`setup.sh` also runs `private/setup.sh` under sudo and fills in the global Git
identity only when it is unset — both side effects outside the link map, both
reasons it needs a go-ahead (see `.llm/workflow.md`).

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

## Area contracts

- Hyprland: `hyprland/hypr/hyprland.lua` requires `conf.*` modules
  (`monitor`, `autostart`, `envars`, `permissions`, `aesthetics`, `misc`,
  `input`, `keybindings`, `windows`); `conf/programs.lua` is required by both
  `autostart.lua` and `keybindings.lua`. Autostart launches trickster and
  never Quickshell or another legacy bar; `hypridle` is intentionally disabled
  (sleep/idle off since 2026-11-11) and is re-enabled in both `autostart.lua`
  and `hypridle.conf` when wanted. When re-enabled, `hypridle.conf` gates
  dim/DPMS/suspend on `scripts/audio-idle`, and each on-timeout guard skips
  while `scripts/audio-playing` succeeds.
- Bar: trickster is the live bar and is configured in its own checkout
  outside this repo. `archive/quickshell/` is retired QML and is not linked.
- Archive: `archive/` holds retired configuration (`quickshell/` today). It is
  never linked or autostarted; `archive/README.md` states the policy, and
  restoring an entry is a reviewed step that re-adds its links.
- `environment.d`: `99-hyprland.conf` exports `HYPRLAND_CONFIG` and the Qt
  Wayland text-input logging rule. systemd reads it at login only, so a
  relink or edit is verified structurally (`readlink`, `cat`) until the next
  login; it is not a live-reloadable file.
- Shell: `.bashrc` sources `~/.alias` and, if present,
  `private/bash/.env`; `lsp_util.sh` copies a file read-only into `/tmp` and
  removes it on exit. Plugins load via explicit `run-shell` lines in
  `.tmux.conf` (no tpm).
- tmux: plugins are git submodules loaded by explicit `run-shell` lines.
  Do not reintroduce tpm. `tmux-battery` stays pinned but is not loaded: this
  host has no battery, its status segment is commented out, and its options
  were removed with the load line.
- nvim: owned upstream (`lazy.nvim`-based). This repo only pins the commit;
  edits belong in the nvim repository.
- msmtp: `msmtp/config` (gmail account) reads `SMTP_USER` for both `from`
  and `user` through `eval echo ...`, and evaluates `SMTP_PASS` with
  `passwordeval printenv SMTP_PASS`. `SMTP_USER` comes from
  `msmtp/smtp.env` (gitignored, hardlinked to `~/.config/msmtp/` by
  `private/setup.sh`); `SMTP_PASS` comes from `private/bash/.env` (sourced
  by `.bashrc` when present). Verified by name; values never read, never
  commit them.
- `private/`: machine-specific secrets and system config, applied by
  `private/setup.sh` under sudo. Readable for verification; never run
  without a go-ahead, never print or commit secrets. `bash/.env` exports
  `SMTP_USER`/`SMTP_PASS` (plus other machine creds) and must stay mode 600;
  `msmtp/smtp.env` provides `SMTP_USER` and is hardlinked into
  `~/.config/msmtp/` by `private/setup.sh`.
- `private/ssh`: PAM access recipe. `sshd` listens on port 2020 for user
  `daze`: no pubkey, no SSH password auth; keyboard-interactive runs
  `pam_google_authenticator` TOTP and then the account password through
  `system-remote-login` (2FA), with `MaxAuthTries 3`. TOTP-only would require
  removing the `auth include system-remote-login` line. Login:
  `ssh -p 2020 daze@<host>`, then the verification code and password.
  Lockout recovery is local-only: sign in on the machine itself (never over
  SSH), restore `/etc/ssh/*` from `/root/dotfiles-backup-*` or fix the repo
  files and re-run `private/setup.sh` (go-ahead required). No secrets or keys
  are recorded here by design.
- `diagnose.sh` verifies the map read-only (labels, sources, symlink targets,
  pins, binaries, secret modes); run it anytime, no sudo, exit 1 on failure.
- `restore.sh [--dry-run] <backup-dir>` puts back config `setup.sh` moved
  aside, including `~/.alias` and `~/.config/environment.d`; real runs need a
  go-ahead, dry runs anytime. System backups under `/root/` stay manual.
- `arch/`: `pkglist.txt` / `foreignpkglist.txt` are the curated install
  lists. `backup.sh` regenerates full explicit snapshots into those same
  files, so review the diff before committing a regeneration; `install.sh`
  installs from them (plus an AUR helper build) and must run as a normal user.
  Installing is a go-ahead operation.
