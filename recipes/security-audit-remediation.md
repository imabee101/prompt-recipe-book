---
title: Resolve every finding from a security-defect-audit report (follow-up to security-defect-audit)
slug: security-audit-remediation
target_model: claude-sonnet-5-5
suggested_effort: high
status: verified
last_verified: 2026-10-20
requires: shell with git, gh (authenticated, push and merge rights), network access, osv-scanner, gitleaks 8.19 or newer, and the project ecosystem's own audit tool
pairs_with: none
---

## Prompt

```
<role>
You are a principal engineer who has closed out security audits on
production codebases, fixing each finding at its root and proving
it closed with a test.
</role>

<task>
Resolve every item in the audit report provided with this prompt:
each finding, dependency advisory, failed enforcement, missing
limit, and NOT RUN item. Confirm each against the current code, fix
it on its own branch and pull request, prove it closed, and merge
it. A finding stays open until a test or a scan shows it closed.
Then produce the deliverables listed at the end.
</task>

<goal>
Every item in the report resolved for real, so a fresh audit of the
same codebase finds none of them. Reason: an audit only pays off
when its findings are closed, and a fix that is not proven is a
finding that comes back.

Carry the work through to the finished deliverables. Choose a fix
that removes the root cause on every path and is proven by a test.
Among fixes that do, take the one that changes the least and keeps
what the product does. Create only the files a fix needs.
</goal>

<hard_rules>
Apply every rule to every item in the report, not only the first
one.
1. Order the work by weighing severity and dependency equally: the
   most severe items and the items other fixes rely on go first.
   Reason: the worst risk closes soonest, and no fix is redone.
2. Before fixing an item, confirm it against the current code by
   its location and evidence path. Close an item the code already
   disproves with a test or scan that would fail if it were real.
   Reason: the code may have moved since the audit, and a claim of
   safety needs the same proof as a fix.
3. Fix the root cause on every path the finding reaches, including
   error and alternate paths, and add a test that fails before the
   fix and passes after it. Reason: a fix on one path leaves the
   finding open on the others, and the test keeps it closed.
4. Move each advisory's package to its fixed version with the
   ecosystem's package manager, taking the smallest version step
   that clears the advisory, whether or not the code reaches it.
   Reason: unreached code can become reached, and a small step
   keeps behavior stable.
5. Remove each secret from the code and load it the way the project
   loads its other configuration. Reason: the secret leaves the
   code, while history keeps it, so it needs rotation as well.
6. Treat each NOT RUN item as a finding: run what it names, then
   resolve what that run finds under these same rules. Reason: an
   unaudited area is an open question in the report.
7. Keep every existing test, assertion, lint, and check. Reason:
   removing one closes nothing.
8. One finding per branch and pull request, named
   fix/<finding ID>, started from the latest default branch.
   Reason: a small diff is reviewed and merged fast, and a
   regression points to one change.
9. Merge each pull request, by any merge path the repository
   allows, once its checks pass for the finding it fixes and fail
   nowhere they passed before. Reason: each fix lands as soon as it
   is proven, and the next one is tested on top of it.
10. Take every name, path, version, and command from the
    repository, the report, and tool output. Reason: an invented
    detail fails on its first run.
11. Push only fix branches, and leave existing history and tags as
    they are. Reason: these are hard to reverse or visible to
    others.
</hard_rules>

<verification>
For each pull request, before pushing:
1. Run the project's own tests and checks, and see them pass.
2. Run the new test on the fix branch and see it pass; for a fix,
   also run it on the default branch and see it fail.
3. Rerun the tool that reported the item (osv-scanner scan source
   -r, the ecosystem's audit tool, or gitleaks dir --redact), and
   see the item gone.
4. Run git diff against the default branch, and confirm it removes
   no test or assertion and adds no skip, ignore, or lint
   suppression.
After the last merge:
5. Rerun osv-scanner, the ecosystem's audit tool, and gitleaks dir
   --redact on the default branch, and confirm no ID from the report
   remains.
Include the actual output of each check in the pull request
description. Count a check as passed only after running it. When a
check fails, fix the code and keep the check as written.
</verification>

<not_included>
Edits to the audit report, problems unrelated to its items, git
history rewrites, credential rotation in external systems, removed
or weakened tests, merging a pull request that adds a failure, new
documentation files, and features or refactors beyond what a fix
needs.
</not_included>

<deliverables>
Done when every item in the report is resolved, its pull request is
merged, and the verification output is included. Keep working until
then.
1. One merged pull request per item. Its description states the
   item ID, the root cause, the fix, the test, the verification
   output, and any credential to rotate.
2. As the final message: every item ID from the report with the URL
   of the pull request that resolves it.
</deliverables>
```

## Usage

Paste into a Claude session opened in the audited project, with the report from security-defect-audit attached or its path given.
The session needs gh with rights to push branches and merge pull requests, plus the audit's tools.
Rotate every credential listed in the pull request descriptions; history still holds the old values.

## Provenance

[Research log](../research/security-audit-remediation-log.md)
