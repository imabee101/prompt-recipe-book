# Research log: rust-local-check-script

Recipe: ../recipes/rust-local-check-script.md
Checked: 2026-10-18 (re-audited 2026-10-18 against [A1]-[A4])
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
| Two cargo commands can run in parallel against one target directory | Corrected: they serialize on the build-directory lock | [R6] [R13] | T1 | Only non-compiling tools run in the background |
| Scoped (-p) and workspace commands can alternate in one target directory | Corrected without hakari: scoping changes enabled features and rebuilds dependencies | [R7] | T2 | Separate directories per mode, then one shared directory once hakari was added |
| cargo-hakari keeps the feature set constant, so one target directory works | Confirmed | [R8] | T1 | Hard rule 6 and the hakari lane |
| hakari drift is checked with generate --diff and manage-deps --dry-run | Confirmed | [R8] | T1 | Hakari lane in fast and gate modes |
| cargo publish works with a hakari workspace-hack crate | Corrected: needs the empty crate on crates.io, created by cargo-hakari 0.9.9 or newer | [R8] | T1 | Version minimum and setup step 6 |
| Nightly options such as workspace feature unification speed up builds | True but nightly-only when read | [R3] | T1 | Stable Rust only |
| Reduced debug info and no debug info for dependencies speed up builds | Confirmed | [R3] | T1 | .cargo/config.toml profile settings |
| x86_64 Linux needs a linker override | Corrected: no override from Rust 1.90, which made LLD the default there; older pinned toolchains still need it | [R3] [R12] [R17] | T1 | Linker settings for other Linux triples, plus x86_64 when the toolchain is older than 1.90 |
| Linker settings in .cargo/config.toml are safe for zigbuild triples | Not needed: cargo zigbuild uses zig as the linker, so only triples built with cargo get linker settings | [R16] | T1 | Linker bullet limited to method cargo |
| linker = "clang" with -fuse-ld=lld links any Linux triple | Corrected by test: a cross-link fails because rustc does not pass the target to clang; adding -C link-arg=--target=<triple> fixes it. Native aarch64 was not available; clang accepted --target for its own host triple on x86_64 | [L2] | T1 | Linker bullet adds --target and notes the target C library |
| x86_64 links with rust-lld by default; clang+lld fallback works | Confirmed by test | [L2] | T1 | none |
| clang and lld are present wherever linker settings apply | Not assumed: preflight now checks for them | none (design) | n/a | Preflight in fast and gate modes |
| Nextest stops at the first failure by default; max-fail and terminate are configurable | Confirmed | [R4] | T1 | fast and gate profiles |
| Nextest runs doctests | Corrected: it does not; the official site says to run cargo test --doc | [R5] [R11] | T1 | Separate cargo test --doc stage in gate |
| The IDE should use its own target directory | Confirmed on the official site | [R6] [R13] | T1 | Closing usage sentence |
| Setting RUSTFLAGS is harmless | Corrected: RUSTFLAGS is checked before config rustflags and the first source found wins | [R9] | T1 | Hard rule 8 |
| Models apply an instruction only where it is stated | Corrected: scope must be explicit | [A3] | T1 | Scope sentence at the top of hard_rules |
| Models report code as done without running a check | Confirmed | [A2] | T1 | verification section requires real output |
| cargo fmt -p <crate> --check and cargo clippy --message-format short are valid | Confirmed by running them | [L1] [R10] | T1 | none |
| Conventional Commits mapping and commit-subject regex | Confirmed (same rows as the CI log) | [S1] [S2] [S3] | T1 | none |
| shasum -a 256 is the portable checksum command | Confirmed: shasum ships with core Perl; macOS ships it | [S4] [S5] | T1 and T2 | none |
| macOS default /bin/bash is 3.2 | Confirmed by secondary source | [S6] | T2 | none |
| Cargo stores build output in the target directory | Confirmed | [R14] | T1 | Rule 9 reason |
| cargo hakari generates workspace-hack and checks drift with generate --diff | Confirmed | [R8] | T1 | Rule 10 reason |
| cargo deny trigger and docs-only globs differed from the CI recipe | Corrected for parity: both use Cargo.toml, Cargo.lock, .config/hakari.toml, and docs/**, **/*.md, LICENSE*, .github/ISSUE_TEMPLATE/** | none (parity) | n/a | change_detection and gate stage b |
| Prompt audit against [A1] [A2] [A3] [A4] | Corrected: missing rule reasons, examples, tag order, stop-and-report wording, and confirmation rules failed checklist items | [A1] [A2] [A3] [A4] | T1 | See research/prompt-audit-2026-10-18.md |

## Known gaps

T0, from memory and not searched: none. Every earlier T0 row was
re-verified on 2026-10-18 (see Findings).

Sources with limits:

- [R3] listed workspace feature unification as nightly-only when read.
  Stable status was not confirmed, so the recipe uses cargo-hakari instead.
- [R7] is forum discussion. [S5] and [S6] are secondary sources.

Process gaps:

- Early revisions used search snippets of [A1]. [A1] and [A2] were read in
  full later.
