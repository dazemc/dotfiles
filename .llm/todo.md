# Dotfiles TODO

The work list, in build order. `AGENTS.md` is the constitution; this file is
the queue. Remove items as they land — do not check them off, do not let it
rot.

Authorized work only: the queue grants exactly the steps it lists, top-down,
and never overrides the constitution, `.llm/workflow.md`, or the domain notes
(see `AGENTS.md` → Instruction precedence).

Every step is one action with its own done-criteria. Work top-down, one step
at a time: implement it, verify it in the live session without breaking it
(see `AGENTS.md` → Verify), then remove it. Never remove an unverified step;
never batch multiple steps into one change.

Sizes: S <1 day, M 1–3 days, L 3+ days.

## Authorized work

1. [S] Send hypridle DPMS calls via `hyprctl eval`. Replace the `dispatch`
   vehicle in `hyprland/hypr/hypridle.conf` (dpms-off + 2x resume-on) and
   `scripts/hypridle-dpms-off`, keeping the Lua (`hl.dsp.dpms` verified
   present). Done when eval asserts pass on the edited lines and the user
   confirms idle dim, DPMS-off, and resume on the live session.
2. [S] Resolve the dead screenshot-dir vars. `conf/envars.lua` sets
   `HYPERSHOT_DIR` while `enviroment.d/99-hyperland.conf` sets
   `HYPRSHOT_DIR`; `hyprcap` reads neither. Delete both or pass one
   through the binds with `-o`. Done when exactly one source of truth
   exists and a test capture lands in the expected dir.
3. [S] Fix the tmux `w` window name. `tmux/.tmux.conf` binds `w` to
   `new-window -n '%%'`, but `%%` only expands inside `command-prompt`.
   Drop the `-n` flag or prompt for a name. Done when a fresh `w` window
   carries a sane name, checked with `tmux source-file ~/.tmux.conf`.
4. [S] Record the SSH access recipe and recovery path. `sshd_config` runs
   PAM-only auth on port 2020 for `daze` with no fallback, and the live
   files are overwritten by script. Write down the working login flow
   plus how to recover from a lockout (no secrets, no keys). Done when a
   locked-out admin can get back in following the doc alone.
