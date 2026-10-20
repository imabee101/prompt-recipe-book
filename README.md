# Prompt Recipe Book

Complete, researched prompts for Claude, plus the research behind each one.
Open a recipe, copy the fenced prompt block, and paste it into a Claude
session that has the tools the recipe lists under `requires`.

## Recipes

| Recipe | What it produces | Status |
| --- | --- | --- |
| [rust-ci-github-actions](recipes/rust-ci-github-actions.md) | One event-driven GitHub Actions workflow for a Rust workspace | draft |
| [rust-local-check-script](recipes/rust-local-check-script.md) | A local fast, gate, and build script for the same workspace | draft |
| [rust-ci-green](recipes/rust-ci-green.md) | Follow-up to the CI recipe: every failing job fixed on genuine tests, one merged pull request per component | verified |
| [slim-global-instruction-files](recipes/slim-global-instruction-files.md) | A backed-up, behavior-tested trim of global Claude Code, Codex, and Grok instructions | draft |
| [security-defect-audit](recipes/security-defect-audit.md) | A deep security and defect audit report, written outside the repository | verified |
| [claude-md-write-and-audit](recipes/claude-md-write-and-audit.md) | A new or audited CLAUDE.md that follows Anthropic's documentation | verified |

The two Rust recipes are paired: same stages, flags, regexes, and version
minimums, so a green local gate predicts a green CI run. They stay draft
until the unverified claims in their logs are checked.

## Folders

- `recipes/`: one prompt per file.
- `research/`: one findings log per recipe (`<slug>-log.md`).
- `templates/`: blank recipe and blank log.
- `sources.md`: every source, with an ID and a tier.
- `.claude/skills/new-recipe/`: the research and writing method.
- `scripts/check-recipes.sh`: validates the whole repo.

## Working in this repo

Open it in Claude Code. `CLAUDE.md` loads automatically. To add or change a
recipe, ask Claude to write one; the `new-recipe` skill runs the research
method. Run `scripts/check-recipes.sh` after every change. It prints nothing
when the repo is clean.
