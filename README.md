# agent-template

A reusable working agreement for AI coding agents, designed to survive a change of tool, of model,
or of machine.

Two layers: one **universal contract** installed once per machine, and one thin **project file**
copied into each repository. No duplication, one source to edit.

## Before you use it

The rules shipped here are one person's habits, not a standard. Three of them are choices you
should make deliberately rather than inherit:

1. **The language pair.** The contract says: answer the maintainer in **French**, write everything
   inside the repository in **English**. That is one arbitrary pair. If your agent speaks a
   different language to you, change it — but keep the split explicit, because "write docs in the
   language you chat in" is how a repository ends up half-translated.
2. **The working rhythm.** One step at a time: implement, verify, stop, report, wait for a go-ahead.
   Never run A to Z unattended. That is stricter than most people start with. Loosening it is a
   decision worth making on purpose.
3. **The git policy.** Never commit, stage or push without an explicit request, and one
   authorization covers only the commits it names. Enforced with the agent, it is the single rule
   that most reliably prevents surprise history.

The files mark these places with an `ADJUST` comment. Everything else is deliberately uncontroversial.

## Layout

    agent-template/
    ├── install.sh                 installs either layer, dry run by default
    ├── global/
    │   ├── AGENTS.md              THE contract — one source, installed to both tools
    │   └── code-style.md          per-language style rules, referenced by AGENTS.md
    └── project/                   copied into each new repository
        ├── AGENTS.md              project facts + non-negotiables
        ├── CLAUDE.md              contains only `@AGENTS.md`
        ├── STATE.md               hand-off template, `## Next action` first
        └── TODO.md                checkable plan template

The two layers are independent: you can use the project files without ever installing the global
contract, or install the contract and keep your own project files.

## Global layer (once per machine)

    ./install.sh                   # dry run, global layer
    ./install.sh --global --yes    # install it

The same contract is written to **both** destinations, because both tools read the same thing:

    ~/.claude/CLAUDE.md            Claude Code, user-level memory
    ~/.codex/AGENTS.md             Codex, user-level instructions

plus `global/code-style.md` to `~/.claude/code-style.md`. Re-run the script after every edit to
`global/`. Never edit the installed copies by hand: they are overwritten, and the drift is silent.

## Project layer (once per repository)

    ./install.sh --project ~/dev/my-project          # dry run
    ./install.sh --project ~/dev/my-project --yes    # copy the templates in

Existing files are **never overwritten** unless you pass `--force`, so this is safe to re-run on a
repository that already has an `AGENTS.md`. When a file is skipped, the script says so and shows you
the `diff` command rather than guessing.

Then fill in `PROJECT FACTS` in the repository's `AGENTS.md`. `project/CLAUDE.md` must contain
`@AGENTS.md` and nothing else — some tools treat a leading `@` as an import and any extra line
risks breaking it.

Both layers at once:

    ./install.sh --all ~/dev/my-project --yes

## Make it yours

Beyond the three choices above, the parts people most often change:

- **Code style.** Vue, CSS, JavaScript and Python have detailed rules; the rest defers to the
  ecosystem standard (`gofmt`, `rustfmt`, `clang-format`, the repo's own formatter). A formatter
  configured in a repository always wins — the file says so explicitly, so an agent does not flip
  between the two.
- **Verification commands.** Per project, in `PROJECT FACTS`. If a project has none, the first step
  should be creating them: an agent that cannot verify will guess.
- **The attribution trailer.** The commit block shown is Claude Code specific. Delete it, or replace
  it with whatever your tool injects.
- **Dictated messages.** The contract asks the agent to read dictated messages charitably and to ask
  whenever a real word might be a mis-transcription. That section is worth keeping even if you type:
  the ambiguity it describes is exactly where agents guess wrongly. Drop it if you have no use for
  it.

Everything is plain Markdown. Nothing here depends on a plugin, a daemon, a gateway or a vendor.

## Updating

1. Edit in `global/` or `project/`.
2. Re-run `./install.sh --global --yes` on each machine so the installed copies match.
3. Commit and push.

Repositories already set up keep their own copy of the project file: they are copies, not links, so
later improvements have to be copied across deliberately.

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
