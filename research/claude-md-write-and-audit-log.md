# Research log: claude-md-write-and-audit

Recipe: ../recipes/claude-md-write-and-audit.md
Checked: 2026-10-18
Tiers: T1 = official or primary, T2 = secondary, T0 = from memory.

## Requirements

1. Write a prompt, in the same manner as the earlier recipes, about how to
   make and maintain a CLAUDE.md according to Anthropic's guidelines and
   specifications.
2. Research it the same way: read the official documentation in full, log
   each claim, and cite sources.
3. The prompt must work for both creating a new file and auditing an
   existing one.

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
| A vague-term grep finds weak instructions | Own heuristic | none | T0 | verification step 3 |
| Rewrite an existing file in place | Design choice; git keeps the old version. /init suggests improvements instead of overwriting | [C1] | T1 and T0 | task section |

## Known gaps

T0, from memory and not searched:

- The vague-term grep list in verification step 3.
- Rewriting in place as the default for audit mode.

Sources with limits:

- Managed-policy file locations were read but not tested on a machine.
- Version-gated items (the /doctor trim check needs v2.1.206 or later) need
  rechecking when Claude Code changes.
- CLAUDE_CODE_NEW_INIT behavior may change.
- The Claude blog post on steering Claude Code was not read.

Known issue found by this recipe:

- An earlier draft of this repo's CLAUDE.md was about 330 lines, used XML
  tags, and suggested imports to shrink it. It broke hard rules 1, 3, and
  7. The current CLAUDE.md fixes all three and moves the method into the
  new-recipe skill.
