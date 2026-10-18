# Research method

Goal: turn a first draft into a prompt whose every load-bearing claim is
verified. This follows [A1]'s research guidance: define success criteria,
verify across multiple sources, track confidence, keep a notes file.

## 1. Extract claims

Copy every sentence of the draft that asserts how something behaves: flag
meanings, defaults, limits, caching rules, event payloads, version
minimums, file locations. Sort each one:

- Correctness: if wrong, the deliverable breaks.
- Efficiency: correct but wasteful.
- Professionalism: unsafe or non-standard practice (supply chain,
  permissions, secrets).

## 2. Search

- Search even when confident about tool versions, flags, limits, and
  platform rules. They change after training.
- Query pattern: tool, then the behavior in question, then a symptom word.
  Start broad, then narrow. Make every query differ from the last.
- Queries that found real problems in this repo:
  - `rust-cache shared-key multiple jobs same key clippy test`
  - `GitHub Actions skip workflow runs [skip ci] required checks`
  - `cargo nextest fail-fast no-fail-fast`
  - `cargo-hakari publish workspace-hack crates.io`
  - `Prompting Claude Sonnet 5 literal instruction following`
- Fetch the full page for any claim you will state as a rule. Snippets
  are too thin.
- Prefer primary sources (official docs, project docs). Use forums, pull
  requests, and blogs only as corroboration, and label them T2.
- When sources conflict, run a differently worded search and record the
  conflict. Do not pick silently.

## 3. Assign a verdict and a tier

Verdicts: confirmed, corrected, or unverified.

Tiers:

- T1: official or primary documentation.
- T2: secondary (forum, pull request, blog, mirror).
- T0: from memory, not searched. Never state a T0 claim as verified.

Note limits next to the tier: a different product version (the GitHub skip
page was Enterprise Server 3.5), a mirror, or a third-party blog.

## 4. Log

One row per claim in `research/<slug>-log.md`: claim, verdict, source ID,
tier, prompt change. Add the source to `sources.md` first. List every T0
claim, every limited source, and every process gap under "Known gaps".

## 5. Stop rule

Stop researching when every claim has a verdict. Do not keep searching to
add support for a claim you already favor. When two answers could fit, use
searches to rule alternatives out against the most specific facts.

## 6. Parity pass

When recipes are paired, compare stages, flags, regexes, config files, and
version minimums. Example found this way: the CI recipe checked MSRV and
linted commit messages, and the local script did not.

## 7. Citation rules

- Cite by source ID. Paraphrase.
- Quote at most one phrase of under 15 words per source, and only when the
  exact wording matters. Never copy paragraphs, tables, or code.
- Label mirrors and secondary sources. Never invent an attribution. If
  unsure, omit the claim or mark it T0.
- State only what the source supports. If it covers a different version,
  say so in the log.

## Worked examples

Read the three logs in `research/`. Each shows requirements, findings
rows, and known gaps for a finished recipe.
