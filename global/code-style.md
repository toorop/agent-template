# Code style

<!-- Per-language rules. Referenced by `AGENTS.md` (the universal working agreement).
     Installed next to the user-level agent file: ~/.claude/code-style.md -->

## Precedence

1. **A formatter or linter configured in the repository always wins.** If the project has a
   `prettier`, `gofmt`, `rustfmt`, `clang-format`, `ruff` or equivalent configuration, run it and
   follow its output instead of the rules below — and say plainly when the two disagree rather than
   flipping between them.
2. Otherwise, the rules below.

## Rules that hold in every language

- **No vertical alignment with spaces, ever.** Imports, variable declarations, switch cases, object
  properties: one space, never padded columns.

      // No
      import { useNab }      from './composables/useNab.js'
      const flickRef     = ref(null)

      // Yes
      import { useNab } from './composables/useNab.js'
      const flickRef = ref(null)

- Comments in English. Not retroactive: existing French comments are left alone, even in the file
  being edited.
- No defensive handling for cases that cannot happen.

## Languages that follow the ecosystem standard

For these, use the classic, idiomatic convention of the language — and let the formatter enforce
it. Do not invent house rules here.

- **Go** — `gofmt` output, `go vet` clean. Errors returned, never swallowed. No `interface{}` where
  a concrete type or a small interface does.
- **Rust** — `rustfmt` output, `clippy` clean. `?` for propagation, no `unwrap()` in library code.
- **C** — the project's existing style wins; where the project has none, `clang-format` defaults.
  Warnings enabled and clean.
- **TypeScript / JavaScript** — the ecosystem's conventional formatting: 2-space indent, semicolons,
  single quotes, `const` by default. Where a project uses Prettier, Prettier decides.
- **HTML** — 2-space indent, lowercase tag and attribute names, double-quoted attribute values, and
  no attribute on its own line unless the line is genuinely too long.

Note that the house rules in the JavaScript section below disagree with Prettier's defaults on
spacing (`if(` vs `if (`). That is fine as long as it is decided: on a project with Prettier, the
formatter wins and those rules do not apply. Never mix the two in one repository.

## Vue

- Component block order: `<template>` → `<script setup>`. **No `<style>` inside components.**
- All CSS lives in a dedicated styles directory, pulled in from a single entry file (for example
  `front/src/styles/`, loaded through `styles/index.css` from `main.js`). A new file in `styles/`
  must be imported from that entry file.
- Templates: do **not** put one attribute per line. Group attributes on one line while it stays
  readable; break only when the line is genuinely too long. Logical order: `ref`, `id`/`class`,
  bindings (`:prop`), events (`@event`).

      <!-- No -->
      <button
        class="mic-btn"
        :class="{ recording: isListening }"
        @click="onMicClick"
      >

      <!-- Yes -->
      <button class="mic-btn" :class="{ recording: isListening }" @click="onMicClick">

      <!-- Acceptable when the line is too long -->
      <Flicking ref="flickRef" class="flicking"
        :options="{ circular: false, align: 'center' }"
        :plugins="plugins"
      >

## CSS

- 2-space indent, no tabs.
- No vertical alignment of values with spaces.
- Always multi-line rules, never single-line, even for one property: opening brace, property lines,
  closing brace on separate lines.

      /* No */
      button { cursor: pointer; font-family: monospace; }

      /* Yes */
      button {
        cursor: pointer;
        font-family: monospace;
      }

- Prefer modern properties: `translate` over `transform: translateX()`.
- Blank line between `@keyframes` stops.

## JavaScript

- Switch: one statement per line, `break` on its own line, blank line between cases.
- Long ternaries: the `?` / `:` operator starts the continuation line, indented 4 spaces.
- No space between keyword and parenthesis: `if(condition)`, `catch(err)`, `while(x)`.
- No space inside destructuring braces: `const {apiUrl}`, `const {a, b}`.

      // switch
      case 'foo':
        doSomething();
        break

      case 'bar':
        doOther();
        break

      // ternary
      const x = condition
          ? valueA
          : valueB;

## Python

- No comments unless the logic is non-obvious.
- Everything `async/await` — no direct `threading` unless an external constraint forces it (for
  example `sounddevice` callbacks).
- No error handling for cases that cannot happen.
- Concise `snake_case` names.
