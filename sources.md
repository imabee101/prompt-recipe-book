# Sources

Master list. Source IDs such as [A1] are defined only here. Cite them from
logs and skills by ID. Checked 2026-10-18.

Tiers: T1 = official or primary. T2 = secondary (forum, pull request,
blog, mirror). T0 = from memory, unverified (never listed here; T0 claims
live in each log's "Known gaps").

## Anthropic prompting

- [A1] T1. General prompting guide. Clarity, reasons, examples, XML tags,
  role, long context, tool use, research, overeagerness.
  https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices
- [A2] T1. Prompting Claude Sonnet 5.5. Effort, initiative and scope,
  coding verification, progress updates, refusals.
  https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5-5
- [A3] T1. Prompting Claude Sonnet 5. Literal instruction following.
  https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-sonnet-5

## Claude Code documentation

- [C1] T1. How Claude remembers your project (CLAUDE.md, rules, imports,
  auto memory, troubleshooting).
  https://code.claude.com/docs/en/memory.md
- [C2] T1. Best practices for Claude Code (what to include and exclude in
  CLAUDE.md, verification, failure patterns).
  https://code.claude.com/docs/en/best-practices.md
- [C3] T1. Extend Claude Code (CLAUDE.md vs skills, rules, hooks, output
  styles; context cost by feature).
  https://code.claude.com/docs/en/features-overview.md
- [C4] T1. Debug your configuration (/context, /doctor, safe mode).
  https://code.claude.com/docs/en/debug-your-config.md
- [C5] T1. Monorepos and large codebases (per-directory CLAUDE.md,
  keeping files current).
  https://code.claude.com/docs/en/large-codebases.md
- [C6] T1. How Claude Code uses prompt caching (when CLAUDE.md edits
  apply).
  https://code.claude.com/docs/en/prompt-caching.md

## GitHub

- [G1] T1. Dependency caching reference (cache scope and default-branch
  fallback).
  https://docs.github.com/en/actions/reference/workflows-and-actions/dependency-caching?apiVersion=2022-11-28
- [G2] T1, Enterprise Server 3.5 version. Skipping workflow runs (native
  skip strings, pending required checks). Recheck the github.com page.
  https://docs.github.com/en/enterprise-server@3.5/actions/managing-workflow-runs/skipping-workflow-runs

## Rust tooling

- [R1] T1. rust-cache action (inputs and key composition).
  https://github.com/Swatinem/rust-cache
- [R2] T2. Pull requests showing a shared cache key across different job
  types causing rebuilds.
  https://github.com/freenet/freenet-core/pull/1931
  https://github.com/Porabuild/HeroGPUI/pull/4
- [R3] T1. Cargo build performance guide (debug info, linkers, nightly-only
  options).
  https://doc.rust-lang.org/cargo/guide/build-performance.html
- [R4] T1. cargo-nextest running tests (fail-fast default, max-fail).
  https://nexte.st/book/running
- [R5] T2. Third-party guide stating nextest does not run doctests.
  https://qaskills.sh/blog/cargo-nextest-rust-testing-guide
- [R6] T2, mirror. rust-analyzer FAQ on build-lock contention and separate
  target directories.
  https://git.bendn.org/rust-analyzer/plain/docs/book/src/faq.md
- [R7] T2. Forum threads on feature unification with -p versus --workspace.
  https://users.rust-lang.org/t/cargo-workspace-and-dependices-building/95813
  https://internals.rust-lang.org/t/workspace-dependency-resolution-is-a-footgun/17885
- [R8] T1. cargo-hakari documentation (workspace-hack purpose, CI commands,
  publishing).
  https://docs.rs/cargo-hakari/latest/src/cargo_hakari/docs/about.rs.html
  https://docs.rs/crate/cargo-hakari/latest/source/README.md
  https://docs.rs/cargo-hakari/latest/src/cargo_hakari/docs/publishing.rs.html

## Pointers not yet read

- Prompt engineering overview:
  https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview
- Steering Claude Code (blog):
  https://claude.com/blog/steering-claude-code-skills-hooks-rules-subagents-and-more
