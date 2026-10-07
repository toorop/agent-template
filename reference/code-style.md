# Code style — per-language sections

<!-- Source for the `## Code style` section of a project's AGENTS.md. The `agt` skill copies only
     the sections for the languages the project uses; the rules that hold in every language are
     already in templates/AGENTS.md. -->

## Languages that follow the ecosystem standard

Use the idiomatic convention of the language and let the formatter enforce it. No house rules.

- **Go** — `gofmt` output, `go vet` clean. Errors returned, never swallowed. No `interface{}` where
  a concrete type or a small interface does.
- **Rust** — `rustfmt` output, `clippy` clean. `?` for propagation, no `unwrap()` in library code.
- **C** — the project's existing style wins; otherwise `clang-format` defaults. Warnings enabled
  and clean.
- **TypeScript / JavaScript** — 2-space indent, semicolons, single quotes, `const` by default.
  With Prettier, Prettier decides — and the JavaScript house rules below do not apply. Never mix
  the two in one repository.
- **HTML** — 2-space indent, lowercase tag and attribute names, double-quoted attribute values, no
  attribute on its own line unless the line is genuinely too long.

## Vue

- Block order: `<template>` then `<script setup>`. **No `<style>` inside components.**
- All CSS lives in a styles directory loaded from a single entry file (e.g. `styles/index.css`
  imported from `main.js`); a new file in it must be imported from that entry file.
- Template attributes stay grouped on one line while readable, never one per line by default;
  break only when the line is genuinely too long. Order: `ref`, `id`/`class`, `:prop`, `@event`.

## CSS

- 2-space indent, no tabs, no vertical alignment of values.
- Always multi-line rules, even for one property: `button {`, then property lines, then `}`.
- Prefer modern properties: `translate` over `transform: translateX()`.
- Blank line between `@keyframes` stops.

## JavaScript

- No space between keyword and parenthesis: `if(x)`, `catch(err)`, `while(x)`.
- No space inside destructuring braces: `const {apiUrl}`.
- Switch: one statement per line, `break` on its own line, blank line between cases.
- Long ternaries: continuation lines start with `?` / `:`, indented 4 spaces.

## Python

- `async/await`, no direct `threading` unless an external constraint forces it (e.g.
  `sounddevice` callbacks).
- No comments unless the logic is non-obvious. Concise `snake_case` names.
- No error handling for cases that cannot happen.
