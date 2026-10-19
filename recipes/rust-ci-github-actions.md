---
title: Rust CI pipeline on GitHub Actions (one event-driven workflow)
slug: rust-ci-github-actions
target_model: claude-sonnet-5-5
suggested_effort: high
status: verified
last_verified: 2026-10-19
requires: shell with actionlint (optional)
pairs_with: rust-local-check-script
---

## Prompt

```
<role>
You are a principal CI/release engineer who has built and run
production GitHub Actions pipelines for large Rust monorepos through
years of releases.
</role>

<task>
Write one file, .github/workflows/ci.yml. It lints, checks, tests,
versions, builds, and releases a Rust workspace that has multiple
components and multiple target triples. The workspace uses
cargo-hakari (a workspace-hack crate). Fill <config> from the
workspace itself: read every Cargo.toml and the output of
cargo metadata --locked. Look up each action's latest release and
its commit SHA in the action's own repository. Then produce the
deliverables listed at the end. If you have a shell, validate the
YAML with actionlint and follow <verification>. Otherwise, review
the file against the rules below.
</task>

<goal>
Every pull request gets fast, high-confidence feedback. A job runs
only when the event and the diff make it relevant. This keeps cost
low and prevents multi-hour builds. The same stages exist in the
local script scripts/check gate, so a green local gate predicts a
green CI run.

Carry the work through to the finished deliverables. Fit ci.yml to
the repository as it stands: keep every existing feature working,
and create only the files this prompt names. Where this prompt leaves
room, choose the option that meets it with the least disruption to
the repository.
</goal>

<hard_rules>
Apply every rule to every job, not only the first one. Follow each
rule and its reason.
1. One workflow file, no others. Reason: one pipeline is the only
   place where ordering and cost can be reasoned about.
2. Triggers: pull_request, push to main, merge_group. No schedule,
   cron, polling, workflow_run, or workflow_dispatch. Reason: the
   pipeline must be purely event-driven.
3. Dependency updates stay manual: add no Dependabot, Renovate,
   or other bot config. Reason: the requirements call for one
   event-driven pipeline with no bots.
4. This pipeline does all versioning and releasing, from git tags
   only: no manual version bumps and no external release tools.
   Reason: one source of truth keeps versions consistent and makes
   re-runs safe.
5. Timeouts (timeout-minutes): changes 5, gates 10,
   check-targets 15, test 20, msrv 15, warm-cache 20, version 5,
   build 30, release 10, ci-ok 5. Reason: a hung job must not
   burn hours.
6. Concurrency group: ci-${{ github.ref }}. cancel-in-progress is
   true only for pull_request. Reason: stale PR runs are waste;
   main must finish, and because versions come from git tags, a
   later main run releases everything an earlier cancelled-pending
   run would have.
7. Default permissions: contents: read. Only the release job gets
   contents: write. Reason: least privilege; a compromised step in
   any other job cannot write to the repository.
8. Pin every third-party action to a full commit SHA with a
   version comment. Checkout uses persist-credentials: false.
   Create no workflow dependency lockfile
   (.github/workflows/actions.lock). Reason: supply-chain safety;
   the lockfile is in public preview and subject to change, and
   GitHub recommends SHA pins where no lockfile is used. If the
   repository already has that lockfile, stop and report it.
9. Every cargo command uses --locked. Reason: CI must fail if
   Cargo.lock is out of date.
10. Cheap jobs run first. Each expensive job lists the cheaper
    jobs in needs:. Reason: a job whose needed job fails is
    skipped, so a cheap failure stops the expensive jobs.
11. The workspace uses cargo-hakari. Every cargo command selects
    crates with -p or --workspace. Never hand-edit
    workspace-hack/Cargo.toml. Exclude the workspace-hack package
    from every -p list. Reason: the workspace-hack crate keeps the
    dependency feature set identical for -p and --workspace runs,
    so caches warmed on main by full-workspace runs are fully
    reused by affected-only runs on pull requests.
12. If any rule conflicts with real GitHub behavior, stop and
    state the conflict. Reason: a silent workaround hides a broken
    rule from the user.
13. Leave git history, existing files outside this prompt's list,
    tags, and published packages as they are, and push nothing.
    Reason: these actions are hard to reverse or visible to
    others.
14. Never invent crate names, paths, runner labels, versions, or
    action SHAs. Reason: an invented SHA or crate name breaks the
    workflow on its first run. If you cannot look one up, stop and
    report which one.
</hard_rules>

<config>
Put this at the top of the file as one JSON block in env. Adding a
component or target means editing only this block.

COMPONENTS: name, path globs, crates, shipped targets,
versioned (true/false), publish (true/false, crates.io).
TARGETS: name, triple, runner, method (native or zigbuild),
tier (1 or 2), tested (true/false), paths (globs of files that
only matter to this target, such as src/sys/windows/**).

Tier 1 is x86_64-unknown-linux-gnu: native, tested.
Tier 2 is every other shipped triple. Tier 2 with a native runner
is tested. Tier 2 built with zigbuild is not tested.

<examples>
<example>
A service shipped on Linux and macOS, released but not published:
COMPONENTS: {"name":"api","paths":["crates/api/**"],
"crates":["api"],"targets":["x86_64-unknown-linux-gnu",
"aarch64-apple-darwin"],"versioned":true,"publish":false}
TARGETS: {"name":"macos-arm","triple":"aarch64-apple-darwin",
"runner":"macos-14","method":"native","tier":2,"tested":true,
"paths":["**/sys/macos/**"]}
</example>
<example>
A CLI published to crates.io, cross-built for ARM Linux:
COMPONENTS: {"name":"cli","paths":["crates/cli/**"],
"crates":["cli"],"targets":["x86_64-unknown-linux-gnu",
"aarch64-unknown-linux-gnu"],"versioned":true,"publish":true}
TARGETS: {"name":"linux-arm","triple":"aarch64-unknown-linux-gnu",
"runner":"ubuntu-latest","method":"zigbuild","tier":2,
"tested":false,"paths":["**/sys/linux/**"]}
</example>
<example>
A shared library that is never released on its own:
COMPONENTS: {"name":"core","paths":["crates/core/**"],
"crates":["core","core-types"],"targets":[
"x86_64-unknown-linux-gnu"],"versioned":false,"publish":false}
TARGETS: {"name":"linux","triple":"x86_64-unknown-linux-gnu",
"runner":"ubuntu-latest","method":"native","tier":1,
"tested":true,"paths":[]}
</example>
</examples>
</config>

<shared_config_files>
Create these files only if they do not already exist. Both are
shared with the local script scripts/check.

.cargo/config.toml
- [profile.dev]: debug = "line-tables-only"
- [profile.dev.package."*"]: debug = false
- Linker settings only for Linux triples other than
  x86_64-unknown-linux-gnu whose method is native: linker = "clang"
  with rustflags ["-C", "link-arg=--target=<triple>", "-C",
  "link-arg=-fuse-ld=lld"]. The --target argument is required:
  rustc does not pass the target to clang, so without it a
  cross-link from another host links for the host architecture.
  Cross-linking also needs the target's C library (on Ubuntu,
  libc6-dev-arm64-cross for aarch64). Triples built
  with cargo zigbuild get no linker settings, because zig is their
  linker. If rust-toolchain.toml pins a release older than Rust
  1.90, add the same settings for x86_64-unknown-linux-gnu.

.config/nextest.toml (requires cargo-nextest 0.9.89 or newer)
- [profile.fast]: fail-fast = { max-fail = 1, terminate =
  "immediate" }, failure-output = "immediate-final"
- [profile.gate]: fail-fast = { max-fail = 1 },
  failure-output = "immediate-final",
  slow-timeout = { period = "60s", terminate-after = 5 }
</shared_config_files>

<skip_logic>
- Do not use paths-ignore on triggers. The workflow always starts.
- The changes job sets skip=true when every changed file matches
  docs/**, **/*.md, LICENSE*, or .github/ISSUE_TEMPLATE/**.
- When skip=true, every job except changes and ci-ok is skipped,
  and ci-ok reports success.
- Do not implement a commit-message skip token. GitHub natively
  drops runs containing [skip ci], [ci skip], [no ci],
  [skip actions], [actions skip], or a skip-checks: trailer, which
  leaves required checks pending and blocks merges. The commit
  lint on pull requests must reject those strings.
- A skipped push to main cuts no release.
</skip_logic>

<jobs>
Create these jobs in order.

1. changes
   - Check out with fetch-depth: 0 (history and tags needed).
   - Diff base per event: pull_request uses the three-dot diff
     from github.event.pull_request.base.sha; merge_group uses
     github.event.merge_group.base_sha; push uses
     github.event.before.
   - Outputs: skip, deps_changed, affected components (JSON),
     affected targets (JSON), and per-target matrices (fromJSON).
   - deps_changed=true when any changed file is a Cargo.toml,
     Cargo.lock, or .config/hakari.toml.
   - Affected components = components with changed files plus all
     reverse dependencies from cargo metadata, excluding the
     workspace-hack package.
   - Changes to Cargo.lock, rust-toolchain.toml, the workspace-hack
     Cargo.toml, .config/hakari.toml, .cargo/config.toml,
     .config/nextest.toml, a shared crate, or
     .github/workflows/ci.yml mark all components affected.
   - Unaffected targets get no matrix entry, so no job.

2. gates (needs: changes; runs when skip=false)
   - cargo fmt --all --check
   - cargo clippy --all-targets --locked -- -D warnings on
     x86_64-unknown-linux-gnu. On pull_request and merge_group use
     -p <affected crates>. On push to main use --workspace
     (ignore the affected filter) so the lint cache stays warm.
     This also covers Tier 1 compile checking.
   - cargo deny check when deps_changed=true.
   - When deps_changed=true, run cargo hakari generate --diff and
     cargo hakari manage-deps --dry-run (both non-compiling). On
     failure print: "Fix: cargo hakari generate && cargo hakari
     manage-deps".
   - pull_request only: lint every commit subject in the PR
     against
     ^(feat|fix|perf|docs|chore|ci|test|style|refactor|build|revert)(\([^)]+\))?!?: .+
     and reject any subject or body containing the native
     skip strings listed in <skip_logic>.

3. check-targets (needs: gates; pull_request and merge_group)
   - Matrix by target (one leg per target). Each leg runs
     cargo check --target <triple> --locked
     -p <affected crates for that target>.
   - Tier 1 is excluded because clippy already covers it.
   - pull_request: only Tier 2 targets whose `paths` globs match
     a changed file.
   - merge_group: all Tier 2 targets.

4. test (needs: gates; pull_request and merge_group)
   - Matrix by target (one leg per target).
   - cargo nextest run --locked --profile gate
     -p <affected crates>, run natively on the runner with no
     --target flag.
   - pull_request: Tier 1 only.
   - merge_group: Tier 1 plus every Tier 2 target with
     tested=true. On Tier 1 also run
     cargo test --doc --locked --workspace.

5. msrv (needs: gates; merge_group and push to main)
   - Let M be the highest rust-version among workspace members,
     from cargo metadata. If none is set, skip the job's steps and
     print "MSRV: not configured".
   - Install M with rustup toolchain install M --profile minimal,
     then run cargo +M check --workspace --locked.
   - Runs on x86_64-unknown-linux-gnu only.

6. warm-cache (needs: gates; push to main only; skip=false)
   - Purpose: save the caches that pull_request and merge_group
     runs restore. Tests already passed in the merge queue, so do
     not run them.
   - For all components (ignore the affected filter), per target:
     cargo check --target <triple> and
     cargo nextest run --no-run (host triple only, on targets with
     tested=true). The gates job warms the lint key and the msrv
     job warms the msrv key.

7. version (needs: gates; push to main only)
   - Source of truth: git tags named <component>-vX.Y.Z.
   - For each component with versioned=true, read commits since
     its last tag: feat = minor; fix and perf = patch; "!" or
     BREAKING CHANGE = major; docs, chore, ci, test, style,
     refactor, build, and revert = no release.
   - Components with no releasable commits are excluded. If none
     remain, output release=false.
   - Never commit to main. No version-bump commits.
   - Pass versions to builds as CI_VERSION_<COMPONENT_NAME>
     environment variables, read by that component's build.rs.
     Do not edit Cargo.toml in the repo.
   - If a tag already exists, reuse it and continue. Re-runs must
     succeed.
   - Output the release matrix: per target, the released
     components and versions.

8. build (needs: version; release=true; push to main only)
   - Matrix by target (one leg per target). Each leg builds all
     released components for that target in one command:
     cargo build --release --locked --target <triple>
     -p a -p b.
   - native method: build on the target runner.
   - zigbuild method: cargo zigbuild --release --locked
     --target <triple> -p a -p b on ubuntu-latest.
   - Upload artifacts and SHA256 checksums.

9. release (needs: build; push to main only)
   - Create tag <component>-vX.Y.Z at the pushed commit.
   - Create one GitHub Release per component with notes
     generated from its conventional commits. Attach artifacts
     and checksums.
   - Run cargo publish --locked -p <crate> for components with
     publish=true, using the CARGO_REGISTRY_TOKEN secret, in this
     job only. This needs no special handling because the
     workspace-hack setup from cargo hakari init (cargo-hakari
     0.9.9 or newer) targets the empty workspace-hack crate
     already on crates.io.
   - Comment in the file: tags and releases created with
     GITHUB_TOKEN do not trigger workflows, so there is no loop.

10. ci-ok (needs: all jobs above; if: always())
    - The only required status check for branch protection and the
      merge queue.
    - Pass when every needed job succeeded or was skipped because
      skip=true or release=false. Fail when any needed job has
      result failure or cancelled.
</jobs>

<cache>
- Use Swatinem/rust-cache on every Rust job. It already hashes
  Cargo manifests, lockfiles, and toolchain files into the key,
  so do not add those yourself.
- shared-key = "<target-triple>-<job-type>", where job-type is one
  of lint, check, test, msrv, release. Reason: each job type
  compiles different artifacts, and sharing one key across them
  causes cache hits that still rebuild.
- Matrix legs are per target, never per component, so no two
  legs write the same key.
- save-if: github.ref == 'refs/heads/main'. Pull requests and the
  merge queue only restore. They fall back to main's caches.
- The gates, msrv, and warm-cache jobs on main run with all
  components so every key used by pull requests and merge_group
  stays warm.
- Release builds restore and save their own "-release" keys on
  main only.
- Above each cache step, add a comment explaining why it hits.
  After each cache step, print the cache-hit output.
</cache>

<build_cost>
- rust-toolchain.toml pins the toolchain and lists all targets.
- Set CARGO_INCREMENTAL=0 in the workflow env. Take all profile
  settings from the committed .cargo/config.toml. Do not repeat
  them in env.
- Never set RUSTFLAGS in the workflow. Reason: it replaces
  rustflags from .cargo/config.toml. Pass -D warnings to clippy
  after --.
- Set no linker in the workflow. From Rust 1.90,
  x86_64-unknown-linux-gnu links with rust-lld, which rustup ships;
  every other linker setting comes from .cargo/config.toml. On a
  native Linux job whose triple has linker settings there, run
  sudo apt-get install -y clang lld before building.
- Install cargo-nextest, cargo-deny, cargo-hakari, and
  cargo-zigbuild with taiki-e/install-action. Never use
  cargo install.
- Every matrix sets fail-fast: true and max-parallel: 6.
</build_cost>

<verification>
If you have a shell:
1. Run actionlint on ci.yml and fix every finding.
2. Confirm by search: no schedule or workflow_dispatch trigger,
   every job has timeout-minutes, every third-party action is
   pinned to a full SHA, no RUSTFLAGS, and every cargo command has
   --locked.
3. Confirm that no two matrix legs can write the same rust-cache
   shared-key.
4. Delete any temporary files you created for these checks.
5. Report the actual output of each check.
If you have no shell, state that the file is unvalidated. Never
claim a check passes without having run it. When a check fails,
fix ci.yml, never the check.
</verification>

<not_included>
Include only the jobs above. Leave out miri, fuzzing, benchmarks,
coverage, scheduled or nightly checks, tests for zigbuild targets,
and release dry runs in the merge queue.
</not_included>

<deliverables>
Done when all of these are produced and the verification results
are reported. Keep working until then. Then stop and report.
Mention possible improvements at the end instead of making them. Produce them in this order:
1. The complete ci.yml with brief comments and no placeholders.
2. Any shared config file from <shared_config_files> that did not
   already exist.
3. A table: job | trigger event | components and targets covered |
   expected runtime | what it catches.
4. A table of events (pull_request, merge_group, push to main with
   docs-only, push to main with code), each marked skip, check
   only, test, cache warm, or release.
5. The list of targets that are built but never tested.
6. Two sentences on how to cut a release: merge a feat or fix
   commit to main.
7. One sentence confirming the one-time hakari setup
   (cargo hakari init, manage-deps, generate) is committed
   before this workflow is enabled.
</deliverables>
```

## Usage

Paste the prompt into a Claude session opened in the Rust repository.
A shell lets the session run actionlint and the verification checks.
Commit the one-time cargo-hakari setup before enabling the workflow.
Run rust-local-check-script in the same repository to keep both in parity.
Re-run the log's claims before reuse if last_verified is over 90 days old.

## Provenance

[Research log](../research/rust-ci-github-actions-log.md)
