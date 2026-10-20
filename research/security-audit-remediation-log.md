# Research log: security-audit-remediation

Recipe: ../recipes/security-audit-remediation.md
Checked: 2026-10-20
Tiers: T1 = official or primary, T2 = secondary, T0 = from memory.

## Requirements

1. A follow-up to security-defect-audit. The audit's markdown report is
   provided with the prompt.
2. Address every item in the report.
3. Follow the conventions and nuance of the other recipes, not only the
   skill: no wording that invites questions or stopping, minimal,
   transferable to any project.
4. Some items are better done in a particular order, and dependencies
   between items can set that order.

## Findings

| Claim | Verdict | Source | Tier | Prompt change |
| --- | --- | --- | --- | --- |
| osv-scanner scan source -r rescans a directory tree's dependencies against OSV | Confirmed | [V1] | T1 | Verification 3 and 5 rerun it to show an advisory is gone |
| gitleaks dir scans files for secrets; --redact hides values | Confirmed | [V4] | T1 | Verification 3 and 5 rerun gitleaks dir --redact |
| Removing a secret from the code leaves it in git history | Confirmed: gitleaks git scans history because secrets persist there | [V4] | T1 | Hard rule 5 reason; each pull request lists the credential to rotate; history rewrites stay in not_included |
| Reachability changes an advisory's relevance today, not forever | Applied: govulncheck reports only called functions, and calls change as code changes | [V3] | T1 | Hard rule 4 upgrades reached and unreached advisories alike |
| Claude should read code before making claims about it | Confirmed | [A1] | T1 | Hard rule 2 confirms each item against the current code |
| Explaining the reason for each rule helps Claude apply it to unnamed cases | Confirmed | [A1] | T1 | Every hard rule carries its reason |
| Sonnet 5.5 can stop to check in before work is done; a keep-working instruction helps | Confirmed | [A2] | T1 | Deliverables open with "Done when" and "Keep working until then" |
| Models report code as done without running a check | Confirmed | [A2] | T1 | verification requires actual output in each pull request |
| Repo convention: a green result proves only what it ran | Applied from rust-ci-green | none (repo convention) | n/a | Task: an item stays open until a test or a scan shows it closed |
| Repo convention: merge by any path the repository allows once the fix is proven and nothing regresses | Applied from rust-ci-green hard rule 10 | none (repo convention) | n/a | Hard rule 9 |
| Repo convention: one change per branch and pull request, smallest change that keeps what the product does | Applied from rust-ci-green and the CI recipes | none (repo convention) | n/a | Hard rule 8 and goal |
| Repo convention: a NOT RUN item marks an unaudited area | Applied from security-defect-audit hard rule 9 | none (repo convention) | n/a | Hard rule 6 runs each NOT RUN item and resolves what it finds |
| Repo convention: dependency order goes before severity, so a fix lands on the change beneath it | Applied from rust-ci-green hard rule 5 (crates in dependency order) | none (repo convention; requirement 4) | n/a | Hard rule 1 orders by dependency between items, then severity |

## Known gaps

T0, from memory and not searched: none.

Sources with limits:

- [V1], [V3], and [V4] were read from the projects' sources on GitHub;
  their documentation hosts were not reachable from this environment.
- The ecosystem's package manager and audit tool are left to the
  session, since the recipe is language-neutral.
