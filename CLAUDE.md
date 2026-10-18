# Prompt Recipe Book

This repo stores recipes (complete prompts for Claude) and the research
behind each one. Research comes first, writing second.

## Commands

- Check every recipe: `scripts/check-recipes.sh` (prints nothing and exits 0
  when clean; prints each problem and exits 1 otherwise).
- Check this file's size: `wc -l CLAUDE.md` (must stay at 200 or fewer).

## Layout

- `recipes/<slug>.md`: one prompt per file.
- `research/<slug>-log.md`: the findings log for that recipe. The `-log`
  suffix is required so a recipe and its log never share a name.
- `templates/`: blank recipe and blank log. Copy them; never edit in place.
- `sources.md`: master source list. Source IDs like [A1] and [R3] are
  defined only there.
- `.claude/skills/new-recipe/SKILL.md`: the research and writing method.
  Load it for every new or changed recipe.

## Recipe format

- Front matter keys: title, slug, target_model, suggested_effort, status
  (draft, verified, or stale), last_verified (YYYY-MM-DD), requires,
  pairs_with.
- Body: `## Prompt` with exactly one fenced code block, then `## Usage`
  (five lines at most), then `## Provenance` linking the log.
- The prompt inside the block uses XML tags (role, task, goal, hard_rules,
  verification, not_included, deliverables). It contains no triple
  backticks. Everything outside the block is plain markdown.
- Every recipe prompt ends with a stopping condition ("Done when ...").

## Rules for every change

- Apply each rule to every recipe, not only the one you are editing.
- Log a row in the research log for every claim about how a tool,
  platform, or standard behaves: claim, verdict, source ID, tier,
  prompt change. Tiers: T1 official, T2 secondary, T0 from memory.
- List every T0 claim under "Known gaps" in the log. Never state a T0
  claim as verified.
- Fetch primary pages in full. Search snippets are not enough for a rule.
- `rust-ci-github-actions` and `rust-local-check-script` are paired. They
  must have the same stages, flags, regexes, and version minimums. After
  editing one, compare the other and fix both.
- Cite by source ID. Paraphrase sources. Quote at most one phrase of
  under 15 words per source. Never copy paragraphs, tables, or code.
- Deliver full prompts, never deltas, unless the user asks for a delta.
- When handing a recipe to a user in chat: findings first (each with its
  source), then the complete prompt in one fenced block, then a closing
  note of two or three sentences.
- Set `status: stale` when the target model or a tool's major version
  changes. Before reusing a recipe last verified more than 90 days ago,
  re-run its research log's claims (repo policy).

## Workflow

- New or changed recipe: invoke the `new-recipe` skill and follow it.
- After any recipe change, run `scripts/check-recipes.sh` and report its
  actual output.
- Ask before deleting recipes or logs, rewriting git history, or
  force-pushing.
- Remove temporary files you create before finishing.

## Gotchas

- The recipe's code fence count is checked by script: a stray triple
  backtick inside a prompt breaks the check.
- Recipes target `claude-sonnet-5-5` unless the front matter says
  otherwise. Model-specific guidance does not transfer to other models.
- Source pages for GitHub skip behavior were Enterprise Server versions.
  Recheck the github.com page before relying on them.
- Edits to this file reach a running session only after `/clear`,
  `/compact`, or a restart.

## Done means

- `scripts/check-recipes.sh` is clean, every claim has a log row, and the
  paired recipe was compared. Then stop and report. Mention possible
  improvements at the end instead of making them.

<!--
Maintainer notes (stripped before Claude reads this file):
- Add a line when Claude repeats a mistake, a review catches something
  Claude should have known, or you retype the same correction.
- Remove a line when Claude behaves correctly without it, or when the
  script or path it names no longer exists.
- Procedures belong in the new-recipe skill, not here. Path-specific rules
  can go in .claude/rules/ with paths frontmatter.
- Imports do not shrink context; imported files still load at launch.
- Keep this file at 200 lines or fewer. Review changes in pull requests.
-->
