# Research log: rust-ci-github-actions

Recipe: ../recipes/rust-ci-github-actions.md
Checked: 2026-10-18 (re-audited 2026-10-18 against [A1]-[A4])
Tiers: T1 = official or primary, T2 = secondary, T0 = from memory.

## Requirements

1. Write a prompt for a Rust workflow on a large code base: a simple,
   basic, well-defined instruction for a modern CI pipeline that does not
   waste compute, uses cheap checks, and is event driven. Quality gates
   stay, but no hours of wasted CI build.
2. GitHub only. One single event-driven CI pipeline in one CI file. No
   Dependabot, no polling, no cron jobs. The cache must work.
3. The code base has multiple components and multiple targets.
4. Versioning is handled by the CI itself. Add a mechanism for skipping
   builds, for example when only documents change.
5. Remove everything ambiguous. Be direct.
6. Search the web for anything inefficient or unprofessional. Follow
   Anthropic's prompting guidance.
7. Include cargo-hakari.
8. Keep the prompt in parity with the local check script recipe.
9. 2026-10-19: Keep every specification as written. Remove wording that
   invites questions so the session acts; it creates no files beyond those
   the prompt names, keeps existing project features, fits the work to the
   project, and picks the least disruptive option within the constraints.
   Make the role read as more senior through experience.

## Findings

| Claim | Verdict | Source | Tier | Prompt change |
| --- | --- | --- | --- | --- |
| A manual skip token in the commit message is a safe opt-out | Corrected: GitHub drops push and pull_request runs containing its own skip strings or a skip-checks: trailer, and required checks stay pending. Rechecked on github.com | [G2] [G3] | T1 | File-based skip only. Commit lint rejects the native strings |
| One rust-cache key can be shared by lint, check, test, and build | Corrected: jobs that compile different artifacts get cache hits that still rebuild | [R2] | T2 | shared-key per target and job type |
| The cache key must include Cargo.lock and toolchain inputs | Redundant: the action already hashes them | [R1] | T1 | Instruction removed |
| Pull requests and the merge queue can restore caches saved on main | Confirmed | [G1] | T1 | Save only on main; main warms every key |
| Scoped (-p) and full-workspace runs share compiled dependencies | Corrected: scoping changes the enabled features | [R7] [R8] | T2 and T1 | cargo-hakari added; rule 11 |
| cargo publish works unchanged with a workspace-hack crate | Corrected: publish can reject the local-only dependency; an empty workspace-hack crate on crates.io avoids it | [R8] | T1 | Require cargo-hakari 0.9.9 or newer; plain cargo publish |
| hakari drift is checked with generate --diff and manage-deps --dry-run | Confirmed | [R8] | T1 | Added to the gates job |
| Nextest runs doctests | Corrected: it does not; the official site says to run cargo test --doc | [R5] [R11] | T1 | cargo test --doc on Tier 1 in merge_group |
| Debug info settings reduce build cost | Confirmed | [R3] | T1 | Shared .cargo/config.toml settings |
| Nextest stops at the first failure by default | Confirmed | [R4] | T1 | gate profile in .config/nextest.toml |
| Models apply an instruction only where it is stated | Corrected: scope must be explicit | [A3] | T1 | Scope sentence at the top of hard_rules |
| Models stop early or add unrequested extras | Confirmed | [A2] | T1 | not_included list and a "Done when" condition |
| The post-merge push to main should re-run tests | Inefficient: the merge queue merges the merge group whose required checks passed | [G8] | T1 | warm-cache job compiles only |
| A release dry run in the merge queue adds safety | Wasteful: the tested merge group is what reaches main [G8], and the build job on main repeats the same build | [G8] | T1 | Removed |
| Pin actions to full SHAs, disable credential persistence | Confirmed: GitHub recommends full-length SHA pins when a workflow lockfile is not used; checkout persists the token by default and persist-credentials: false opts out | [G7] [G9] | T1 | Rule 8 |
| merge_group diff base is github.event.merge_group.base_sha | Confirmed: base_sha is the merge group's parent commit | [G6] | T1 | none |
| With cancel-in-progress false, a newer queued run replaces the pending one | Confirmed for the default queue: single | [G4] | T1 | none |
| Tags and releases created with GITHUB_TOKEN do not trigger workflows | Confirmed: only workflow_dispatch, repository_dispatch, and some pull_request types are exceptions | [G5] | T1 | none |
| Conventional Commits mapping (feat minor, fix and perf patch, ! or BREAKING CHANGE major, other types no release) | Confirmed: feat, fix, and breaking come from the spec; perf = patch follows semantic-release's default; revert = no release matches the spec (semantic-release defaults reverts to patch) | [S1] [S2] | T1 | none |
| Commit-subject regex and its type list | Confirmed: matches the spec grammar (type, optional scope, optional !, colon and space); the 11 types equal commitlint's type-enum | [S1] [S3] | T1 | none |
| --locked fails when Cargo.lock needs updating | Confirmed: Cargo exits with an error when the lock file is missing or would change | [R10] | T1 | Rule 9 |
| Default contents: read is least privilege | Confirmed | [G7] | T1 | Rule 7 reason |
| A job whose needed job fails is skipped unless it uses always() | Confirmed | [G10] | T1 | Rule 10 reason; ci-ok uses always() |
| cargo fmt --check and cargo fmt --all --check behave the same | Not assumed: --all is the documented workspace-wide form; aligned with the local script | [L1] | T1 | gates job uses --all |
| x86_64 Linux links with LLD by default | Confirmed from Rust 1.90; rustup ships rust-lld, so nothing needs installing | [R12] [R17] | T1 | Shared .cargo/config.toml linker bullet (parity) |
| CI should use mold on Linux native jobs | Replaced for parity: the local script cannot assume mold, and x86_64 already links with rust-lld from 1.90. The workflow sets no linker and reads linker settings from the shared config | [R12] [R17] | T1 | build_cost linker bullet |
| clang and lld can be installed on GitHub Linux runners | Confirmed: Linux runners have passwordless sudo | [G11] | T1 | sudo apt-get install -y clang lld on jobs that need them |
| Linker settings in .cargo/config.toml are safe for zigbuild triples | Not needed: cargo zigbuild uses zig as the linker, so zigbuild triples get no linker settings | [R16] | T1 | Linker bullet limited to native triples |
| linker = "clang" with -fuse-ld=lld links any Linux triple | Corrected by test: rustc does not pass the target to clang; -C link-arg=--target=<triple> is required for a cross-link. zigbuild ignores these settings and links with zig | [L2] | T1 | Shared linker bullet adds --target (parity) |
| Use a workflow dependency lockfile instead of SHA pins | Declined: the lockfile is in public preview and subject to change; GitHub recommends SHA pins where no lockfile is used | [G7] [G12] | T1 | Rule 8: no lockfile; stop if one exists |
| macos-14 runner is arm64 | Confirmed | [G11] | T1 | none (example value) |
| actionlint is more than a syntax check | Confirmed: it type-checks expressions | [R15] | T1 | none |
| Prompt audit against [A1] [A2] [A3] [A4] | Corrected: missing rule reasons, examples, tag order, stop-and-report wording, and confirmation rules failed checklist items | [A1] [A2] [A3] [A4] | T1 | See research/prompt-audit-2026-10-18.md |
| Sonnet 5.5 can stop to check in before work is done; the fix is a keep-working instruction | Confirmed | [A2] | T1 | Ask clause removed from deliverables; ask-before rules restated as the same limits without asking |
| Explaining the intent behind instructions helps Claude apply them to unnamed cases | Confirmed | [A1] | T1 | Goal adds one paragraph: finish the deliverables, fit the work to what exists, least disruptive option |
| A one-sentence role focuses behavior and tone | Confirmed | [A1] | T1 | Role conveys seniority through experience |

## Known gaps

T0, from memory and not searched: none. Every earlier T0 row was
re-verified on 2026-10-18 (see Findings).

Sources with limits:

- [R2] is evidence from pull request discussions, not official docs.
- [R5] is a third-party blog, now backed by [R11].
- [G2] is an Enterprise Server 3.5 page, now backed by [G3].

Process gaps:

- Early revisions used search snippets of [A1]. [A1] and [A2] were read in
  full later.
- Revisit rule 8 when workflow dependency lockfiles [G12] leave public
  preview.
