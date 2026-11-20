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

Phase: Neovim health. Source: user objective of 2026-11-20 (check the Neovim
logs for errors/warnings and fix them).

1. **Fix the Neovim health errors and warnings.** Remove the duplicate
   `hyprlang`/`hyprls` and `systemd_ls`/`systemd_lsp` configurations, wire
   `vim.ui.input`/`vim.ui.select` to Snacks, add the `norg` parser, disable
   the unused Perl provider, and stop `nvim-treesitter` from trying to install
   unsupported filetype languages. Done: `:checkhealth` has no config-caused
   errors, LSP logs are clean, startup emits no errors, and the nvim submodule
   pin is moved on `working`. Size S.
