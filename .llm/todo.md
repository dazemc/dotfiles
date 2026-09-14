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

1. [S] Back up live config in `setup.sh` instead of deleting. Replace the
   `rm -rf` of `~/.bashrc`, `~/.tmux*`, `~/.config/nvim|hypr|…` in
   `clearExistingConfig` with a move to a timestamped backup dir, and keep
   the go-ahead rule. Done when a dry run shows every live path either
   relinked or present in the backup, verified with `bash -n` and without
   running `setup.sh` on the live session.
