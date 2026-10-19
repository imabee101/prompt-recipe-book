# Research log: rust-local-check-script

Recipe: ../recipes/rust-local-check-script.md
Checked: 2026-10-19 (revised for authority and decision rules); first checked 2026-10-18 (re-audited 2026-10-18 against [A1]-[A4])
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
8. 2026-10-19: "if I'm pasting this prompt, it's because I've read the
   prompt and that the prompt is authoritative and the new reality that
   the project should be held by." It acts without asking questions or
   handing decisions back ("this decision, it's on you").
9. 2026-10-19: "I don't want it to skip things either."
10. 2026-10-19: "It should make the least destructive action to the
   repository to make the new reality."
11. 2026-10-19: when making a choice, "pick something to do that follows
   the intent of the project while prioritizing the prompt."
12. 2026-10-19: the prompt may run "in a new project or making a new
   project comply."
13. 2026-10-19: in an existing repository, "I don't want it to suddenly
   start undoing a product or a feature." Reshape what is needed to make
   it production oriented, "not undo something that was done for a
   purpose."
14. 2026-10-19: make "the role inside of the prompt slightly more
   authoritative," and apply Anthropic's prompting best practices.

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
| Claude can be told to act by default: implement rather than suggest, and when intent is unclear infer the most useful action and proceed | Confirmed | [A1] | T1 | Authority paragraph in goal; hard rule 13 decides open points from a fixed source order |
| Explaining why an instruction matters helps Claude generalize to cases the instruction does not name | Confirmed | [A1] | T1 | Authority stated with its reason; hard rule 13 uses each rule's Reason to settle unnamed cases |
| Sonnet 5.5 can stop to check in before work is done; a keep-working instruction helps but does not replace rules on risky actions | Confirmed | [A2] | T1 | Deliverables say keep working with no ask clause; risky actions handled by hard rule 15 |
| Anthropic's sample safety prompt asks before destructive or shared actions | Confirmed, then replaced by user requirement: running the prompt is the approval, so changes stay recoverable (backups, git) instead of asked about | [A1] | T1 | Hard rule 15 replaces the ask-before rule |
| A one-sentence role focuses behavior and tone | Confirmed. The prompt relies on hard rule 13, not the role, to stop questions | [A1] | T1 | Role names ownership of every judgment call |
| Positive instructions work better than prohibitions | Confirmed | [A1] [A3] | T1 | Instruction-style negatives rewritten as positive rules or moved to not_included |
| A few diverse examples steer behavior better than rules alone | Confirmed | [A1] | T1 | decision_examples with three open-point examples |
| git restores tracked paths from a commit, so uncommitted or untracked content has no git copy | Confirmed | [S7] | T1 | Hard rule 15: back up such files before changing them |
| git symbolic-ref refs/remotes/origin/HEAD finds the default branch | Corrected: it fails in a fresh clone; git ls-remote --symref origin HEAD works | [L3] | T1 | Default-branch decision example uses ls-remote |
| Parity with the paired recipe after this revision | Confirmed: hard rules 13 and 14 are identical; 15 and 16 differ only in recipe nouns and the local hakari setup line; both merge into existing config files | none (parity) | n/a | shared_config_files and config_files merge keys |

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
