# Dotfiles suggestions

Agent-proposed, user-reviewed suggestions. If you see something the queue,
the constitution, or the config gets wrong — a dead symlink, a live-system
hazard, a config inconsistency, a docs gap — propose it here so the next
session sees it. Standing rules and instructions belong in `AGENTS.md`, not
here.

Non-authoritative: entries inform decisions but bind nothing until the user
escalates them to `.llm/todo.md` (see `AGENTS.md` → Instruction precedence).

## Rules

- Entries must be **absolutely needed**: they prevent a future mistake,
  unblock queued work, or record a decision with its reason. Brainstorming,
  nice-to-haves, and restatements of `.llm/todo.md` do not belong here.
- One entry per issue. Keep it to five lines: what, where, why, and what
  to do about it.
- Append after every change: review the touched code for misses and add
  entries that meet the bar; findings never live only in the transcript.
- Remove an entry in the same change that resolves it — same discipline as
  `.llm/todo.md`.
- After finishing any `.llm/todo.md` step, re-read this file and update it, but
  only if something meets the bar above. No obligatory edits. Silence is a
  valid review outcome.
- At a phase boundary, walk every open entry with the user and settle its
  decision — keep, condense, move, escalate, or dismiss — before the next
  phase starts.

## Open suggestions

- **Trickster config is not tracked.** The live bar reads
  `~/.config/trickster/{settings.json,outputs.conf}`, but those files are
  outside this checkout and `setup.sh` does not link them. Decide whether to
  track them here or in `~/GitHub/trickster`.
- **Arch lists are curated, `backup.sh` is a full snapshot.** Running
  `arch/backup.sh` (or the pacman hook) replaces the curated install list
  with every explicit package. Decide whether to split curated install lists
  from full snapshots before running it.
- **SSH is 2FA, not TOTP-only.** `private/pam.d/sshd` requires TOTP plus the
  account password via `system-remote-login`. If TOTP-only is intended, drop
  the `auth include system-remote-login` line in the private repo and retest
  from a local TTY before relying on it.
- **ccls ESP include paths are pinned to one toolchain build.**
  `nvim/lua/daze/lspconfig.lua` hardcodes `esp-15.2.0_20251204` and libstdc++
  15.2.0 paths; after an ESP-IDF update ccls points at missing headers. Derive
  from the newest `~/.espressif/tools/xtensa-esp-elf/*` or compile_commands.
- **Unused packages remain installed.** `waybar`, `quickshell` (now archived),
  and `hyprpaper` (awww handles the wallpaper) have no live config or process;
  `arch/backup.sh` would re-add them. Remove them with a go-ahead and keep the
  curated install lists in sync.
- **The live checkout is switched to `master` for docs commits.**
  `~/.config/hypr` points into this tree, so a checkout briefly serves
  master's older config to the running session; a reload in that window failed
  with `conf.monitor not found` and fell back to 60 Hz (2026-11-20). Use a
  separate `git worktree` for master docs, or keep the live tree on `working`.
- **Monitor and workspace rules are pinned to `HDMI-A-2`.** If the output name
  changes or the display is unplugged, `monitor.lua` and `windows.lua` silently
  fall back to default mode/placement and the 165 Hz mode is lost. Add a
  fallback `hl.monitor({ output = "", mode = "preferred" })` and derive the
  workspace monitor, then verify with `hyprctl monitors`.
- **Hyprland permissions are disabled.** `permissions.lua` leaves
  `ecosystem.enforce_permissions` and every allow rule commented out, so any
  client can request screencopy/plugin access. Enable it with an allowlist for
  grim, the portal, and hyprpm; permission changes need a compositor restart.
- **The tmux-battery submodule is now dead weight.** The load line and options
  are gone (no battery on this host), but `.gitmodules` and the 213K checkout
  remain. Remove the submodule in its own step, then drop it from
  `.llm/structure.md`; do not reintroduce tpm.
- **tmux probes the network twice and the CPU for ~1 s per refresh.**
  `tmux-online-status` and `tmux-ping` both run `ping`, and `tmux-cpu` runs
  `iostat -c 1 2`; at the 15 s interval this is constant background work.
  Consolidate to one `#()` probe or cache the values; the scripts live in
  submodules, so treat it as a major step.
- **`allow-passthrough on` exposes the outer terminal.** Any pane, including an
  SSH session, can emit raw escapes/OSC52 to the host terminal. Decide whether
  an image protocol needs it; otherwise set `allow-passthrough off` and keep
  `set-clipboard on` for normal copy.
- **`setup.sh` cannot repair a drifted link.** The live `.bashrc` and
  `environment.d` were real files for months while `diagnose.sh` only warned;
  running `setup.sh` would move good files aside and drop local changes. Add a
  gated `--relink`/`diagnose --fix` that backs up and recreates only mismatched
  links, and test it with a temp `HOME`.
- **Hypridle dim cannot work on this desktop.** `hypridle-dim` calls
  `brightnessctl -s set 10`, but there is no `/sys/class/backlight`; if idle is
  re-enabled the 150 s listener fails. Use DPMS/awww brightness or drop the dim
  listener, and test with `hypridle -c ... -v`.
