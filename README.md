# agent-template

A reusable working agreement for AI coding agents, designed to survive a change of tool, of model,
or of machine.

Two layers: one **universal contract** installed once per machine, and one thin **project file**
copied into each repository. No duplication, one source to edit.

## The problem it solves

Coding agents accumulate rules: how to talk to you, when to commit, how to structure code, how to
hand off a session. Those rules usually live in one tool's private memory. So they do not travel:
open a second agent, or the same agent on another machine, and every rule is gone. Worse, the
project's own hand-off document ends up pointing at a plan file that lives outside the repository.

This template keeps the rules in Markdown, in files the tools already read, split by scope.

## Layout

    agent-template/
    ├── install-global.sh          installs the machine-level files (dry run by default)
    ├── global/
    │   ├── AGENTS.md              THE contract — one source, copied to both tools
    │   └── code-style.md          per-language style rules, referenced by AGENTS.md
    └── project/                   copied into each new repository
        ├── AGENTS.md              project facts + non-negotiables
        ├── CLAUDE.md              contains only `@AGENTS.md`
        ├── STATE.md               hand-off template, `## Next action` first
        └── TODO.md                checkable plan template

## Per machine (once)

    ./install-global.sh            # dry run: shows destinations and current state
    ./install-global.sh --yes      # writes them

`global/AGENTS.md` is copied to **both** destinations, because both tools read the same contract:

    ~/.claude/CLAUDE.md            Claude Code, user-level memory
    ~/.codex/AGENTS.md             Codex, user-level instructions

and `global/code-style.md` to `~/.claude/code-style.md`.

Re-run the script after every edit to `global/`. Never edit the installed copies by hand: they are
overwritten, and the drift would be silent.

## Per repository

    cp project/AGENTS.md project/CLAUDE.md project/STATE.md project/TODO.md .
    $EDITOR AGENTS.md              # fill in PROJECT FACTS

`project/CLAUDE.md` must contain `@AGENTS.md` and nothing else — some tools treat a leading `@` as
an import and any extra line risks breaking it. If your tool wants a different filename, that file
gets the same one-line content.

## Make it yours

The rules shipped here are one person's habits, kept concrete on purpose so they are easy to edit.
The parts most people will want to change:

- **Language.** The contract says: answer the maintainer in French, write everything in the
  repository in English. Pick your own pair, and keep the split explicit — that is the whole point.
- **Working rhythm.** One step at a time, stop and report, wait for go-ahead, never run A to Z
  unattended. A stricter default than most people start with; loosen it deliberately if you want,
  but decide it rather than drifting.
- **Git.** Never commit, stage, or push without an explicit request, and one authorization covers
  only the commits it names. The attribution-trailer block is tool-specific: delete it if your tool
  does not inject one.
- **Code style.** The rules here cover Vue, CSS, JavaScript and Python in detail, and defer to the
  ecosystem standard for the rest.
- **Verification commands.** Per project, in `PROJECT FACTS`. If a project has none, the first step
  should be creating them: an agent that cannot verify will guess.

Everything is plain Markdown. Nothing here depends on a plugin, a daemon, a gateway or a specific
vendor.

## Updating

1. Edit in `global/` or `project/`.
2. Re-run `./install-global.sh --yes` on each machine so the installed copies match.
3. Commit and push.

Note that repositories already set up keep their own copy of the project file: they are copies, not
links, so later improvements have to be copied across deliberately.

## Why two layers

- **`global/`** holds what is true everywhere: language, tone, working rhythm, git caution, secrets,
  code style, the state-file discipline. Written once, installed once, read by every session of
  every project.
- **`project/`** holds only what changes per repository: source of truth, verification commands,
  stack, who commits. It defers to the global file for the rest.

The project file deliberately repeats a short form of the contract, so it still works on a machine
where the global file was never installed. That overlap is intentional: when one changes, check the
other.

## What this deliberately does not do

- No sandboxing, no permission model, no autonomy settings. Those belong to the harness.
- No model routing, no multi-provider gateway, no automatic failover. Keep the model and the tool as
  explicit choices.
- No vendor lock-in: the rules are Markdown files any agent can read.

## License

MIT — see `LICENSE`. Use it, fork it, strip it down.
