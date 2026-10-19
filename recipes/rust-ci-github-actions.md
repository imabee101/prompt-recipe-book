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
You are the lead CI/release engineer for this Rust monorepo, with
full authority over its GitHub Actions setup and ownership of every
judgment call in this run.
</role>

<task>
Write .github/workflows/ci.yml. It lints, checks, tests, versions,
builds, and releases a Rust workspace that has multiple components
and multiple target triples. The workspace uses cargo-hakari (a
workspace-hack crate). Fill <config> from the workspace itself:
read every Cargo.toml and the output of cargo metadata --locked.
Read every existing file under .github/ before writing. Look up
each action's latest release and its commit SHA in the action's
own repository. Then produce the deliverables listed at the end.
If you have a shell, validate the YAML with actionlint and follow
<verification>. Otherwise, review the file against the rules below.
</task>

<goal>
Every pull request gets fast, high-confidence feedback. A job runs
only when the event and the diff make it relevant. This keeps cost
low and prevents multi-hour builds. The same stages exist in the
local script scripts/check gate, so a green local gate predicts a
green CI run.

The user read this prompt and chose to run it, so its requirements
are approved: they describe the state the repository must reach.
Bring it there in this run and record each judgment call so the
user can review it afterwards. The repository may be new or
existing. In a new one, build that state directly. In an existing
one, bring it into line: keep what already meets this prompt,
reshape what conflicts so it runs production-ready, and add what is
missing. Every existing workflow, job, and feature was built for a
purpose, so change how it runs and keep what it does.
</goal>

<hard_rules>
Apply every rule to every job and every existing workflow, not only
the first one. Follow each rule and its reason.
1. ci.yml is the one workflow for linting, checking, testing,
   versioning, building, and releasing. Reason: one pipeline is the
   only place where ordering and cost can be reasoned about.
2. ci.yml triggers on exactly pull_request, push to main, and
   merge_group. Reason: the pipeline must be purely event-driven.
3. Dependency updates stay manual. Reason: the requirements call for
   one event-driven pipeline with no bots.
4. This pipeline does all versioning and releasing, from git tags
   only. Reason: one source of truth keeps versions consistent and
   makes re-runs safe.
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
   version comment. Checkout uses persist-credentials: false. If
   the repository already has a workflow dependency lockfile
   (.github/workflows/actions.lock), keep it, pin by SHA as well,
   and record it under Decisions. Reason: supply-chain safety; the
   lockfile is in public preview and subject to change, and GitHub
   recommends SHA pins where no lockfile is used.
9. Every cargo command uses --locked. Reason: CI must fail if
   Cargo.lock is out of date.
10. Cheap jobs run first. Each expensive job lists the cheaper
    jobs in needs:. Reason: a job whose needed job fails is
    skipped, so a cheap failure stops the expensive jobs.
11. The workspace uses cargo-hakari. Every cargo command selects
    crates with -p or --workspace. Change
    workspace-hack/Cargo.toml only through cargo hakari commands.
    Exclude the workspace-hack package from every -p list. Reason:
    the workspace-hack crate keeps the dependency feature set
    identical for -p and --workspace runs, so caches warmed on main
    by full-workspace runs are fully reused by affected-only runs
    on pull requests.
12. When a rule conflicts with real GitHub behavior, follow GitHub's
    actual behavior in the way that best serves the rule's reason,
    and record the conflict under Decisions. Reason: a silent
    workaround hides a broken rule from the user.
13. Make every judgment call yourself and keep working. When this
    prompt leaves a choice open, decide from these sources, in
    order: (a) this prompt's explicit requirements; (b) the reason
    on the closest rule, which names what that rule protects;
    (c) the repository's own evidence: CLAUDE.md, README,
    manifests, lockfiles, existing workflows and scripts, code
    style, and git history; (d) the tool's documented default;
    (e) of the options left, the one easiest to undo. Where this
    prompt and the repository disagree, follow this prompt and
    write the result in the repository's existing style. Record
    each call under Decisions. Reason: the user approved this
    prompt by running it and reviews decisions after the run, and
    these sources already answer what a mid-run question would ask.
14. Keep every behavior the repository already has. When an
    existing workflow, job, script stage, setting, or feature
    conflicts with this prompt, reshape it to meet the prompt and
    keep what it does: change its trigger, scope, order, or
    location. Remove an existing item only when your output now
    does the same work, and record where. <not_included> limits
    what you add; existing items it names stay. Reason: existing
    work was built for a purpose this prompt may not mention, and
    production-ready means reshaped, with every feature kept.
15. Make each change the smallest one that reaches the target and
    can be undone. Edit existing files in place. Merge required
    keys into an existing config file and keep its other keys.
    Move or rename files with git mv. Before changing a file that
    has uncommitted changes or is untracked, copy it to
    ~/recipe-backups/<repository name>/<YYYY-MM-DD>/ and report
    the path. Leave your changes uncommitted in the working tree
    with a suggested commit message, so git history stays as it
    is. Pushes, tags, and releases happen after the user reviews
    and merges the changes. Reason: git restores only committed
    content, and this way every change stays reviewable with
    git diff and reversible in one step.
16. Take every crate name, path, runner label, version, and action
    SHA from the repository or the tool's own source. When one
    cannot be found here, write a comment starting BLOCKED: that
    names the value and where to find it, finish every other part,
    and list it under Blocked. Reason: an invented value breaks
    the workflow on its first run, while a marked gap is found at
    once.
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
A shared library with no release of its own:
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
Both files are shared with the local script scripts/check. Create
each one if it is missing. If it exists, merge in the keys below
and keep its other keys.

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
- Leave paths and paths-ignore off the triggers, so the workflow
  always starts.
- The changes job sets skip=true when every changed file matches
  docs/**, **/*.md, LICENSE*, or .github/ISSUE_TEMPLATE/**.
- When skip=true, every job except changes and ci-ok is skipped,
  and ci-ok reports success.
- Skip runs only through the changes job's file check. GitHub
  natively drops runs containing [skip ci], [ci skip], [no ci],
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
     runs restore. Tests already passed in the merge queue, so this
     job compiles only.
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
   - Versions live only in tags and build environment variables,
     so this job commits nothing to main and leaves Cargo.toml
     versions as they are.
   - Pass versions to builds as CI_VERSION_<COMPONENT_NAME>
     environment variables, read by that component's build.rs.
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
     GITHUB_TOKEN start no new workflow runs, so there is no loop.

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
  so the key needs nothing added for them.
- shared-key = "<target-triple>-<job-type>", where job-type is one
  of lint, check, test, msrv, release. Reason: each job type
  compiles different artifacts, and sharing one key across them
  causes cache hits that still rebuild.
- Matrix legs are per target only, so no two legs write the same
  key.
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
- Set CARGO_INCREMENTAL=0 in the workflow env. Take every profile
  setting from the committed .cargo/config.toml alone.
- Leave RUSTFLAGS unset in the workflow. Reason: it replaces
  rustflags from .cargo/config.toml. Pass -D warnings to clippy
  after --.
- Take every linker setting from .cargo/config.toml. From Rust
  1.90, x86_64-unknown-linux-gnu links with rust-lld, which rustup
  ships. On a native Linux job whose triple has linker settings
  there, run sudo apt-get install -y clang lld before building.
- Install cargo-nextest, cargo-deny, cargo-hakari, and
  cargo-zigbuild with taiki-e/install-action, which installs
  prebuilt binaries instead of compiling them with cargo install.
- Every matrix sets fail-fast: true and max-parallel: 6.
</build_cost>

<decision_examples>
How hard rules 13 to 15 settle open points. The repository facts
are illustrative; take real ones from the repository.
<example>
Open point: .github/workflows/integration.yml runs tests against a
Postgres service container, and no job in this prompt covers them.
Evidence: its steps and its services block.
Choice: add an integration job to ci.yml (needs: gates;
pull_request and merge_group; timeout 20) with the same service,
SHA-pinned actions, and --locked; then git rm integration.yml,
since ci.yml now does its work.
Undo: git restore integration.yml and delete the job.
</example>
<example>
Open point: .github/workflows/docs.yml deploys documentation on
push to main and on workflow_dispatch.
Evidence: it deploys rather than checks, and it needs
workflow_dispatch, which ci.yml leaves out by hard rule 2.
Choice: keep docs.yml as it is; ci.yml covers CI only. List SHA
pinning for docs.yml under possible improvements.
Undo: nothing to undo.
</example>
<example>
Open point: the default branch is master, and this prompt says
main.
Evidence: git ls-remote --symref origin HEAD prints
ref: refs/heads/master.
Choice: use master wherever this prompt says main, including the
save-if condition.
Undo: replace master with main in ci.yml.
</example>
</decision_examples>

<verification>
If you have a shell:
1. Run actionlint on ci.yml and fix every finding.
2. Confirm by search: no schedule or workflow_dispatch trigger in
   ci.yml, every job has timeout-minutes, every third-party action
   is pinned to a full SHA, no RUSTFLAGS, and every cargo command
   has --locked.
3. Confirm that no two matrix legs can write the same rust-cache
   shared-key.
4. Confirm by listing .github/workflows/ before and after that
   every removed workflow's work now runs in ci.yml.
5. Delete any temporary files you created for these checks.
6. Report the actual output of each check.
If you have no shell, state that the file is unvalidated. Report a
check as passed only after running it. When a check fails, fix
ci.yml and keep the check as written.
</verification>

<not_included>
Add only the jobs above. Leave out miri, fuzzing, benchmarks,
coverage, scheduled or nightly checks, tests for zigbuild targets,
release dry runs in the merge queue, Dependabot, Renovate, or other
update-bot config, manual version bumps, external release tools,
and a workflow dependency lockfile. This list limits what you add;
under hard rule 14, existing items it names stay.
</not_included>

<deliverables>
Done when the repository matches this prompt and the verification
results are reported. Keep working until then, making each
judgment call under hard rule 13. Then stop and report. Produce
these in this order:
1. The complete ci.yml with brief comments. Its only unfilled
   values are BLOCKED: comments under hard rule 16.
2. Each shared config file from <shared_config_files> that you
   created or changed.
3. A table: job | trigger event | components and targets covered |
   expected runtime | what it catches.
4. A table of events (pull_request, merge_group, push to main with
   docs-only, push to main with code), each marked skip, check
   only, test, cache warm, or release.
5. The list of targets that are built but not tested.
6. Two sentences on how to cut a release: merge a feat or fix
   commit to main.
7. One sentence confirming the one-time hakari setup
   (cargo hakari init, manage-deps, generate) is committed
   before this workflow is enabled.
8. Decisions: a table of open point | evidence | choice | how to
   undo. Include every existing workflow, job, or setting you
   kept, reshaped, moved, or folded into ci.yml.
9. Blocked: each BLOCKED: value and where to find it, or "none".
10. The suggested commit message and the path of every backup
    made under hard rule 15.
11. Possible improvements beyond this prompt, one line each.
</deliverables>
```

## Usage

Paste the prompt into a Claude session opened in the Rust repository, new or existing.
A shell lets the session run actionlint and the verification checks.
Commit the one-time cargo-hakari setup before enabling the workflow.
Run rust-local-check-script in the same repository to keep both in parity.
Re-run the log's claims before reuse if last_verified is over 90 days old.

## Provenance

[Research log](../research/rust-ci-github-actions-log.md)
