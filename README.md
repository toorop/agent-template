# agent-template

A working agreement for AI coding agents, set up per repository by a skill: `/agt`.

It writes four files into the repository you are working in — `AGENTS.md` (the rules),
`CLAUDE.md` (one line, `@AGENTS.md`), `STATE.md` (the hand-off) and `TODO.md` (the plan) — so any
session, with any tool or model, can pick up where the last one stopped.

It is opt-in per repository: nothing applies until you run `/agt` there, and the files it writes
are copies you can edit when a repository needs to work differently.

## Install

The repository is the skill. Link it once:

    ln -s ~/path/to/agent-template ~/.claude/skills/agt

A `git pull` updates it. Other tools that read `SKILL.md` skills can link it into their own skills
directory the same way.

## Use

In the repository to set up, type `/agt`. It works on a new repository and on one already in
progress:

1. It looks at the repository and infers what it can: name, verification commands, stack,
   languages.
2. It shows you those facts and asks for the rest — who commits and, on an existing project, the
   next action. Nothing is written before you answer.
3. It writes the files that are missing. On a project with history, `STATE.md` gets the recent
   commits and `TODO.md` checks off what already exists.
4. **It never overwrites an existing file.** It says which ones it left alone and offers to merge
   where that helps — for example a `CLAUDE.md` that does not import `AGENTS.md`.

Nothing is staged or committed.

After that there is no command to learn. A new session reads `AGENTS.md`, which tells it to resume
from `STATE.md`'s `## Next action`. To refresh the hand-off, say "update the state".

## Before you use it

The rules are one person's habits, not a standard. Three are choices to make deliberately rather
than inherit:

1. **The repository language.** Everything written inside the repository is in **English**,
   whatever language you chat in. Change it if you like, but keep it explicit: "write docs in the
   language you chat in" is how a repository ends up half-translated.
2. **The working rhythm.** One step at a time: implement, verify, stop, report, wait. Never run A
   to Z unattended. Stricter than most people start with.
3. **The git policy.** Never commit, stage or push without an explicit request, and one
   authorization covers only the commits it names.

Each personal choice carries an `ADJUST` comment in `templates/AGENTS.md`. Change them there for
every future repository, or in a repository's own `AGENTS.md` for that one only.

## Layout

    agent-template/
    ├── SKILL.md              what /agt does
    ├── templates/
    │   ├── AGENTS.md         the rules, with Project facts to fill in
    │   ├── STATE.md          hand-off, `## Next action` first
    │   └── TODO.md           checkable plan
    └── reference/
        └── code-style.md     per-language rules; /agt copies only the project's languages

## What this deliberately does not do

- No global install: rules live in each repository, so each one can differ.
- No sandboxing, permission model or autonomy settings. Those belong to the harness.
- No model routing or provider failover. Keep the model and the tool as explicit choices.
- No vendor lock-in: the output is plain Markdown any agent can read.

## License

MIT — see `LICENSE`.
