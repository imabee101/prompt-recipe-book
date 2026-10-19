# Research log: claude-md-write-and-audit

Recipe: ../recipes/claude-md-write-and-audit.md
Checked: 2026-10-19 (revised for authority and decision rules); first checked 2026-10-18 (re-audited 2026-10-18 against [A1]-[A4])
Tiers: T1 = official or primary, T2 = secondary, T0 = from memory.

## Requirements

1. Write a prompt, in the same manner as the earlier recipes, about how to
   make and maintain a CLAUDE.md according to Anthropic's guidelines and
   specifications.
2. Research it the same way: read the official documentation in full, log
   each claim, and cite sources.
3. The prompt must work for both creating a new file and auditing an
   existing one.
4. 2026-10-19: "if I'm pasting this prompt, it's because I've read the
   prompt and that the prompt is authoritative and the new reality that
   the project should be held by." It acts without asking questions or
   handing decisions back ("this decision, it's on you").
5. 2026-10-19: "I don't want it to skip things either."
6. 2026-10-19: "It should make the least destructive action to the
   repository to make the new reality."
7. 2026-10-19: when making a choice, "pick something to do that follows
   the intent of the project while prioritizing the prompt."
8. 2026-10-19: the prompt may run "in a new project or making a new
   project comply."
9. 2026-10-19: in an existing repository, "I don't want it to suddenly
   start undoing a product or a feature." Reshape what is needed to make
   it production oriented, "not undo something that was done for a
   purpose."
10. 2026-10-19: make "the role inside of the prompt slightly more
   authoritative," and apply Anthropic's prompting best practices.

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
| Claude can be told to act by default: implement rather than suggest, and when intent is unclear infer the most useful action and proceed | Confirmed | [A1] | T1 | Authority paragraph in goal; hard rule 12 decides open points from a fixed source order |
| Explaining why an instruction matters helps Claude generalize to cases the instruction does not name | Confirmed | [A1] | T1 | Authority stated with its reason; hard rule 12 uses each rule's Reason to settle unnamed cases |
| Sonnet 5.5 can stop to check in before work is done; a keep-working instruction helps but does not replace rules on risky actions | Confirmed | [A2] | T1 | Deliverables say keep working with no ask clause; risky actions handled by hard rule 14 |
| Anthropic's sample safety prompt asks before destructive or shared actions | Confirmed, then replaced by user requirement: running the prompt is the approval, so changes stay recoverable (backups, git) instead of asked about | [A1] | T1 | Hard rule 14 replaces the ask-before rule |
| A one-sentence role focuses behavior and tone | Confirmed. The prompt relies on hard rule 12, not the role, to stop questions | [A1] | T1 | Role names ownership of every judgment call |
| Positive instructions work better than prohibitions | Confirmed | [A1] [A3] | T1 | Instruction-style negatives rewritten as positive rules or moved to not_included |
| A few diverse examples steer behavior better than rules alone | Confirmed | [A1] | T1 | decision_examples with three open-point examples |
| git restores tracked paths from a commit, so uncommitted or untracked content has no git copy | Confirmed | [S7] | T1 | Hard rule 14: back up such files before changing them |

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
