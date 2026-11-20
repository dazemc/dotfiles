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

Phase: archive and harden. Source: user objective of 2026-11-20 (archive
unused configs, optimize, fix bugs, add major-change suggestions). Executed
by the roster in `.llm/org-chart.md`.

11. **Final verification.** Run `diagnose.sh`, `bash -n`/`shellcheck` on
    touched scripts, a detached tmux parse, `hyprctl configerrors` (read
    only), and confirm every live link in the map. Done: all checks pass,
    output is pasted in the session, and the working tree is clean except
    the user's stashed whitespace change. Size S.
