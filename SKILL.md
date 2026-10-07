---
name: agt
description: Set up the maintainer's working agreement in the current repository — AGENTS.md, CLAUDE.md, STATE.md and TODO.md — on a new or an already running project. Only when the user explicitly invokes it.
disable-model-invocation: true
---

# agt — set up the working agreement in this repository

Paths below are relative to this file's directory. Everything is written into the repository the
user is working in, never anywhere else. Opt-in per repository: run only because the user asked.

## 1. Look before writing

1. Find the repository root (`git rev-parse --show-toplevel`). If this is not a git repository,
   say so and ask whether to continue anyway.
2. Run `git status --short` and note uncommitted work.
3. Check which of `AGENTS.md`, `CLAUDE.md`, `STATE.md`, `TODO.md` already exist at the root.

## 2. Gather the project facts

Infer what the repository shows — never invent the rest:

- **Project**: from the README title, the manifest (`package.json`, `Cargo.toml`, `pyproject.toml`,
  `go.mod`…) or the directory name.
- **Source of truth**: a spec or plan if one exists (`docs/spec.md`, `SPEC.md`…), else unknown.
- **Verification commands**: from manifest scripts, `Makefile`, CI config. Only commands that
  exist; none found is a valid answer.
- **Stack and constraints**: frameworks and hosting visible in the manifests and config files.
- **Languages**: from `git ls-files` extensions, to pick the code-style sections.
- **Who commits**: cannot be inferred — ask.
- **Next action** (existing project only): cannot be inferred — ask.

Show the facts in one short message, mark each one inferred or unknown, ask for the missing ones
and for confirmation. Wait for the answer before writing anything.

## 3. Write the missing files

**Never overwrite or edit an existing file in this step.** For each of the four files:

- **`AGENTS.md`** — copy `templates/AGENTS.md`, replace `PROJECT` and the Project facts
  placeholders (`NAME`, `PATH`, `COMMANDS`, `STACK`, `WHO`) with the confirmed facts, and replace the `CODE_STYLE_SECTIONS` line with the
  sections of `reference/code-style.md` for the languages the project uses (from "Languages that
  follow the ecosystem standard", only the bullets that apply). Turn those sections' `##` headings
  into `###`. No matching language: delete the line.
- **`CLAUDE.md`** — exactly one line: `@AGENTS.md`. Nothing else: some tools treat a leading `@`
  as an import and an extra line can break it.
- **`STATE.md`** — copy `templates/STATE.md` and replace `PROJECT`. On a project with history, fill
  `## Next action` with the user's answer, `## Current step` with what is in progress if known, and
  `## Recently done` with up to five dated one-liners from `git log`.
- **`TODO.md`** — copy `templates/TODO.md` and replace `PROJECT`. On a project with history, check
  off the bootstrap items that already exist, drop Step 0 if all of them do, and leave Step 1 for
  the user to define.

## 4. Files that already exist

Leave them untouched and say so in the report. Then, only where it helps:

- `AGENTS.md`: list what the template has that it lacks, and offer to merge — section by section,
  on approval.
- `CLAUDE.md` with more than `@AGENTS.md`: offer to move its content into `AGENTS.md` and reduce it
  to `@AGENTS.md`.
- `STATE.md` / `TODO.md`: say whether `STATE.md` starts with `## Next action` and fits under ~150
  lines. Offer nothing more.

## 5. Report and stop

- Files written, files left untouched and why, facts still marked unknown.
- Do not stage or commit: the new `AGENTS.md` rules apply from now on, including the git ones.
