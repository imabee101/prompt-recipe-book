---
title: Rust local check and build script (fast, gate, build modes)
slug: rust-local-check-script
target_model: claude-sonnet-5-5
suggested_effort: high
status: verified
last_verified: 2026-10-19
requires: shell with git, jq, cargo, cargo-nextest, cargo-hakari, shellcheck (clang and lld for linker settings)
pairs_with: rust-ci-github-actions
---

## Prompt

```
<role>
You are a principal Rust build-tooling engineer who has spent years
building fast, dependable developer scripts for large Cargo
workspaces that many teams rely on every day.
</role>

<task>
Write one bash script, scripts/check, plus the config files it
depends on: .cargo/config.toml, .config/nextest.toml, and
.config/hakari.toml. The script checks and builds a Rust workspace
with multiple components, and the workspace uses cargo-hakari (a
workspace-hack crate). Fill <config> from the workspace itself:
read every Cargo.toml and the output of cargo metadata --locked.
Then produce the deliverables listed at the end.
</task>

<goal>
Deliver the fastest possible signal when something is wrong, and
never let a bad change pass unnoticed. Reason: slow or noisy
feedback makes developers skip checks, and a green result that
verified too little ships bugs. So the script has a scoped fast
mode for iteration and a full gate mode for before pushing, and
every green fast run states what it did not verify. Gate mode runs
the same stages as the CI pipeline, so a green local gate predicts
a green CI run.
</goal>

<hard_rules>
Apply every rule to all three modes (fast, gate, build), not only
the first one.
1. Stable Rust only. No nightly flags, no cranelift, no unstable
   Cargo options. Reason: the script must run unchanged on every
   machine.
2. Bash 3.2 compatible (macOS default) and Linux. Use
   set -euo pipefail. No associative arrays. Use jq for JSON.
   The script must pass shellcheck with no warnings. Reason: the
   script must run unchanged on every developer machine.
3. Fail fast. The first failing stage stops the script
   immediately, kills background lanes, and exits 1. The flag
   --no-fail-fast runs every stage and lists all failures.
   Reason: the first failure is the signal; later stages only add
   waiting.
4. Order stages cheapest to costliest. Reason: the quickest
   failure surfaces first.
5. Never run two cargo build, check, clippy, or test commands at
   the same time against the same target dir. Reason: Cargo
   serializes them on the build lock, so concurrency only adds
   waiting. Only non-compiling tools (cargo fmt, cargo deny,
   cargo hakari, git) run in the background beside a compiling
   lane. Run cross-target checks one after another, because one
   cargo process already uses all cores.
6. Use one target dir for every mode: target/check. Reason: the
   workspace-hack crate pins the dependency feature set, so scoped
   (-p) and workspace commands reuse each other's compiled
   dependencies. This holds only while workspace-hack is current,
   which the hakari lane enforces. Exception: the MSRV check uses
   target/check-msrv because it runs a different rustc.
7. Every cargo command uses --locked. A stale Cargo.lock fails
   the run. Reason: CI uses --locked too, so a stale lock file
   must fail here first.
8. Never set the RUSTFLAGS environment variable. Pass -D warnings
   to clippy after --. Reason: RUSTFLAGS replaces rustflags from
   .cargo/config.toml and changes fingerprints.
9. Keep the real repo's target dirs between runs: never run
   cargo clean and never delete them. Reason: Cargo stores build
   output there, and reusing it is what keeps reruns fast.
10. Change workspace-hack/Cargo.toml only through cargo hakari
    commands, never by hand. Reason: cargo hakari generates that
    file, and the hakari lane fails on any drift from its output.
11. Exit codes: 0 pass or skip, 1 check failed, 2 usage error or
    missing tool. Reason: callers can tell a failed check from a
    broken setup.
12. Implement only what this prompt specifies. Reason: every extra
    stage costs time on every run.
13. Ask before deleting files, rewriting git history, pushing, or
    committing in the real repo. Running the cargo hakari setup
    commands in <hakari_setup> is allowed. Reason: these actions
    are hard to reverse or visible to others.
14. Never invent crate names, paths, triples, or versions. Reason:
    an invented name makes the script fail on its first run. If you
    cannot find one, mark that spot with a comment starting
    UNRESOLVED: that names the value, finish the rest, and report
    which one.
</hard_rules>

<config>
Put this at the top of the script as one JSON variable. Adding a
component or target means editing only this block.

BASE_REF: default "origin/main".
FEATURES: "default" or "all". "all" adds --all-features to clippy
and tests in gate mode.
COMPONENTS: name, crates (Cargo package names), targets (triples
it ships on).
TARGETS: triple, method ("cargo" or "zigbuild").

Clippy and tests always run on the host triple. TARGETS are used
only for gate cross-checks and build mode.

<examples>
<example>
A service shipped on Linux and macOS:
COMPONENTS: {"name":"api","crates":["api","api-types"],
"targets":["x86_64-unknown-linux-gnu","aarch64-apple-darwin"]}
TARGETS: {"triple":"aarch64-apple-darwin","method":"cargo"}
</example>
<example>
A CLI cross-built for ARM Linux:
COMPONENTS: {"name":"cli","crates":["cli"],
"targets":["x86_64-unknown-linux-gnu","aarch64-unknown-linux-gnu"]}
TARGETS: {"triple":"aarch64-unknown-linux-gnu","method":"zigbuild"}
</example>
<example>
A shared library built only for the host:
COMPONENTS: {"name":"core","crates":["core","core-types"],
"targets":["x86_64-unknown-linux-gnu"]}
TARGETS: {"triple":"x86_64-unknown-linux-gnu","method":"cargo"}
</example>
</examples>
</config>

<hakari>
- The workspace-hack package name comes from hakari-package in
  .config/hakari.toml.
- Hakari lane (non-compiling, runs in the background):
  cargo hakari generate --diff, then
  cargo hakari manage-deps --dry-run.
  Gate mode always runs this lane. Fast mode runs it only when a
  changed file is any Cargo.toml, Cargo.lock, or
  .config/hakari.toml.
- On failure print: "Fix: cargo hakari generate && cargo hakari
  manage-deps", then fail the run. Reason: a stale workspace-hack
  breaks the shared target dir assumption in rule 6.
- Exclude the workspace-hack package from every -p list. It
  contains no code.
- If .config/hakari.toml is missing, exit 2 and print the one-time
  setup commands from <hakari_setup>.
</hakari>

<hakari_setup>
One-time setup, only when workspace-hack does not exist. If you
have a shell in the repo, run these steps. Otherwise list them for
the user.
1. cargo hakari init workspace-hack
2. In .config/hakari.toml set platforms to the triples in TARGETS
   plus the host triple. Keep the generated defaults for every
   other key.
3. cargo hakari generate
4. cargo hakari manage-deps
5. cargo hakari verify
6. If any crate has publish enabled for crates.io, confirm the
   workspace-hack was created by cargo-hakari 0.9.9 or newer. That
   version targets the empty workspace-hack crate already on
   crates.io, so cargo publish needs no special handling. If it
   was created by an older version, tell the user and point to the
   publishing section of the cargo-hakari documentation. Do not
   change publish settings yourself.
</hakari_setup>

<change_detection>
- base = merge-base of HEAD and BASE_REF (override with --base).
- Changed files = committed since base, plus staged, unstaged, and
  untracked (git ls-files --others --exclude-standard).
- Skip rule: when the changed set is non-empty and every file
  matches docs/**, **/*.md, LICENSE*, or
  .github/ISSUE_TEMPLATE/**, print
  "docs-only: nothing to check" and exit 0. --force disables
  skipping. In fast mode an empty changed set prints
  "no changes: nothing to check" and exits 0. Gate mode with an
  empty changed set runs everything.
- Affected crates (fast mode only) = workspace members containing
  any changed non-docs file, plus all their workspace reverse
  dependencies (normal, build, and dev edges) from
  cargo metadata --locked, excluding the workspace-hack package.
- If a changed file is Cargo.lock, a root Cargo.toml, the
  workspace-hack Cargo.toml, rust-toolchain*, anything under
  .cargo/, .config/nextest.toml, .config/hakari.toml, deny.toml,
  or scripts/check, all workspace members are affected.
</change_detection>

<modes>
1. fast (default; run as scripts/check or scripts/check fast)
   a. preflight (target under 1 second): confirm git, jq,
      cargo-hakari (0.9.9 or newer), and cargo-nextest (0.9.89 or
      newer) exist, plus clang and lld when .cargo/config.toml sets
      linker settings for a triple this run builds; confirm
      .config/hakari.toml exists, validate Cargo.lock with
      cargo metadata --locked, run change detection and the skip
      rule.
   b. In the background: cargo fmt -p <affected> --check, plus the
      hakari lane when its trigger applies.
   c. clippy: cargo clippy -p <affected> --all-targets --locked
      --message-format short -- -D warnings
   d. test: cargo nextest run -p <affected> --locked
      --profile fast --no-tests=pass
   Doc tests, MSRV, and commit-message lint are not run in fast
   mode.

2. gate (run as scripts/check gate): full workspace, no affected
   filtering. Reason: affected detection can miss dependencies such
   as build scripts and data files, and the gate is what must be
   trusted.
   a. preflight (same as fast).
   b. In the background: cargo fmt --all --check, the hakari
      lane, and commit lint. Also cargo deny check, only when a
      changed file is any Cargo.toml, Cargo.lock, or
      .config/hakari.toml.
      Commit lint: every commit subject in base..HEAD must match
      ^(feat|fix|perf|docs|chore|ci|test|style|refactor|build|revert)(\([^)]+\))?!?: .+
      and no subject or body may contain [skip ci], [ci skip],
      [no ci], [skip actions], [actions skip], or skip-checks:.
      On failure print the offending short SHA and subject.
   c. clippy --workspace --all-targets -- -D warnings
   d. cargo nextest run --workspace --profile gate
   e. cargo test --doc --workspace (nextest does not run doctests)
   f. For each target in TARGETS: cargo check --target <triple>
      -p <crates of components that ship on that triple>. If the
      rust target is not installed, fail and print the exact
      rustup target add command.
   g. MSRV (last stage): let M be the highest rust-version among
      workspace members, from cargo metadata. If M is unset, print
      "MSRV: not configured" and continue. Otherwise run
      cargo +M check --workspace --locked with
      CARGO_TARGET_DIR=target/check-msrv. If toolchain M is
      missing, fail and print:
      rustup toolchain install M --profile minimal

3. build (run as scripts/check build [component ...]
   [--target <triple|all>])
   - Defaults: all components, host triple only. "--target all"
     builds every target listed for each selected component.
   - For each triple, run one cargo invocation covering all
     selected components:
     cargo build --release --locked -p a -p b
     for the host triple, and
     cargo build --release --locked --target <triple> -p a -p b
     for any other triple (cargo zigbuild instead of cargo build
     when the target's method is zigbuild).
   - After success, copy binaries to dist/<component>/<triple>/
     and write SHA256SUMS there (shasum -a 256, portable).
   - Print each artifact with its size. Build mode does not run
     tests and says so in its last line.
</modes>

<config_files>
.cargo/config.toml
- [profile.dev]: debug = "line-tables-only"
- [profile.dev.package."*"]: debug = false
- Linker settings only for Linux triples other than
  x86_64-unknown-linux-gnu whose method is cargo: linker = "clang"
  with rustflags ["-C", "link-arg=--target=<triple>", "-C",
  "link-arg=-fuse-ld=lld"]. The --target argument is required:
  rustc does not pass the target to clang, so without it a
  cross-link from another host links for the host architecture.
  Cross-linking also needs the target's C library (on Ubuntu,
  libc6-dev-arm64-cross for aarch64). Triples built
  with cargo zigbuild get no linker settings, because zig is their
  linker. If rust-toolchain.toml pins a release older than Rust
  1.90, add the same settings for x86_64-unknown-linux-gnu.
  Reason: from Rust 1.90, x86_64-unknown-linux-gnu links with
  rust-lld, which rustup ships, while other Linux targets use the
  slower system linker.

.config/nextest.toml
- [profile.fast]: fail-fast = { max-fail = 1, terminate =
  "immediate" }, failure-output = "immediate-final"
- [profile.gate]: fail-fast = { max-fail = 1 },
  failure-output = "immediate-final",
  slow-timeout = { period = "60s", terminate-after = 5 }
  (comment: raise this if a legitimate test needs longer)
- --no-fail-fast on the script maps to nextest --no-fail-fast.

.config/hakari.toml
- Generated by cargo hakari init, then edited as described in
  <hakari_setup>.
</config_files>

<output_format>
- Stage start: "[run] <stage> (<N> crates | workspace)"
- Stage success: "[ok] <stage> <seconds>s"
- Stage failure: print the captured tool output, then
  "[FAIL] <stage> <seconds>s", then at the very end of the output:
  "FAIL: <stage>. Rerun: <exact command>". Reason: the last lines
  are the most visible in a terminal.
- Pass in fast mode: "PASS fast in <N>s. Not verified: unaffected
  crates, doc tests, cross-target checks, MSRV, commit messages.
  Run scripts/check gate before pushing."
- Pass in gate mode: "PASS gate in <N>s."
- Passing stages print only their [ok] line. Failing stages print
  everything. Capture each stage to
  target/check-logs/<mode>-<stage>.log.
- Flag --full streams all tool output live and drops
  --message-format short.
- Color only when stdout is a terminal.
- Supported flags are exactly: --base, --full, --no-fail-fast,
  --force, --target (build mode only).
</output_format>

<verification>
If you have a shell:
1. Run shellcheck on scripts/check and fix every warning.
2. In a scratch workspace in a temporary directory, never in the
   real repo, with three crates (a, b depends on a, c depends on
   b) and a workspace-hack crate, verify:
   - a docs-only change exits 0 immediately;
   - a change in a reports a, b, c as affected;
   - a deliberate clippy warning stops at clippy, never starts
     nextest, and exits 1;
   - a deliberately failing test fails in nextest and prints the
     Rerun line;
   - adding a dependency to one crate without running cargo hakari
     generate fails the hakari lane and prints the Fix line;
   - after a fast run, the gate clippy stage log shows no
     "Compiling" line for any non-workspace crate;
   - a commit with the subject "updated stuff" fails the gate's
     commit lint;
   - a commit containing "[skip ci]" is rejected by the gate's
     commit lint;
   - gate mode passes on a clean tree.
3. Run scripts/check gate in the real repo and report its result.
4. Delete the scratch workspace.
5. Report the actual output of each check.
If you have no shell, state that the script is untested. Never
claim a check passes without having run it. When a check fails,
fix the script, never the check, and make the script work for
every workspace that matches <config>, not only the scratch one.
</verification>

<not_included>
Watch mode, coverage, miri, fuzzing, benchmarks, sccache, nightly
features, cranelift, automatic tool installation, git hook
installation, CI workflows, versioning, and releasing.
</not_included>

<deliverables>
Done when all of these are produced and the verification results
are reported. Keep working until then; the actions in hard rule 13
are the only ones that wait for the user. Then stop and report.
Mention possible improvements at the end instead of making them.
Produce them in this order:
1. scripts/check, complete and commented, with no placeholders
   other than UNRESOLVED: comments from hard rule 14.
2. .cargo/config.toml, .config/nextest.toml, and
   .config/hakari.toml.
3. The one-time hakari setup commands, marked as already run or
   still to run.
4. A table: mode | stages in order | scope | what it catches.
5. A table: mode | what a green result verifies | what it does
   not verify.
6. Three sentences on usage: run scripts/check while iterating and
   scripts/check gate before pushing; point
   rust-analyzer.cargo.targetDir at its own directory so the IDE
   does not block the script; the first build is slower because
   workspace-hack compiles more dependencies up front.
7. Decisions: each choice you made that this prompt left open, with
   the evidence behind it, one line each.
</deliverables>
```

## Usage

Paste the prompt into a Claude session opened in the Rust repository.
The session needs the tools listed under requires to verify its work.
Gate mode runs the same stages as rust-ci-github-actions.
Run scripts/check while iterating and scripts/check gate before pushing.
Re-run the log's claims before reuse if last_verified is over 90 days old.

## Provenance

[Research log](../research/rust-local-check-script-log.md)
