# Prompt Recipe Book

This repo stores recipes (complete prompts for Claude) and the research
behind each one. Research comes first, writing second.

## Commands

- Check every recipe: `scripts/check-recipes.sh` (prints nothing and exits 0
  when clean; prints each problem and exits 1 otherwise).
- Check this file's size: `wc -l CLAUDE.md` (must stay at 200 or fewer).
- Check one recipe's prompt rules (replace `<slug>`):
  - Negative phrasing, to rewrite or move: `grep -niE '\b(do not|don.t|never|avoid)\b' recipes/<slug>.md`
  - Numbered hard rules: `awk '/^<hard_rules>/{on=1;next} /^<\/hard_rules>/{on=0} on' recipes/<slug>.md | grep -cE '^[0-9]+\. '`
  - Reasons in hard_rules (must equal the rule count): the same `awk` command ending in `grep -c 'Reason'`
  - Examples: `grep -c '^<example>' recipes/<slug>.md`

## Layout

- `recipes/<slug>.md`: one prompt per file.
- `research/<slug>-log.md`: the findings log for that recipe. The `-log`
  suffix is required so a recipe and its log have different names.
- `templates/`: blank recipe and blank log. Copy them to start a new file.
- `sources.md`: master source list. Source IDs like [A1] and [R3] are
  defined only there.
- `.claude/skills/new-recipe/SKILL.md`: the research and writing method.
  Invoke it for every new or changed recipe.

## Recipe format

- Front matter keys: title, slug, target_model, suggested_effort, status
  (draft, verified, or stale), last_verified (YYYY-MM-DD), requires,
  pairs_with.
- Body: `## Prompt` with exactly one fenced code block, then `## Usage`
  (five lines at most), then `## Provenance` linking the log.
- The prompt inside the block uses XML tags (role, task, goal, hard_rules,
  verification, not_included, deliverables) and contains no triple
  backticks. Everything outside the block is plain markdown.

## Prompt rules (apply to every recipe prompt)

These come from Anthropic's prompting guidance ([A1], [A2], [A3]). Apply
each rule to every recipe, not only the one you are editing.

- State what to do. Rewrite each "do not X" as a positive instruction, or
  move it to `<not_included>`. Positive instructions work better than
  prohibitions [A3].
- Give every numbered rule its reason, inside the rule [A1].
- Open `<hard_rules>` with a scope sentence: "Apply every rule to every
  <unit>, not only the first one." Current models follow instructions
  literally [A3].
- Open `<deliverables>` with a stopping condition: "Done when ..." [A2].
- Add a `<verification>` section to any recipe that produces code or
  config. It requires running real checks and reporting actual output [A2].
- Use 3 to 5 `<example>` blocks when the output format is the main risk
  [A1].
- Write tasks as direct instructions ("Write X"). Skip capitalized
  emphasis. Ask for a short summary instead of written-out reasoning
  [A1] [A2].
- Make every recipe act without questions. The goal says that running
  the prompt approves it, for a new or an existing project. Hard rules
  settle open points in a fixed order (prompt, rule reasons, project
  evidence, tool default, easiest to undo), keep existing behavior by
  reshaping it, and keep changes recoverable instead of asking first.
  Deliverables end with a Decisions table [A1] [A2].
- Include only what the requirements state. List extras you considered in
  the closing note and let the user decide [A2].
- Call a recipe compliant only after the prompt-rule checks under Commands
  and `scripts/check-recipes.sh` ran clean.

## Research rules

- Log a row in the research log for every claim about how a tool,
  platform, or standard behaves: claim, verdict, source ID, tier, prompt
  change. Tiers: T1 official, T2 secondary, T0 from memory.
- List every T0 claim under "Known gaps" in the log, and state a T0 claim
  only as unverified.
- Fetch primary pages in full. Search snippets are not enough for a rule.
- Cite by source ID. Paraphrase sources. Quote at most one phrase of under
  15 words per source.
- `rust-ci-github-actions` and `rust-local-check-script` are paired. They
  must have the same stages, flags, regexes, and version minimums. After
  editing one, compare the other and fix both.
- Set `status: stale` when the target model or a tool's major version
  changes. Before reusing a recipe last verified more than 90 days ago,
  re-run its research log's claims (repo policy).

## Workflow

- New or changed recipe: invoke the `new-recipe` skill and follow it.
- After any recipe change, run `scripts/check-recipes.sh` and the
  prompt-rule checks, and report their actual output.
- Deliver full prompts, not deltas, unless the user asks for a delta.
- When handing a recipe to a user in chat: findings first (each with its
  source), then the complete prompt in one fenced block, then a closing
  note of two or three sentences.
- Ask before deleting recipes or logs, rewriting git history, or
  force-pushing.
- Remove temporary files you create before finishing.

## Gotchas

- The script counts code fences in each recipe, so a stray triple backtick
  inside a prompt fails the check.
- Recipes target `claude-sonnet-5-5` unless the front matter says
  otherwise. Model-specific guidance does not transfer to other models.
- Source pages for GitHub skip behavior were Enterprise Server versions.
  Recheck the github.com page before relying on them.

## Done means

- `scripts/check-recipes.sh` is clean, the prompt-rule checks are clean,
  every claim has a log row, and the paired recipe was compared. Then stop
  and report. Mention possible improvements at the end instead of making
  them.

<!--
Maintainer notes (stripped before Claude reads this file):
- Add a line when Claude repeats a mistake, a review catches something
  Claude should have known, or you retype the same correction.
- Remove a line when Claude behaves correctly without it, or when the
  script or path it names no longer exists.
- Procedures belong in the new-recipe skill, not here. Path-specific rules
  can go in .claude/rules/ with paths frontmatter.
- Imports leave context size unchanged; imported files still load at launch.
- Edits to this file reach a running session only after /clear, /compact,
  or a restart.
- Keep this file at 200 lines or fewer. Review changes in pull requests.
-->
