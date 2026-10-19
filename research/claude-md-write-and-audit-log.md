# Research log: claude-md-write-and-audit

Recipe: ../recipes/claude-md-write-and-audit.md
Checked: 2026-10-18 (re-audited 2026-10-18 against [A1]-[A4])
Tiers: T1 = official or primary, T2 = secondary, T0 = from memory.

## Requirements

1. Write a prompt, in the same manner as the earlier recipes, about how to
   make and maintain a CLAUDE.md according to Anthropic's guidelines and
   specifications.
2. Research it the same way: read the official documentation in full, log
   each claim, and cite sources.
3. The prompt must work for both creating a new file and auditing an
   existing one.
4. 2026-10-19: Keep every specification as written. Remove wording that
   invites questions so the session acts; it creates no files beyond those
   the prompt names, keeps existing project features, fits the work to the
   project, and picks the least disruptive option within the constraints.
   Make the role read as more senior through experience.

## Findings

| Claim | Verdict | Source | Tier | Prompt change |
| --- | --- | --- | --- | --- |
| Splitting a CLAUDE.md with @imports shrinks context | Corrected: imported files still load at launch | [C1] | T1 | Hard rule 7 |
| XML tags help structure a CLAUDE.md | Not documented: the docs recommend markdown headers and bullets | [C1] | T1 | Hard rule 3 |
| CLAUDE.md enforces behavior | Corrected: it is advisory context; hooks and permissions enforce | [C1] [C3] | T1 | Hard rule 6 |
| Include architecture and directory overviews | Corrected: derivable content is cut by /doctor | [C1] [C2] | T1 | content_rules |
| Keep every useful line | Corrected: keep only lines whose removal would cause mistakes | [C2] | T1 | Hard rule 2 |
| Emphasize many rules | Corrected: emphasize only a skipped line | [C2] | T1 | Hard rule 8 |
| Procedures belong in CLAUDE.md | Corrected: skills load on demand | [C3] | T1 | routing section |
| HTML comments cost context | Corrected: block-level comments are stripped | [C1] | T1 | Hard rule 9 |
| Edits apply immediately | Corrected: root and user files apply after /clear, /compact, or restart | [C6] | T1 | spec section, deliverable 6 |
| Target size | Under 200 lines per file; files over 4 MiB are skipped | [C1] | T1 | Hard rule 1 |
| Maintenance triggers | Confirmed: repeated mistakes, review findings, retyped corrections; review in pull requests; revisit after model releases | [C1] [C5] [C3] | T1 | maintenance section |
| Debugging aids | /context, /memory, /doctor (v2.1.206 or later), safe mode | [C1] [C4] | T1 | spec and verification sections |
| Models stop early or add unrequested extras | Confirmed | [A2] | T1 | not_included and "Done when" |
| A vague-term grep finds weak instructions | Corrected: "properly" and "clean code" are the docs' own examples of vague or self-evident lines; the other terms are only a search aid, so each hit is now judged against hard rule 4 | [C1] [C2] | T1 | verification step 3 judges hits instead of rewriting all |
| Rewrite an existing file in place; git keeps the old version | Corrected: git restores only tracked, committed content; uncommitted edits would be lost. /init suggests improvements instead of overwriting | [S7] [C1] | T1 | task section asks before rewriting an uncommitted file; hard rule 12 |
| Claude Code reads CLAUDE.md, not AGENTS.md | Corrected: v2.1.277 or later reads AGENTS.md when no CLAUDE.md or CLAUDE.local.md exists; with both, CLAUDE.md only by default | [C1] | T1 | spec AGENTS.md line |
| /doctor trims derivable content (v2.1.206 or later) | Partly confirmed: the trim behavior is documented; the version number is on no current page and was removed. /doctor prompt-audit (v2.1.283 or later) audits instruction files | [C1] [C4] [C7] | T1 | spec debugging line |
| Edits to root and user CLAUDE.md apply after /clear, /compact, or restart | Confirmed | [C6] | T1 | none |
| /context lists CLAUDE.md under Memory files; claude --safe-mode disables customizations | Confirmed | [C1] [C4] | T1 | none |
| Prompt audit against [A1] [A2] [A3] [A4] | Corrected: missing rule reasons, examples, tag order, stop-and-report wording, and confirmation rules failed checklist items | [A1] [A2] [A3] [A4] | T1 | See research/prompt-audit-2026-10-18.md |
| Sonnet 5.5 can stop to check in before work is done; the fix is a keep-working instruction | Confirmed | [A2] | T1 | Ask clause removed from deliverables; ask-before rules restated as the same limits without asking |
| Explaining the intent behind instructions helps Claude apply them to unnamed cases | Confirmed | [A1] | T1 | Goal adds one paragraph: finish the deliverables, fit the work to what exists, least disruptive option |
| A one-sentence role focuses behavior and tone | Confirmed | [A1] | T1 | Role conveys seniority through experience |

## Known gaps

T0, from memory and not searched: none. The two T0 rows were re-verified
on 2026-10-18 (see Findings).

Sources with limits:

- Managed-policy file locations were read but not tested on a machine.
- Version-gated items (AGENTS.md reading needs v2.1.277 or later;
  /doctor prompt-audit needs v2.1.283 or later) need rechecking when
  Claude Code changes.
- CLAUDE_CODE_NEW_INIT behavior may change.
- The Claude blog post on steering Claude Code was not read.

Known issue found by this recipe:

- An earlier draft of this repo's CLAUDE.md was about 330 lines, used XML
  tags, and suggested imports to shrink it. It broke hard rules 1, 3, and
  7. The current CLAUDE.md fixes all three and moves the method into the
  new-recipe skill.
