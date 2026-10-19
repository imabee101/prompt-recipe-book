# Research log: slim-global-instruction-files

Recipe: ../recipes/slim-global-instruction-files.md
Checked: 2026-10-19 (stop-points revision); first checked 2026-10-18
Tiers: T1 = official or primary, T2 = secondary, T0 = unverified.

## Requirements

1. "add this prompt to the library."
2. "target_model: claude-sonnet-5-5"
3. Preserve the supplied role, task, goal, twelve hard rules, locations,
   four examples, verification, exclusions, and six deliverables.
4. Store the prompt in imabee101/prompt-recipe-book using its recipe format.

Success criteria: the complete supplied prompt is a single copyable fenced
block, metadata names the requested model, README links the recipe, this
log records claims and gaps, and the repository check runs successfully.
This request stores a prompt; it does not execute the embedded machine audit.
5. 2026-10-19: Running a pasted prompt means the user has read and
   approved it. The executing session makes the small, operational
   decisions itself instead of asking or handing them back.
6. 2026-10-19: That latitude is operational only. The hard rules, scope,
   and exclusions stay fixed, and judgment never reopens them.
7. 2026-10-19: In an existing project, work around what is already there
   and keep existing features intact; choose the least destructive option.
8. 2026-10-19: Prefer removing constraints that block
   operational choices over adding a grant of authority; follow
   Anthropic's prompting guidance. Two earlier revisions (a broad
   authority grant, then a separate operational-calls section) were
   reverted at the user's request.

## Findings

| Claim | Verdict | Source | Tier | Prompt change |
| --- | --- | --- | --- | --- |
| Codex global scope defaults to ~/.codex and CODEX_HOME can relocate it. | Confirmed | [O1] | T1 | None. |
| Codex chooses AGENTS.override.md before AGENTS.md. | Confirmed with limit | [O1] | T1 | Preserved supplied wording; docs specify first non-empty file, not mere existence. |
| A Codex prompt can request loaded instruction sources. | Confirmed as documented diagnostic, not independent attestation | [O1] | T1 | None; runtime verification remains necessary. |
| Global instructions affect sessions across repositories and consume context. | Confirmed in scope for Codex; conditional for other clients | [O1] | T1 | None; the executing session must establish actual loading. |
| Claude uses ~/.claude/CLAUDE.md and user rules. | Unverified in this review | [C1] attempted | T0 | Preserved as supplied discovery candidates; not certified. |
| /context confirms Claude's loaded instruction files. | Unverified in this review | [C4] existing pointer, not rechecked | T0 | Preserved; runtime check required. |
| claude -p starts a fresh non-interactive session. | Unverified in this review | none | T0 | Preserved; CLI help and runtime must confirm. |
| codex exec starts a fresh non-interactive session. | Unverified in this review | none | T0 | Preserved; CLI help and runtime must confirm. |
| Grok uses ~/.grok/GROK.md, ~/.grok/AGENTS.md, or ~/.grok/rules/. | Unverified; client unspecified | none | T0 | Preserved as candidates, with tool-reported loading taking priority. |
| Grok reads CLAUDE.md for compatibility. | Unverified; client unspecified | none | T0 | Preserved; rule 10 explicitly requires checking actual loading. |
| A Grok non-interactive equivalent and loaded-files diagnostic exist. | Unverified; client unspecified | none | T0 | Preserved; missing sessions must be marked untested. |
| A backup outside configuration cannot be loaded by a tool. | Unverified universal assertion | none | T0 | Preserved; imports, symlinks, or client-specific discovery could invalidate this. |
| A backup makes every wrong cut cheap and permits a one-command restore. | Unverified environmental assumption | none | T0 | Preserved; permissions, symlinks, and backup collisions require runtime care. |
| Agents over-keep instructions, bloat degrades results, and duplicate lines double cost. | Unverified generalizations; user rationale | none | T0 | Preserved as supplied policy rationale, not measured findings. |
| All four example decisions satisfy or fail the five-part test as stated. | Unverified behavioral assumptions | none | T0 | Preserved examples; actual defaults and user preferences can differ. |
| A single probe can establish the behavioral value of a removed category or line. | Unverified evaluation assumption | none | T0 | Preserved protocol; single samples do not establish causality or reliability. |
| Explicit scope, examples, reasons, and stopping conditions are appropriate prompt structures. | Confirmed in reviewed guidance | [A1], [A2] | T1 | Retained supplied XML structure and examples. |
| high effort is a reasonable initial setting for harder, longer agentic work. | Confirmed as starting guidance, not an evaluation of this recipe | [A2] | T1 | Set suggested_effort: high. |
| Sonnet 5.5 can stop to check in before work is done; a keep-working instruction helps but does not replace rules on risky actions | Confirmed | [A2] | T1 | Deliverables drop the ask clause and "stop and report"; they keep "Done when" and "Keep working until then"; the ask-before rule is unchanged |
| Claude can be told to act by default and infer the most useful action when intent is unclear | Confirmed | [A1] | T1 | No wording about decisions added; stop-and-report wording removed; the prompt says only when work is done and to keep working until then |
| A one-sentence role focuses behavior and tone | Confirmed | [A1] | T1 | Role conveys seniority through experience (principal or staff, years of work at scale), with no grant of authority |
| A prompt needs a fallback for missing values, missing tools, or checks that cannot run | Not required by any source; each fallback gave the model an exit before the work was done | none (requirement) | n/a | Fallback clauses removed: no UNRESOLVED or CONFLICT markers, no "if you have no shell", no "if you cannot run a check"; the requires line now lists the tools as needed |
| Telling a model when to ask, or describing a case that may not exist, prevents mistakes | Not required by any source; each such clause gave the model a reason to ask or stop | none (requirement) | n/a | Ask-before rules rewritten as plain constraints (leave history, tags, releases, and other files as they are); hypothetical cases removed (uncommitted CLAUDE.md, existing lockfile, older hakari, missing tool, no fresh session) |

## Known gaps

- All T0 rows above remain unverified. The recipe is draft, not verified.
- No agent CLI, machine-global file, backup, or behavioral probe was run:
  this task adds a recipe rather than executing it.
- The supplied text is preserved after decoding chat transport escapes
  (trailing backslashes, escaped punctuation, and the HTML space entity).
  Repository positive-phrasing rules were reviewed, but the supplied wording
  takes precedence; existing negative phrases are intentional exceptions.
- Verification item 2 asks for backup/original equality even after editing.
  Equality is meaningful before edits; after edits, a difference is expected.
  The prompt is retained without silently changing this requirement.
- "Three global files" in rule 11 can conflict with multiple Claude or Grok
  rule files listed under locations. The authorization boundary needs
  clarification at execution if more than three files exist.
- The quota exception "already shorter" does not specify whether it means
  shorter than 25 lines or shorter than the proposed halved size.
- An empty Codex override can cause fallback to AGENTS.md; discovery must
  account for this before edits.
- Rule 11 requests moving secrets into the report. A report can disclose a
  secret; the supplied instruction was retained, not exercised.
- No Grok client or version was named, so no universal Grok behavior was
  attributed to official documentation.
- Full-page review of [A1], [A2], and [C1] was not completed: fetched output
  exposed portions of the first two, the .md Claude memory URL failed, and
  the alternate URL was opened without reading all sections. [O1]'s
  relevant discovery and diagnostic sections were read. No claim of full
  model-guidance compliance is made.
- No paired recipe: pairs_with is none. The existing project CLAUDE.md audit
  recipe covers a different scope and was left unchanged.

## Validation

- bash scripts/check-recipes.sh: exit 0; stdout and stderr empty.
- Prompt checks: 12 numbered hard rules, 12 reasons, 4 examples.
- Negative-phrasing scan: supplied wording retained; intentional exception.
- Complete embedded prompt and target_model checked locally before commit.
