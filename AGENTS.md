# agent-template — repo-level note

This file is for an agent working **on this template**, not with it. If you are setting up a
project, read `README.md` instead and copy from `project/`.

## Layout

- `global/AGENTS.md` — the universal contract. **Single source of truth.** Installed to
  `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`, which live outside this repo.
- `global/code-style.md` — per-language style detail, referenced by `global/AGENTS.md`.
- `project/` — the four files copied into each new repository. The templates themselves.
- `install-global.sh` — installs the `global/` files on the current machine. Dry run by default.

## Rules for editing this repo

- Change the contract in `global/AGENTS.md`, never in the installed copies. The copies are
  overwritten by `install-global.sh`.
- `project/CLAUDE.md` must contain `@AGENTS.md` and nothing else.
- The universal rules in `global/AGENTS.md` and the short form in `project/AGENTS.md` overlap on
  purpose: the project file must stay usable on a machine where the global file is not installed.
  When one changes, check the other.
- One step at a time: implement, verify, stop, report, wait. This repo is the one place where the
  rule cannot be skipped, since it defines the rule.
