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

1. [S] Back up system config in `private/setup.sh` instead of deleting.
   Replace the `rm -rf` of `/etc/ssh/*`, `/etc/pam.d/sshd`, and
   `/root/.config/nvim` with a move to a timestamped backup dir, and keep
   the go-ahead rule (sudo system paths — never run without asking).
   Done when a dry read shows every target either replaced or present in
   the backup. Note: the edit lands in the `private` submodule repo with
   a pin move here.
2. [S] Resolve the home dir from the environment in `private/setup.sh`.
   The `smtp.env` link target hardcodes `/home/daze`, breaking the per-OS
   direction. Done when the path builds from `$HOME`/equivalent and a dry
   read confirms no hardcoded usernames. Note: lands in the `private`
   submodule repo with a pin move here.
