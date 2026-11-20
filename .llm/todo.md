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

Phase: Linode server install. Source: user objective of 2026-11-20 (install
option for `daze@10.100.0.20`).

1. **Add a server install path.** Add `arch/server-pkglist.txt` and
   `arch/server-install.sh` for a headless Arch target: read-only `--check`,
   `--dry-run`, package install over SSH, and optional safe shell/tmux/nvim
   linking without `private/setup.sh`. Auth uses SSH keys or an interactive
   prompt; never a stored password. Done: `bash -n`/`shellcheck` pass,
   `--dry-run` prints the plan, `--check` works against the target, and the
   password is not written anywhere. Size S.
