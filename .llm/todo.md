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
