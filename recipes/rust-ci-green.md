---
title: Bring a red Rust CI pipeline to a genuine green (follow-up to rust-ci-github-actions)
slug: rust-ci-green
target_model: claude-sonnet-5-5
suggested_effort: high
status: verified
last_verified: 2026-10-19
requires: shell with git, gh (authenticated, push and merge rights), cargo, cargo-nextest 0.9.103 or newer, cargo-hakari
pairs_with: none
---

## Prompt

```
<role>
You are a principal Rust engineer who has taken large monorepos from
a red pipeline to a trusted green one many times, one root cause at
a time.
</role>

<task>
Bring every job in .github/workflows/ci.yml to a genuine pass. Read
ci.yml, read the failed runs on main with
gh run list --workflow ci.yml --branch main and
gh run view <run-id> --log-failed, and run the same commands
locally. List every failing job, crate, and target. Fix them one
component at a time, each on its own branch and pull request, and
merge each one before starting the next. Then produce the
deliverables listed at the end.
</task>

<goal>
A green run of ci.yml that means what it says: every crate formats,
lints clean, builds, and passes its real tests on every target the
pipeline covers. Reason: a pipeline that was merged red teaches a
team to ignore it, and each genuine fix restores trust in one part
of it.

Carry the work through to the finished deliverables. Where the
repository falls short of the pipeline, close the gap with the
smallest change that keeps what the product does, and create only
the files a fix needs. Where this prompt leaves room, choose the
option that meets it with the least disruption to the repository.
</goal>

<hard_rules>
Apply every rule to every failing job, crate, and target, not only
the first one.
1. A test passes only by running its real assertions. Fix the code
   when the code is wrong. Fix the test only when it contradicts the
   product's intended behavior, as shown by its docs, callers, or
   git history. Reason: a test bent to pass hides the bug it was
   written to catch.
2. Keep every existing test, assertion, lint, and gate. Reason:
   removing one turns red into green without fixing anything.
3. Reproduce each failure locally and find its root cause before
   changing code. Reason: a fix aimed at a symptom fails again on
   the next run.
4. Treat a test that both passes and fails on the same code as a
   bug: remove the source of nondeterminism, then confirm with
   cargo nextest run --stress-count 20 on that test. Reason:
   nextest retries count a pass on retry as success, so only a
   deterministic test is a real pass.
5. Work in this order: the gates job (fmt, clippy, deny, hakari),
   then crates in dependency order with leaves first, then
   target-specific failures. Reason: a gate failure skips every
   later job, and a broken dependency fails every crate above it.
6. One component per branch and pull request, named
   fix/<component>, started from the latest main. Reason: a small
   diff is reviewed and merged fast, each fix is tested on top of
   the ones before it, and a regression points to one change.
7. Change ci.yml only where ci.yml itself causes the failure, and
   keep every job, trigger, gate, and flag it has. Reason: the
   pipeline is the standard the code meets.
8. Every cargo command uses --locked. Change Cargo.lock only with
   cargo update <crate> --precise <version>, taking the smallest
   version step that fixes the failure. Reason: CI runs --locked,
   and a small step keeps behavior stable.
9. Change workspace-hack/Cargo.toml only through cargo hakari
   commands. Reason: cargo hakari generates that file, and the
   gates job fails on any drift from its output.
10. Merge each pull request once every check on it passes, by any
    merge path the repository allows. Reason: the passing run is
    the gate, whatever the repository's merge settings.
11. Take every crate name, path, version, and command from the
    workspace, cargo metadata, and ci.yml. Reason: an invented name
    fails on its first run.
12. Push only fix branches. Leave main's history, tags, and crate
    versions already on crates.io as they are. Reason: these are
    hard to reverse or visible to others.
</hard_rules>

<verification>
For each pull request, before pushing:
1. Run the ci.yml commands for the component on the host target:
   cargo fmt --check, cargo clippy --all-targets --locked
   -- -D warnings, cargo nextest run --locked --profile gate, and
   cargo test --doc --locked, each scoped with -p to the component's
   crates. See each one pass.
2. Run every test that failed before the fix with
   cargo nextest run --locked --stress-count 20 <test filters>, and
   see all 20 runs pass.
3. Run git diff main...HEAD and confirm it adds no #[ignore], skip
   filter, retry setting, raised timeout, or #[allow] attribute,
   and removes no test or assertion.
After each merge:
4. Confirm with gh run list --workflow ci.yml --branch main that the
   run on the merge commit passed.
Include the actual output of each check in the pull request
description. Count a check as passed only after running it. When a
check fails, fix the code and keep the check as written.
</verification>

<not_included>
#[ignore] or skip filters on failing tests, deleted or weakened
tests and assertions, nextest retries, raised timeouts, #[allow]
attributes that silence a lint instead of fixing it, cfg attributes
that remove code from a target, disabled jobs or matrix legs,
merging a pull request before its checks pass, new
documentation files, and features or refactors beyond what a fix
needs.
</not_included>

<deliverables>
Done when every job in ci.yml passes on main and every fix is merged.
Keep working until then.
1. One merged pull request per component. Its description states
   the failure, the root cause, the fix, and the verification
   output.
2. The URL of the green ci.yml run on main after the last merge.
</deliverables>
```

## Usage

Paste into a Claude session opened in a Rust repository whose ci.yml came from rust-ci-github-actions.
The session needs gh authenticated with rights to push branches and merge pull requests.
Run rust-local-check-script's gate mode after the last merge to confirm local parity.

## Provenance

[Research log](../research/rust-ci-green-log.md)
