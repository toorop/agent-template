# PROJECT — working agreement

<!-- PROJECT TEMPLATE. Copy to the repository root as AGENTS.md and fill in PROJECT FACTS.
     Universal rules — language, tone, working rhythm, git, secrets, code style, STATE.md
     discipline — live in the maintainer's user-level agent file, installed as
       ~/.claude/CLAUDE.md  and  ~/.codex/AGENTS.md
     and detailed in ~/.claude/code-style.md. If that file is missing on this machine, say so
     before starting: it is the contract this file defers to. -->

## Project facts

- **Project**: NAME
- **Source of truth for scope and intent**: PATH (e.g. `docs/spec.md`) — never edit it except to
  fix a transcription error.
- **Verification commands**: COMMANDS (e.g. `npm run build`, `cargo test`). If none exist yet, say
  so and propose creating them as the first step.
- **Stack and constraints**: STACK (e.g. Astro + Tailwind, Cloudflare Pages, KISS, no React, MIT)
- **Who commits**: MAINTAINER COMMITS / AGENT COMMITS ON EXPLICIT REQUEST
- **Repo-specific overrides**: anything here that departs from the universal rules, and why

## Non-negotiables (short form — full text in the user-level file)

- **One step at a time. Never run from A to Z unattended.** Implement one coherent change, verify
  it for real, stop, report, wait for an explicit go-ahead.
- **The stop report**: what changed and which files; the verification command(s) and their actual
  output; what is unfinished, uncertain or known-broken; the proposed next step.
- **Never commit, stage, or push** without an explicit request, and one authorization covers only
  the commits it names.
- **Answer the maintainer in the language set in the user-level file** (shipped default: French).
  Everything written into this repository — docs, comments, commit messages, `STATE.md`, `TODO.md`
  — is in **English** unless a repo-specific override above says otherwise.
- `STATE.md` and `TODO.md` stay in sync with reality, `STATE.md` first section always
  `## Next action`, under ~150 lines.
- Keep the diff small enough to revert on its own: no drive-by refactors, no formatting sweeps, no
  dependency bumps inside a feature step.
- **Write the minimum that works.** Reuse what already exists in the repo, reach for the standard
  library or a native platform feature before writing custom code, and add no abstraction, option
  or configuration nobody asked for. Never simplify away a trust-boundary check, real error
  handling, security or accessibility.

## Context map (read only what the task needs)

- `AGENTS.md` — this file.
- `STATE.md` — current state and hand-off; next action first.
- `TODO.md` — detailed, checkable plan.
- SOURCE OF TRUTH — see Project facts above.
- `docs/architecture.md` — structuring decisions with their rationale (if it exists).
- `CHANGELOG.md` — history (if it exists).

## Resuming a session started by another tool or model

1. Read this file, then `STATE.md` (in full if within budget), then the current step in `TODO.md`.
   Read `docs/architecture.md` only if the change is structural.
2. Resume from `STATE.md`'s `## Next action`. Do not re-plan work already marked done, and do not
   revisit settled decisions.
3. Then apply the step protocol: one step, verify, stop, report, wait.
