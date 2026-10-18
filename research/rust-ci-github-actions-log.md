# Research log: rust-ci-github-actions

Recipe: ../recipes/rust-ci-github-actions.md
Checked: 2026-10-18
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

## Findings

| Claim | Verdict | Source | Tier | Prompt change |
| --- | --- | --- | --- | --- |
| A manual skip token in the commit message is a safe opt-out | Corrected: GitHub drops runs containing its own skip strings, and required checks stay pending | [G2] | T1 (Enterprise Server 3.5) | File-based skip only. Commit lint rejects the native strings |
| One rust-cache key can be shared by lint, check, test, and build | Corrected: jobs that compile different artifacts get cache hits that still rebuild | [R2] | T2 | shared-key per target and job type |
| The cache key must include Cargo.lock and toolchain inputs | Redundant: the action already hashes them | [R1] | T1 | Instruction removed |
| Pull requests and the merge queue can restore caches saved on main | Confirmed | [G1] | T1 | Save only on main; main warms every key |
| Scoped (-p) and full-workspace runs share compiled dependencies | Corrected: scoping changes the enabled features | [R7] [R8] | T2 and T1 | cargo-hakari added; rule 11 |
| cargo publish works unchanged with a workspace-hack crate | Corrected: publish can reject the local-only dependency; an empty workspace-hack crate on crates.io avoids it | [R8] | T1 | Require cargo-hakari 0.9.9 or newer; plain cargo publish |
| hakari drift is checked with generate --diff and manage-deps --dry-run | Confirmed | [R8] | T1 | Added to the gates job |
| Nextest runs doctests | Corrected: it does not | [R5] | T2 | cargo test --doc on Tier 1 in merge_group |
| Debug info settings reduce build cost | Confirmed | [R3] | T1 | Shared .cargo/config.toml settings |
| Nextest stops at the first failure by default | Confirmed | [R4] | T1 | gate profile in .config/nextest.toml |
| Models apply an instruction only where it is stated | Corrected: scope must be explicit | [A3] | T1 | Scope sentence at the top of hard_rules |
| Models stop early or add unrequested extras | Confirmed | [A2] | T1 | not_included list and a "Done when" condition |
| The post-merge push to main should re-run tests | Inefficient: the merge queue already ran them | none | T0 | warm-cache job compiles only |
| A release dry run in the merge queue adds safety | Wasteful: it duplicates the main build | none | T0 | Removed |
| Pin actions to full SHAs, disable credential persistence, use --locked | Standard practice | none | T0 | Rules 8 and 9 |

## Known gaps

T0, from memory and not searched:

- github.event.merge_group.base_sha as the merge-queue diff base.
- A newer queued run replaces an older pending run when
  cancel-in-progress is false.
- Tags and releases created with GITHUB_TOKEN do not trigger workflows.
- The Conventional Commits mapping and the commit-subject regex.
- Pinning actions to SHAs and persist-credentials: false as best practice.

Sources with limits:

- [G2] is an Enterprise Server 3.5 page. Recheck the github.com page for
  the native skip strings.
- [R5] is a third-party blog. Recheck the doctest limitation on nexte.st.
- [R2] is evidence from pull request discussions, not official docs.

Process gaps:

- Early revisions used search snippets of [A1]. [A1] and [A2] were read in
  full later.
- The prompt uses one example per config block. [A1] recommends 3 to 5
  examples when the output format is the main risk.
- Status stays draft until the T0 claims are verified.
