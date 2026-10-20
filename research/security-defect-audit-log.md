# Research log: security-defect-audit

Recipe: ../recipes/security-defect-audit.md
Checked: 2026-10-20
Tiers: T1 = official or primary, T2 = secondary, T0 = from memory.

## Requirements

1. A prompt that audits an ongoing project for security bugs and
   defects, deep and thorough.
2. The report lives outside the repository and outside every worktree.
3. Find vulnerabilities, advisories (CVEs) relevant to the project's
   code, unprofessional work, and anything short of production grade.
4. Check that limits exist where they should, and that the project
   enforces what it says it enforces.
5. Follow the conventions and guidance of the other recipes: no wording
   that invites questions or stopping, direct, minimal, transferable to
   any project, and not a word-for-word copy of the request.
6. Carry over the nuance of the other recipes, not only the skill's
   structure.
7. Review fixes: run builds and tests on a copy of the tree, since
   gitignored output escapes git status; report any check that could
   not run as NOT RUN; name a secrets tool for git history; note that
   this is the security instance of a five-domain set; anchor severity.

## Findings

| Claim | Verdict | Source | Tier | Prompt change |
| --- | --- | --- | --- | --- |
| osv-scanner scan source -r scans a directory tree's lockfiles, SBOMs, and git directories against OSV | Confirmed | [V1] | T1 | Hard rule 5 names the command |
| An ecosystem audit tool can write into the project: cargo audit generates Cargo.lock when it is missing | Confirmed | [V2] | T1 | Hard rule 1 runs tools from the audit directory with the project or lockfile path |
| Reachability changes an advisory's relevance: govulncheck reports only vulnerabilities in called functions | Confirmed | [V3] | T1 | Hard rule 4 and the reached column in the dependency table |
| Claude should read code before making claims about it | Confirmed | [A1] | T1 | Hard rule 2 grounds every finding in code that was opened |
| Research prompts work best with clear success criteria and verification across sources | Confirmed | [A1] | T1 | goal defines a finished report; hard rule 3 confirms each finding; verification 3 cross-checks tool output against the report |
| Use search to check specifics that may have changed since training | Confirmed | [A2] | T1 | Hard rule 5 takes advisory data from tools run today |
| Sonnet 5.5's cyber classifier allows finding vulnerabilities in source code and declines high-risk dual-use work | Confirmed | [A2] | T1 | Findings are confirmed by tracing or a test against a local build; tests against anything else are in not_included |
| Sonnet 5.5 can stop to check in before work is done; a keep-working instruction helps | Confirmed | [A2] | T1 | Deliverables open with "Done when" and "Keep working until then" |
| Explaining the reason for each rule helps Claude apply it to unnamed cases | Confirmed | [A1] | T1 | Every hard rule carries its reason |
| Examples steer output format; use 3 to 5 when format is the main risk | Confirmed | [A1] | T1 | Three examples in output_format |
| Models report work as done without running a check | Confirmed | [A2] | T1 | verification requires the actual output of each check |
| Repo convention: a default stance in the role sets the bias of the whole run | Applied from slim-global-instruction-files (every line unnecessary until proven) | none (repo convention) | n/a | Role treats every input as hostile until the code proves otherwise |
| Repo convention: a first pass is biased, so run an adversarial second pass | Applied from slim-global-instruction-files rule 6 | none (repo convention) | n/a | Hard rule 9; Coverage records the second pass |
| Repo convention: a green result proves only what it ran | Applied from rust-ci-green | none (repo convention) | n/a | Task: a passing test suite proves only what it tests |
| Repo convention: when a check fails, fix the work and keep the check | Applied from rust-ci-github-actions and rust-local-check-script | none (repo convention) | n/a | verification closing line |
| git status --porcelain proves the tree is untouched | Corrected: builds and tests write gitignored files that it does not list | none (review finding) | n/a | Hard rule 1 runs builds and tests in a copy of the working tree under ~/audits/ |
| gitleaks scans history with gitleaks git and files with gitleaks dir; --redact hides secret values; --report-path sets the output file | Confirmed | [V4] | T1 | Hard rule 5 names both commands with --redact and --report-path outside the repository; requires names gitleaks 8.19 or newer |
| A check that could not run needs an explicit status | Review finding: without it a gap can read as a pass | none (review finding) | n/a | Hard rule 9 marks NOT RUN and counts its scope as unaudited; Coverage lists NOT RUN items |
| Severity needs anchors so two auditors grade alike | Review finding | none (review finding) | n/a | output_format defines critical, high, medium, and low |
| Audit against the other recipes | Six fixes: Done when allows NOT RUN items; tools are installed before NOT RUN applies; licenses judged against the project's own; gitleaks findings cross-checked; production grade points at scope; one example in another language | none (repo conventions) | n/a | Task, hard rule 5, scope, examples, verification 3, deliverables |

## Known gaps

T0, from memory and not searched: none.

Sources with limits:

- [V1], [V2], and [V3] were read from the projects' sources on GitHub;
  their documentation hosts were not reachable from this environment.
- The ecosystem audit tool is left to the session, since the recipe is
  language-neutral; only osv-scanner is named.
