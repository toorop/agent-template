# agent-template — repo-level note

This file is for an agent working **on this template**, not with it. To set up a project, read
`README.md` and run `/agt` in that project.

## Layout

- `SKILL.md` — the `agt` skill: what `/agt` does, step by step.
- `templates/AGENTS.md` — the working agreement written into each repository. **Single source of
  truth** for the rules.
- `templates/STATE.md`, `templates/TODO.md` — the hand-off and plan templates.
- `reference/code-style.md` — per-language rules; `/agt` copies only the sections a project needs.

## Rules for editing this repo

- Change the rules in `templates/AGENTS.md`. Repositories already set up keep their own copy:
  improvements reach them only when copied across deliberately.
- Anything that is the author's personal choice rather than a general truth gets an `ADJUST` HTML
  comment right above it. New personal rules get one too.
- `templates/AGENTS.md` is loaded by every session of every repository that uses it: keep it dense,
  no examples where one sentence does.
- `/agt` must never overwrite or edit an existing file in the target repository, must ask before
  writing anything, and must never stage or commit. Verifying that behaviour — on a throwaway
  repository, new and with history — is part of any change to `SKILL.md`.
- The placeholders `SKILL.md` names (`PROJECT`, `NAME`, `PATH`, `COMMANDS`, `STACK`, `WHO`,
  `CODE_STYLE_SECTIONS`) must stay in sync with the templates.
- One step at a time: implement, verify, stop, report, wait. This repo is the one place where that
  rule cannot be skipped, since it defines the rule.
