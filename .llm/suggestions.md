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

- **setup.sh never links quickshell or enviroment.d.** `linkDirectories` case
  labels `"quickshell "` (trailing space) and `"environment.d"` never match
  `CONFIG_LIST` entries `"quickshell"` / `"enviroment.d"`, so a fresh install
  silently ships no bar config and no env vars. Fix the labels to match the list.
- **`clearExistingConfig` deletes live config with no backup.** `setup.sh`
  `rm -rf`s `~/.bashrc`, `~/.tmux*`, `~/.config/nvim|hypr|…` before relinking,
  and combined with the dead branches above it can delete paths it never
  restores. Back up (timestamped dir) instead of deleting, and keep the go-ahead rule.
- **tmux links via a `.*` glob.** `ln -s "$PWD"/tmux/.* "$HOME/"` also matches
  `.`/`..` and any future dotfile in `tmux/`, so one stray file can break or
  mislink home. Link the two known paths (`~/.tmux`, `~/.tmux.conf`) explicitly.
- **`waybar/` is dead config with no marker.** Git log and autostart (`qs`)
  show Quickshell replaced it, but nothing in the tree says so — the next edit
  may "fix" the wrong bar. Confirm Quickshell parity, then delete `waybar/` or
  leave a one-line legacy pointer, and record the decision here.
- **`shell/zsh/.zshrc` is unlinked and macOS-specific.** `setup.sh` never links
  it and its `PATH` is Homebrew/macOS, so it cannot be live on this Arch box.
  Either wire it into the link map with Linux paths or delete it; do not edit it as live.
- **Stale paths from an older layout.** `.alias` `lspread` points at
  `~/GitHub/dotfiles/bash/lsp_util.sh` (real path: `shell/bash/lsp_util.sh`);
  `enviroment.d/99-hyperland.conf` hardcodes `/home/username/...` and both dir
  and file names are misspelled. Fix the paths when the link map is repaired.
- **`nvim` submodule has no branch pin.** `.gitmodules` omits `branch =` for
  `nvim`, so `update.sh` falls back to assuming `master` — wrong if upstream's
  default differs, and the failure aborts under `set -euo pipefail`. Pin the
  real default branch like every other submodule.
- **msmtp auth has no documented provider.** `msmtp/config` needs env vars whose
  only sources are `msmtp/smtp.env` (gitignored) and `private/bash/.env`
  (unreadable by policy), so no agent can verify mail config end-to-end.
  Document which file provides what (names only) in `.llm/structure.md`.
- **README documents nothing.** It holds one submodule command; install order
  (submodule init → `setup.sh` → sudo `private/setup.sh`), `update.sh`, and
  `arch/` scripts are undiscoverable. Write the 10-line install/verify order
  before the next fresh checkout has to rediscover it.
