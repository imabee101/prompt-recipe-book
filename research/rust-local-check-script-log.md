# Research log: rust-local-check-script

Recipe: ../recipes/rust-local-check-script.md
Checked: 2026-10-18
Tiers: T1 = official or primary, T2 = secondary, T0 = from memory.

## Requirements

1. A check or build script for a Rust workspace with multiple components.
2. Extremely efficient.
3. Failures show up as quickly as possible, so iteration is fast.
4. Nothing bad gets through.
5. Search the web for inefficient or unprofessional parts, as was done for
   the CI recipe. Follow Anthropic's prompting guidance.
6. Include cargo-hakari.
7. Keep the prompt in parity with the CI recipe: same stages, flags,
   regexes, and version minimums.

## Findings

| Claim | Verdict | Source | Tier | Prompt change |
| --- | --- | --- | --- | --- |
| Two cargo commands can run in parallel against one target directory | Corrected: they serialize on the build-directory lock | [R6] | T2 (mirror) | Only non-compiling tools run in the background |
| Scoped (-p) and workspace commands can alternate in one target directory | Corrected without hakari: scoping changes enabled features and rebuilds dependencies | [R7] | T2 | Separate directories per mode, then one shared directory once hakari was added |
| cargo-hakari keeps the feature set constant, so one target directory works | Confirmed | [R8] | T1 | Hard rule 6 and the hakari lane |
| hakari drift is checked with generate --diff and manage-deps --dry-run | Confirmed | [R8] | T1 | Hakari lane in fast and gate modes |
| cargo publish works with a hakari workspace-hack crate | Corrected: needs the empty crate on crates.io, created by cargo-hakari 0.9.9 or newer | [R8] | T1 | Version minimum and setup step 6 |
| Nightly options such as workspace feature unification speed up builds | True but nightly-only when read | [R3] | T1 | Stable Rust only |
| Reduced debug info and no debug info for dependencies speed up builds | Confirmed | [R3] | T1 | .cargo/config.toml profile settings |
| x86_64 Linux needs a linker override | Inferred no: the guide names other Linux targets as the slow ones | [R3] | T1 (inferred) | Linker settings only for other Linux triples |
| Nextest stops at the first failure by default; max-fail and terminate are configurable | Confirmed | [R4] | T1 | fast and gate profiles |
| Nextest runs doctests | Corrected: it does not | [R5] | T2 | Separate cargo test --doc stage in gate |
| The IDE should use its own target directory | Confirmed | [R6] | T2 (mirror) | Closing usage sentence |
| Setting RUSTFLAGS is harmless | Corrected: it replaces rustflags from .cargo/config.toml | none | T0 | Hard rule 8 |
| Models apply an instruction only where it is stated | Corrected: scope must be explicit | [A3] | T1 | Scope sentence at the top of hard_rules |
| Models report code as done without running a check | Confirmed | [A2] | T1 | verification section requires real output |

## Known gaps

T0, from memory and not searched:

- RUSTFLAGS in the environment replaces config rustflags.
- cargo fmt -p <crate> --check and cargo clippy --message-format short
  flag forms.
- The Conventional Commits mapping and the commit-subject regex.
- shasum -a 256 as the portable checksum command.

Sources with limits:

- [R3] listed workspace feature unification as nightly-only when read.
  Stable status was not confirmed, so the recipe uses cargo-hakari instead.
- The claim that x86_64 Linux already links with a fast linker is inferred
  from [R3]. Confirm against the toolchain release notes.
- [R6] was read through a mirror. [R5] is a third-party blog. [R7] is forum
  discussion.

Process gaps:

- Early revisions used search snippets of [A1]. [A1] and [A2] were read in
  full later.
- The prompt uses one example per config block. [A1] recommends 3 to 5
  examples when the output format is the main risk.
- Status stays draft until the T0 claims are verified.
