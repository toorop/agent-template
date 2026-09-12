# agent-template — repo-level note

This file is for an agent working **on this template**, not with it. If you are setting up a
project, read `README.md` instead and use `install.sh`.

## Layout

- `global/AGENTS.md` — the universal contract. **Single source of truth.** Installed by
  `install.sh --global` to `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`, outside this repo.
- `global/code-style.md` — per-language style detail, referenced by `global/AGENTS.md`.
- `project/` — the four files copied into each repository by `install.sh --project DIR`.
- `install.sh` — installs either layer. Dry run by default.

## Rules for editing this repo

- Change the contract in `global/AGENTS.md`, never in the installed copies. The copies are
  overwritten by `install.sh`.
- Anything that is the author's personal choice rather than a general truth gets an `ADJUST`
  HTML comment right above it, so a reader can find what to change without reading everything.
  Keep that convention: new personal rules get an `ADJUST` marker too.
- `project/CLAUDE.md` must contain `@AGENTS.md` and nothing else.
- The universal rules in `global/AGENTS.md` and the short form in `project/AGENTS.md` overlap on
  purpose: the project file must stay usable on a machine where the global file is not installed.
  When one changes, check the other.
- `install.sh` must never overwrite a project file without `--force`, and must require `--yes` to
  write anything at all. Verifying that behaviour is part of any change to it.
- One step at a time: implement, verify, stop, report, wait. This repo is the one place where that
  rule cannot be skipped, since it defines the rule.
