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

3. **Drop the tracked AUR artifact.** Delete `arch/aura.tar.gz`, ignore
   `arch/aura/` and the tarball, because `arch/install.sh` re-downloads them.
   Done: `git ls-files arch/` has no tarball, `git check-ignore` covers both,
   `bash -n arch/install.sh` passes. Size S.
4. **Fix the macOS-only zsh backup.** `setup.sh` moves `~/.zshrc` aside on
   Linux even though it never relinks it. Skip the backup unless
   `OS=Darwin`; keep `restore.sh` consistent. Done: `bash -n` passes and a
   temp-`HOME` harness shows the file untouched on Linux, moved on Darwin.
   Size S.
5. **Repair live shell drift.** Fix the stale `~/develop/flutter` path to the
   installed `~/.local/opt/flutter`, then replace the drifted real
   `~/.bashrc` with the repo symlink (backup first). Done: `readlink
   ~/.bashrc` points into the checkout, the Flutter binary resolves from a
   fresh non-interactive shell, and the old file is in a timestamped backup.
   Size S.
6. **Repair live `environment.d` drift.** Rename `99-hyperland.conf` to
   `99-hyprland.conf`, merge the live `QT_LOGGING_RULES` setting, and replace
   the real live directory with the repo symlink (backup first). Done:
   `readlink ~/.config/environment.d` points into the checkout, both
   variables are present, and the old directory is backed up. Size S.
7. **Fix the inverted idle audio gate.** Make `audio-playing` succeed only
   while audio plays, add an `audio-idle` condition for hypridle, and keep
   the three on-timeout guards. Done: a stubbed `pactl` matrix proves
   playing/not-playing behavior, `hypridle -c ... --help` parses the config,
   and no idle action is skipped when audio stops. Size S.
8. **Unload the unused tmux battery plugin.** Remove the `run-shell
   battery.tmux` line and the dead `@batt_*` options (no battery on this
   host, no battery segment in the status bar). Done: `tmux source-file
   ~/.tmux.conf` exits 0, no `batt` options remain, and the status bar keeps
   its current segments. Size S.
9. **Record major-change suggestions.** Append the follow-ups that need a
   separate decision: monitor fallback, Hyprland permission enforcement,
   retiring the tmux-battery submodule, consolidating the two network
   plugins, removing the installed `quickshell`/`waybar` packages, and
   making `setup.sh` able to repair drifted links. Done: entries carry
   what/where/why/next step, and resolved entries are removed. Size S.
10. **Final verification.** Run `diagnose.sh`, `bash -n`/`shellcheck` on
    touched scripts, a detached tmux parse, `hyprctl configerrors` (read
    only), and confirm every live link in the map. Done: all checks pass,
    output is pasted in the session, and the working tree is clean except
    the user's stashed whitespace change. Size S.
