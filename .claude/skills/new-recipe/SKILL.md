---
name: new-recipe
description: Research and write a new prompt recipe, revise an existing one, re-verify a stale one, or compare paired recipes in this repo. Use whenever the user asks to write a prompt, build or update a recipe, check a prompt against Anthropic's guidance, or fact-check a prompt, even if they never say "recipe".
---

# New or changed recipe

Research first, write second. Every claim a recipe depends on is checked
against a source or labelled unverified. Follow these steps in order.

Read these two files before step 3:

- `references/research-method.md`: how to extract, research, and log claims.
- `references/prompt-writing-rules.md`: the prompt skeleton and writing
  rules, with the Anthropic source for each rule.

## Steps

1. Capture requirements. Number every constraint the user states, in
   their words. Each later correction adds or replaces an item. Write
   success criteria: what a correct deliverable does and how a reviewer
   checks it.
2. Read the model guidance in full with the fetch tool: [A1] and the page
   for the recipe's target model ([A2] for claude-sonnet-5-5). Search
   snippets are not enough.
3. Draft v0 from the skeleton in `references/prompt-writing-rules.md`.
4. Extract claims: every sentence in v0 that asserts how a tool,
   platform, or standard behaves. Sort each as correctness, efficiency,
   or professionalism.
5. Research each claim using `references/research-method.md`. Stop when
   every claim has a verdict: confirmed, corrected, or unverified.
6. Log one row per claim in `research/<slug>-log.md`. Copy
   `templates/research-log.md`. Add each source to `sources.md` first.
7. Revise v0. Apply every finding and every writing rule. Cut anything
   the requirements do not need. Remove ambiguity: pick one default, give
   numbers and exact commands, close every list.
8. Parity pass. Compare with the recipe named in `pairs_with`. List
   mismatches in stages, flags, regexes, config files, and version
   minimums. Fix both recipes and log the change.
9. Write `recipes/<slug>.md` from `templates/recipe.md`. Set status to
   draft while any T0 claim remains.
10. Run `scripts/check-recipes.sh` and report its actual output. If it
    prints anything, fix the problem and run it again.

## Reporting to the user

1. Findings first: a short list of what the research changed, each with
   its source.
2. The complete prompt in one fenced block. Always full prompts, never
   deltas, unless the user asks for a delta.
3. A closing note of two or three sentences: choices you made for the
   user, and trade-offs.

## Done means

The check script is clean, every claim has a log row, every T0 claim is
under "Known gaps", and the paired recipe was compared. Then stop and
report. Mention possible improvements at the end instead of making them.
