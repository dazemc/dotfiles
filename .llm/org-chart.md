# Agent org chart

How work in this repository is delegated. The chart is an operating model, not
a promise of headcount: every role maps to a subagent session, and a small
change may collapse several roles into one session. Authority follows the
boxes — a tester never approves the change it tested, and a junior never
touches the live session.

```text
                              USER
                         (owner, final say)
                                |
                    +------------------------+
                    |  CEO / Partner         |  the primary agent
                    |  priorities, approvals |  user's single contact
                    |  final integration     |
                    +------------------------+
                                |
                    +------------------------+
                    |  Chief of Staff        |  triage, delegation,
                    |  runbook, status       |  keeps the CEO free
                    +------------------------+
          +---------------------+---------------------+---------------------+
          |                     |                     |                     |
  +---------------+     +---------------+     +---------------+     +---------------+
  | Engineering   |     | Quality       |     | Release       |     | Archive/Docs  |
  |               |     |               |     |               |     |               |
  | Senior        |     | Test Lead     |     | Release Mgr   |     | Archivist     |
  |  Hyprland     |     |  Static QA    |     |  docs.sh      |     |  moves, sweep |
  | Senior        |     |  Live QA      |     |  slices       |     | Docs Editor   |
  |  Shell/Tmux   |     | Security &    |     |               |     |  README/.llm  |
  | Senior        |     |  Privacy      |     |               |     |               |
  |  Systems      |     |               |     |               |     |               |
  | Juniors       |     |               |     |               |     |               |
  +---------------+     +---------------+     +---------------+     +---------------+
```

## Roles and authority

| Role | Owns | May do | Must not do |
| --- | --- | --- | --- |
| CEO / Partner | User relationship, priorities, risky approvals, phase merge | Ask the user, accept/reject work, integrate verified slices | Bulk implementation, test its own work, hide a failure |
| Chief of Staff | Queue, assignment, handoffs, status | Turn an objective into ordered TODO steps, spawn and reassign agents | Change scope or authorize live-system actions |
| Senior engineer | One domain: Hyprland, shell/tmux, systems | Audit, implement hard changes, review juniors | Approve its own change, run `setup.sh`/sudo without the CEO |
| Junior engineer | Bounded edits and inventories | Mechanical edits, reference sweeps, first-pass docs, evidence gathering | Touch live symlinks, secrets, `private/`, or destructive commands |
| Test Lead / Testers | Independent verification | Reproduce, run static/live checks, **veto** a slice | Edit the change under test, approve without evidence |
| Security & Privacy | Secrets, permissions, live hazards | Inspect `private/` by name/path, block a slice | Print secret values, commit credentials |
| Release Manager | Branch and commit discipline | Stage slices in the `docs.sh` worktree, merge `master` into `working`, open the PR | Bundle config with markdown, force-push, switch the live checkout |
| Archivist | `archive/`, reference sweeps | Move unused config, update every reference, record why | Delete history or archive something still live |
| Docs Editor | `README.md`, `.llm/`, `AGENTS.md` | Keep docs true to the tree | Invent rules or restate the TODO |

## Operating rules

1. **One step at a time.** Work top-down from `.llm/todo.md`; a step is one
   action with one done-criterion. No batching.
2. **Four gates.** Audit → implement → independent test → senior review. The
   CEO integrates only after the test gate passes.
3. **Separation of duties.** Authors never test or approve their own work;
   testers never edit the artifact; juniors never touch the live session.
4. **One voice to the user.** Only the CEO asks for go-aheads (`setup.sh`,
   sudo, session restarts, phase merges). Subagents report upward.
5. **Evidence or it did not happen.** Every claim carries a command and its
   output. "Looks fine" is not a test result.
6. **Findings land in the repo.** Anything meeting the bar goes to
   `.llm/suggestions.md`; findings never live only in a transcript.
7. **Stop at the boundary.** A subagent that needs a secret, sudo, a session
   restart, or a user decision returns to the CEO instead of improvising.
8. **The CEO stays free.** Maximum three concurrent workstreams; the CEO
   reserves context for the user, decisions, and final integration.
9. **The live checkout never changes branches.** Markdown work happens in the
   `./docs.sh` worktree; switching the live tree to `master` can serve older
   config to the running session.

## Handoff template

Every delegation states: role, scope (files/areas), constraints (read-only or
edit), evidence required, done-criterion, and the escalation path. Every
report back states: what changed, commands run, results, residual risk, and the
suggested next step. The Chief of Staff assigns roles per phase; the current
roster is recorded in `.llm/todo.md` when a phase starts.
