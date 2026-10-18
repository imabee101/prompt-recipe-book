# Prompt audit, 2026-10-18

Audit of every recipe against Anthropic's prompting guidance, with the
evidence needed to re-check each verdict. Run every command from the
repository root. Page keys and source IDs are defined in ../sources.md.

## Pages

All fetched in full on 2026-10-18 with curl (raw .md, HTTP 200):

- [A1] Prompting best practices.
- [A2] Prompting Claude Sonnet 5.5 (the target_model page for all three recipes).
- [A3] Prompting Claude Sonnet 5.
- [A4] Define success criteria and build evaluations.

## 1. Checklist

One item per recommendation on those pages, plus the repo's stated
requirements (REPO). An item applies unless the page limits it to another
model, to API or harness settings, or to a task type the recipe does not
perform; each not-applicable verdict names which limit holds. An item that
cannot be checked counts as a fail.

| Item | Recommendation | Source page | Fetched |
| --- | --- | --- | --- |
| P01 | Specific instructions: output format and constraints are stated explicitly (named files, exact commands, numbers). | A1 "Be clear and direct" | 2026-10-18 |
| P02 | Steps whose order or completeness matters are numbered or bulleted lists. | A1 "Be clear and direct" | 2026-10-18 |
| P03 | Colleague test: a reader with no context could follow it; every tag or section the prompt refers to exists; no undefined terms. | A1 "Golden rule" | 2026-10-18 |
| P04 | "Above and beyond" behavior is requested explicitly when wanted, not left to inference. | A1 "Be clear and direct" | 2026-10-18 |
| P05 | Every hard rule states its reason (context or motivation). | A1 "Add context to improve performance" | 2026-10-18 |
| P06 | Relevant examples are present and wrapped in example tags (examples tags for several). | A1 "Use examples effectively" | 2026-10-18 |
| P07 | Examples are diverse and number 3 to 5 per example set. | A1 "Use examples effectively" (tip) | 2026-10-18 |
| P08 | XML tags have consistent, descriptive names, nest where hierarchical, and every opened tag is closed. | A1 "Structure prompts with XML tags" | 2026-10-18 |
| P09 | The role is set in one sentence. | A1 "Give Claude a role" | 2026-10-18 |
| P10 | Long inputs (20k+ tokens) sit at the top in document tags, with quote grounding. | A1 "Long context prompting" | 2026-10-18 |
| P11 | Model identity or model-string line for apps that need it. | A1 "Model self-knowledge" | 2026-10-18 |
| P12 | Positive framing: says what to do rather than only what not to do; positive examples over negative ones. | A1 "Control the format of responses"; A3 "Response length and verbosity" | 2026-10-18 |
| P13 | Prompt style matches the desired output style. | A1 "Control the format of responses" | 2026-10-18 |
| P14 | Detailed format guidance exists where output format matters. | A1 "Control the format of responses" | 2026-10-18 |
| P15 | LaTeX, document-creation, and prefill-migration guidance. | A1 "LaTeX output", "Document creation", "Migrating away from prefilled responses" | 2026-10-18 |
| P16 | Action is requested with imperative verbs ("Write X"), never a question ("Can you ...?"). | A1 "Tool usage" | 2026-10-18 |
| P17 | The default stance (act versus only suggest) is explicit. | A1 "Tool usage" | 2026-10-18 |
| P18 | No aggressive or capitalized emphasis (CRITICAL, MUST, words in all caps used for emphasis). Literal output strings are exempt. | A1 "Tool usage" | 2026-10-18 |
| P19 | Parallel tool-call tuning. | A1 "Optimize parallel tool calling" | 2026-10-18 |
| P20 | No blanket over-prompting of tools ("If in doubt, use X", "Default to using X"). | A1 "Overthinking and excessive thoroughness" | 2026-10-18 |
| P21 | Thinking guidance is general; no hand-written step-by-step reasoning plan. | A1 "Leverage thinking" | 2026-10-18 |
| P22 | No request to write reasoning in the response (thinking tags, "explain your reasoning step by step"); a short explanation or action summary is allowed. | A1 "Leverage thinking"; A2 "Safeguard refusals" | 2026-10-18 |
| P23 | Self-check: the model verifies against stated criteria before finishing. | A1 "Leverage thinking" | 2026-10-18 |
| P24 | Context-window and compaction guidance for long harness runs. | A1 "Context awareness and multiwindow workflows" | 2026-10-18 |
| P25 | Multi-context-window workflow (state files, setup scripts, tests.json). | A1 "Workflows across multiple context windows" | 2026-10-18 |
| P26 | Confirmation before hard-to-reverse or shared-system actions (deleting files, rewriting history, pushing, publishing); no destructive shortcuts. | A1 "Balancing autonomy and safety" | 2026-10-18 |
| P27 | Research tasks have clear success criteria and verify across multiple sources. | A1 "Research and information gathering" | 2026-10-18 |
| P28 | Subagent use guidance. | A1 "Subagent orchestration" | 2026-10-18 |
| P29 | Temporary files are cleaned up, or creating them is ruled out. | A1 "Reduce file creation in agentic coding" | 2026-10-18 |
| P30 | Overengineering guard: only requested changes, no extra files or abstractions. | A1 "Overeagerness" | 2026-10-18 |
| P31 | General solutions: no hard-coding to pass checks; infeasible or wrong checks are reported, not worked around. | A1 "Avoid focusing on passing tests and hardcoding" | 2026-10-18 |
| P32 | Investigate before answering: read the code and repository before making claims; never invent names, paths, versions, or identifiers. | A1 "Minimizing hallucinations in agentic coding" | 2026-10-18 |
| P33 | Written for the target model in front matter; model-specific techniques come from that model's page. | A1 "General principles" | 2026-10-18 |
| P34 | Vision, frontend-design, and medication-dosing blocks. | A1 "Capability-specific tips" | 2026-10-18 |
| S01 | suggested_effort fits the target-model guidance for the task type. | A2 "Calibrate effort"; A3 "Calibrating effort" | 2026-10-18 |
| S02 | No instruction to think less or not to think. | A2 "Calibrate effort", "Running without up-front thinking" | 2026-10-18 |
| S03 | Carry work through: keep working until done; stop to ask only when blocked or before a risky step. | A2 "Steer initiative and scope" | 2026-10-18 |
| S04 | Stop and report when done and checked; no unrequested features, tests, files, or docs; suggestions go at the end. | A2 "Steer initiative and scope" | 2026-10-18 |
| S05 | No self-started extra review rounds at xhigh or max effort. | A2 "Steer initiative and scope" | 2026-10-18 |
| S06 | Open-ended requests say whether ideas or a plan come first. | A2 "Steer initiative and scope" | 2026-10-18 |
| S07 | JSON answers to reasoning tasks (structured outputs, parsing the last JSON value). | A2 "Reasoning tasks with JSON output" | 2026-10-18 |
| S08 | No "hold all findings for the final response"; update points stated if wanted. | A2 "User-facing progress updates" | 2026-10-18 |
| S09 | No tool-discouraging language; specifics that may have changed are checked with tools. | A2 "Tool use in chat and knowledge work" | 2026-10-18 |
| S10 | Mid-turn messages, tolerant tool-call handling, visual-input tools, max_tokens, and between_tools settings. | A2 (harness and API sections) | 2026-10-18 |
| S11 | Coding verification: run a real check that exercises the change; syntax-only or failed-to-start checks do not count; if no check can run, say which and why. | A2 "Verification on coding tasks" | 2026-10-18 |
| T01 | Verbosity tuned when the product depends on it. | A3 "Response length and verbosity" | 2026-10-18 |
| T02 | No forced interim status scaffolding ("after every 3 tool calls, summarize"). | A3 "User-facing progress updates" | 2026-10-18 |
| T03 | Scope is explicit ("every X, not just the first one"). | A3 "More literal instruction following" | 2026-10-18 |
| T04 | Tone, temperature, design defaults, and computer-use settings. | A3 (tone, design, computer use) | 2026-10-18 |
| T05 | Task, intent, and constraints are given up front in the first turn. | A3 "Interactive coding products" | 2026-10-18 |
| T06 | Review steps report every finding (coverage) or use a concrete bar. | A3 "Code review harnesses" | 2026-10-18 |
| E01 | Success criteria are specific. | A4 "Define your success criteria" | 2026-10-18 |
| E02 | Success criteria are measurable (numbers, exact expected outputs, or defined scales). | A4 "Define your success criteria" | 2026-10-18 |
| E03 | Success criteria are achievable with the tools the prompt assumes. | A4 "Define your success criteria" | 2026-10-18 |
| E04 | Success criteria are relevant to the recipe's purpose. | A4 "Define your success criteria" | 2026-10-18 |
| E05 | Several criteria cover the dimensions the task needs. | A4 "Common success criteria" | 2026-10-18 |
| E06 | Checks are task-specific and include edge cases. | A4 "Eval design principles" | 2026-10-18 |
| E07 | Checks are automated (code-graded) where possible. | A4 "Eval design principles", "Grade your evaluations" | 2026-10-18 |
| E08 | Eval volume over hand-graded quality. | A4 "Eval design principles" | 2026-10-18 |
| E09 | LLM-graded checks use detailed rubrics and specific outputs. | A4 "Tips for LLM-based grading" | 2026-10-18 |
| R01 | scripts/check-recipes.sh reports no problem for the recipe (front matter, sections, one code block, required tags, "Done when", Usage of 5 lines or fewer). | REPO CLAUDE.md | 2026-10-18 |
| R02 | Prompt tags follow the skeleton order: role, task, goal, hard_rules, config, task sections, output_format, verification, not_included, deliverables. | REPO prompt-writing-rules | 2026-10-18 |
| R03 | Deliverables open with a "Done when" stopping condition. | REPO prompt-writing-rules; A2 | 2026-10-18 |
| R04 | not_included is a closed list. | REPO prompt-writing-rules; A2 | 2026-10-18 |
| R05 | No ambiguous words: "should", "if appropriate", "if time allows", "etc." | REPO prompt-writing-rules "Removing ambiguity" | 2026-10-18 |
| R06 | Every claim the prompt makes about a tool, platform, or standard has a log row, and no T0 claim remains. | REPO CLAUDE.md | 2026-10-18 |
| R07 | Paired recipes have the same stages, flags, regexes, config files, and version minimums. | REPO CLAUDE.md | 2026-10-18 |

## 2. Per recipe

### claude-md-write-and-audit

Verdicts on the file as committed with this record. Line numbers refer to
recipes/claude-md-write-and-audit.md.

| Item | Verdict | Evidence |
| --- | --- | --- |
| P01 | pass | line 273: `1. CLAUDE.md, 200 lines or fewer.` |
| P02 | pass | line 197: `1. Fetch the pages under <sources> when a web fetch tool exists.` |
| P03 | pass | line 21: `<task>` |
| P04 | n/a | task type. Recipes bound scope (not_included, Done when); no above-and-beyond output is wanted. |
| P05 | pass | line 76: `in place is allowed. Reason: those actions are hard to` |
| P06 | pass | line 175: `Audit table rows. The commands are illustrative; take real ones` |
| P07 | pass | line 190: `"Files under migrations/ are generated; create them with` |
| P08 | pass | `awk '/^<[a-z_]+>$/{o[substr($0,2,length($0)-2)]++} /^<\/[a-z_]+>$/{c[substr($0,3,length($0)-3)]++} END{for(t in o) if(o[t]!=c[t]) print "unbalanced " t; for(t in c) if(!(t in o)) print "unbalanced " t; print "checked"}' recipes/claude-md-write-and-audit.md` -> `checked` |
| P09 | pass | line 16: `You are a senior developer-experience engineer who writes and` |
| P10 | n/a | task type. No input of 20k+ tokens is embedded. |
| P11 | n/a | task type. Page scopes it to applications that must state the model's identity. |
| P12 | pass | line 44: `3. Use markdown headers and bullets. Do not use XML tags or dense` |
| P13 | pass | line 274: `2. Audit mode: the audit table. Create mode: a table of line group` |
| P14 | pass | line 206: `line or section \| keep, cut, rewrite, or move \| reason \|` |
| P15 | n/a | task type and API. No math, presentation, or document output; prefill is an API feature. |
| P16 | pass | line 22: `Write or audit the project CLAUDE.md for the repository in the` |
| P17 | pass | line 24: `uncommitted changes, audit it and rewrite it in place, because git` |
| P18 | pass | `grep -nE '\b(CRITICAL\|MUST\|ALWAYS\|NEVER\|IMPORTANT\|ALL\|ONLY)\b' recipes/claude-md-write-and-audit.md` -> `60:8. Use emphasis such as "IMPORTANT" only on a line Claude has been` The one hit is the quoted word in rule 8, which names the thing to avoid; it is a mention, not emphasis. |
| P19 | n/a | harness. Page offers it as optional tool-execution tuning; no deliverable depends on it. |
| P20 | pass | `grep -ciE 'if in doubt\|default to using' recipes/claude-md-write-and-audit.md` -> `0` |
| P21 | pass | line 203: `3. List candidate lines. For each, apply the rule 2 test and the` |
| P22 | pass | `grep -ciE 'step[- ]by[- ]step\|your reasoning\|chain[- ]of[- ]thought\|<thinking>\|think out loud' recipes/claude-md-write-and-audit.md` -> `0` |
| P23 | pass | line 250: `4. List the rules by topic and confirm no two conflict.` |
| P24 | n/a | harness. Page scopes it to harnesses that compact or save context; a pasted prompt cannot configure that. |
| P25 | n/a | task type. Page scopes it to tasks spanning several context windows; each recipe writes at most four files. |
| P26 | pass | line 74: `12. Ask before deleting files, rewriting git history, or` |
| P27 | pass | line 82: `have a web fetch tool, re-fetch the three pages listed under` |
| P28 | n/a | task type. No recipe orchestrates subagents. |
| P29 | pass | line 263: `file except CLAUDE.md and .gitignore. Do not add sections beyond` |
| P30 | pass | line 260: `Do not create skills, hooks, rules, or settings files; propose` |
| P31 | pass | line 256: `running it. When a check fails, fix CLAUDE.md, never the check.` |
| P32 | pass | line 71: `11. Never invent commands, paths, or environment variables. Run` |
| P33 | pass | line 4: `target_model: claude-sonnet-5-5` |
| P34 | n/a | task type. No images, frontend design, or medication questions. |
| S01 | pass | line 5: `suggested_effort: high` |
| S02 | pass | `grep -ciE 'think less\|do not think\|don.t think' recipes/claude-md-write-and-audit.md` -> `0` |
| S03 | pass | line 269: `are reported. Keep working until then; stop to ask only when you` |
| S04 | pass | line 271: `12. Then stop and report. Mention possible improvements at the end` |
| S05 | n/a | page ties it to xhigh and max effort; suggested_effort is high. |
| S06 | n/a | task type. No open-ended request; each task names its deliverables. |
| S07 | n/a | task type. No JSON answer is requested. |
| S08 | pass | `grep -ciE 'hold all\|after every [0-9]+ tool' recipes/claude-md-write-and-audit.md` -> `0` |
| S09 | pass | line 81: `Facts from Anthropic's documentation, checked 2026-10-18. When you` |
| S10 | n/a | harness and API settings that a pasted prompt cannot set. |
| S11 | pass | line 244: `2. Run each command the file names (or its --help or dry-run` |
| T01 | n/a | page scopes it to products that depend on a verbosity level. |
| T02 | pass | `grep -ciE 'hold all\|after every [0-9]+ tool' recipes/claude-md-write-and-audit.md` -> `0` |
| T03 | pass | line 38: `Apply every rule to every line of the file and to every file you` |
| T04 | n/a | API settings (temperature) or task types not performed (design, computer use, tone). |
| T05 | pass | line 205: `4. Write CLAUDE.md. In audit mode, build the audit table first:` |
| T06 | pass | line 206: `line or section \| keep, cut, rewrite, or move \| reason \|` |
| E01 | pass | line 243: `1. Run wc -l CLAUDE.md. Expected: 200 or fewer.` |
| E02 | pass | line 243: `1. Run wc -l CLAUDE.md. Expected: 200 or fewer.` |
| E03 | pass | line 242: `If you have a shell:` |
| E04 | pass | line 31: `Give Claude the smallest set of facts that change its behavior in` |
| E05 | pass | line 251: `5. If Claude Code is available, run /context and confirm` |
| E06 | pass | line 244: `2. Run each command the file names (or its --help or dry-run` |
| E07 | pass | line 247: `3. Run grep -niE 'properly\|clean code\|best practices\|where possible\|as needed\|try to' CLAUDE.md` |
| E08 | n/a | task type. Page addresses eval sets for an application; a recipe runs once per repository. |
| E09 | pass | line 253: `fresh session one question that only CLAUDE.md can answer.` |
| R01 | pass | `scripts/check-recipes.sh; echo "exit $?"` -> `exit 0` |
| R02 | pass | `grep -E '^<[a-z_]+>$' recipes/claude-md-write-and-audit.md \| grep -v example \| tr -d '<>' \| tr '\n' ' '` -> `role task goal hard_rules spec sources routing content_rules steps maintenance verification not_included deliverables` |
| R03 | pass | line 268: `Done when all of these are produced and the verification results` |
| R04 | pass | line 264: `<content_rules>. Do not start extra review rounds.` |
| R05 | pass | `grep -cwiE 'should\|etc\|if appropriate\|if time allows' recipes/claude-md-write-and-audit.md` -> `0` |
| R06 | pass | `grep -c '\| T0 \|' research/claude-md-write-and-audit-log.md` -> `0` |
| R07 | n/a | pairs_with is none. |

Edits made:

- P05: added reasons to hard rules 4, 10, 11, and 12.
- P06, P07: added an examples block with four diverse audit-table rows (rewrite, cut, move, keep).
- R02: moved the sources tag from after deliverables to after spec.
- R06 (refuted claim): the AGENTS.md spec line now says v2.1.277 or later reads AGENTS.md when no CLAUDE.md exists [C1]. The unverifiable /doctor version was removed and /doctor prompt-audit (v2.1.283 or later) added [C1] [C7].
- R06 (T0 claims): the vague-term grep now only finds lines for judgment against hard rule 4. Rewriting in place now applies only to a committed file; an uncommitted file needs confirmation first [S7].
- P26: hard rule 12 now also covers overwriting uncommitted changes.
- R05: replaced "should have known" with "missed" in maintenance.
- S03, S04: deliverables now say to keep working until done and to stop only when blocked or before a hard rule 12 action.
- S11, P31: verification now says to name a skipped check and why, and to fix the file, never the check.

Status decision: verified. No item fails (50 pass, 0 fail,
17 not applicable), no T0 claim remains in the log, and
scripts/check-recipes.sh prints nothing. The user waived the independent
review. Fix rounds used: 1 of 3.

### rust-ci-github-actions

Verdicts on the file as committed with this record. Line numbers refer to
recipes/rust-ci-github-actions.md.

| Item | Verdict | Evidence |
| --- | --- | --- |
| P01 | pass | line 56: `5. Timeouts (timeout-minutes): changes 5, gates 10,` |
| P02 | pass | line 175: `Create these jobs in order.` |
| P03 | pass | line 29: `YAML with actionlint and follow <verification>. Otherwise, review` |
| P04 | n/a | task type. Recipes bound scope (not_included, Done when); no above-and-beyond output is wanted. |
| P05 | pass | line 74: `jobs in needs:. Reason: a job whose needed job fails is` |
| P06 | pass | line 120: `A CLI published to crates.io, cross-built for ARM Linux:` |
| P07 | pass | line 129: `A shared library that is never released on its own:` |
| P08 | pass | `awk '/^<[a-z_]+>$/{o[substr($0,2,length($0)-2)]++} /^<\/[a-z_]+>$/{c[substr($0,3,length($0)-3)]++} END{for(t in o) if(o[t]!=c[t]) print "unbalanced " t; for(t in c) if(!(t in o)) print "unbalanced " t; print "checked"}' recipes/rust-ci-github-actions.md` -> `checked` |
| P09 | pass | line 16: `You are a senior CI/release engineer who writes production-grade` |
| P10 | n/a | task type. No input of 20k+ tokens is embedded. |
| P11 | n/a | task type. Page scopes it to applications that must state the model's identity. |
| P12 | pass | line 49: `3. Dependency updates stay manual: add no Dependabot, Renovate,` |
| P13 | pass | line 367: `3. A table: job \| trigger event \| components and targets covered \|` |
| P14 | pass | line 369: `4. A table of events (pull_request, merge_group, push to main with` |
| P15 | n/a | task type and API. No math, presentation, or document output; prefill is an API feature. |
| P16 | pass | line 21: `Write one file, .github/workflows/ci.yml. It lints, checks, tests,` |
| P17 | pass | line 21: `Write one file, .github/workflows/ci.yml. It lints, checks, tests,` |
| P18 | pass | `grep -nE '\b(CRITICAL\|MUST\|ALWAYS\|NEVER\|IMPORTANT\|ALL\|ONLY)\b' recipes/rust-ci-github-actions.md` -> `(no output)` No hit. |
| P19 | n/a | harness. Page offers it as optional tool-execution tuning; no deliverable depends on it. |
| P20 | pass | `grep -ciE 'if in doubt\|default to using' recipes/rust-ci-github-actions.md` -> `0` |
| P21 | pass | line 175: `Create these jobs in order.` |
| P22 | pass | `grep -ciE 'step[- ]by[- ]step\|your reasoning\|chain[- ]of[- ]thought\|<thinking>\|think out loud' recipes/rust-ci-github-actions.md` -> `0` |
| P23 | pass | line 339: `2. Confirm by search: no schedule or workflow_dispatch trigger,` |
| P24 | n/a | harness. Page scopes it to harnesses that compact or save context; a pasted prompt cannot configure that. |
| P25 | n/a | task type. Page scopes it to tasks spanning several context windows; each recipe writes at most four files. |
| P26 | pass | line 86: `13. Ask before deleting files, rewriting git history, pushing,` |
| P27 | n/a | task type. Looking up a SHA in its own repository is a single-fact lookup, not research synthesis. |
| P28 | n/a | task type. No recipe orchestrates subagents. |
| P29 | pass | line 345: `4. Delete any temporary files you created for these checks.` |
| P30 | pass | line 353: `Include only the jobs above. Leave out miri, fuzzing, benchmarks,` |
| P31 | pass | line 349: `fix ci.yml, never the check.` |
| P32 | pass | line 89: `14. Never invent crate names, paths, runner labels, versions, or` |
| P33 | pass | line 4: `target_model: claude-sonnet-5-5` |
| P34 | n/a | task type. No images, frontend design, or medication questions. |
| S01 | pass | line 5: `suggested_effort: high` |
| S02 | pass | `grep -ciE 'think less\|do not think\|don.t think' recipes/rust-ci-github-actions.md` -> `0` |
| S03 | pass | line 360: `are reported. Keep working until then; stop to ask only when you` |
| S04 | pass | line 362: `13. Then stop and report. Mention possible improvements at the end` |
| S05 | n/a | page ties it to xhigh and max effort; suggested_effort is high. |
| S06 | n/a | task type. No open-ended request; each task names its deliverables. |
| S07 | n/a | task type. No JSON answer is requested. |
| S08 | pass | `grep -ciE 'hold all\|after every [0-9]+ tool' recipes/rust-ci-github-actions.md` -> `0` |
| S09 | pass | line 26: `cargo metadata --locked. Look up each action's latest release and` |
| S10 | n/a | harness and API settings that a pasted prompt cannot set. |
| S11 | pass | line 338: `1. Run actionlint on ci.yml and fix every finding.` |
| T01 | n/a | page scopes it to products that depend on a verbosity level. |
| T02 | pass | `grep -ciE 'hold all\|after every [0-9]+ tool' recipes/rust-ci-github-actions.md` -> `0` |
| T03 | pass | line 42: `Apply every rule to every job, not only the first one. Follow each` |
| T04 | n/a | API settings (temperature) or task types not performed (design, computer use, tone). |
| T05 | pass | line 20: `<task>` |
| T06 | n/a | task type. The recipe has no review step that reports findings. |
| E01 | pass | line 343: `3. Confirm that no two matrix legs can write the same rust-cache` |
| E02 | pass | line 56: `5. Timeouts (timeout-minutes): changes 5, gates 10,` |
| E03 | pass | line 347: `If you have no shell, state that the file is unvalidated. Never` |
| E04 | pass | line 34: `Every pull request gets fast, high-confidence feedback. A job runs` |
| E05 | pass | line 339: `2. Confirm by search: no schedule or workflow_dispatch trigger,` |
| E06 | pass | line 343: `3. Confirm that no two matrix legs can write the same rust-cache` |
| E07 | pass | line 338: `1. Run actionlint on ci.yml and fix every finding.` |
| E08 | n/a | task type. Page addresses eval sets for an application; a recipe runs once per repository. |
| E09 | n/a | task type. No LLM-graded check. |
| R01 | pass | `scripts/check-recipes.sh; echo "exit $?"` -> `exit 0` |
| R02 | pass | `grep -E '^<[a-z_]+>$' recipes/rust-ci-github-actions.md \| grep -v example \| tr -d '<>' \| tr '\n' ' '` -> `role task goal hard_rules config shared_config_files skip_logic jobs cache build_cost verification not_included deliverables` |
| R03 | pass | line 359: `Done when all of these are produced and the verification results` |
| R04 | pass | line 355: `and release dry runs in the merge queue.` |
| R05 | pass | `grep -cwiE 'should\|etc\|if appropriate\|if time allows' recipes/rust-ci-github-actions.md` -> `0` |
| R06 | pass | `grep -c '\| T0 \|' research/rust-ci-github-actions-log.md` -> `0` |
| R07 | pass | `for p in '0\.9\.89' 'fmt --all --check' 'docs/\*\*, \*\*/\*\.md, LICENSE\*' 'feat\|fix\|perf' 'skip-checks:' 'line-tables-only' 'test --doc' 'toolchain install M' 'manage-deps --dry-run'; do printf '%s ci=%s local=%s; ' "$p" $(grep -c -- "$p" recipes/rust-ci-github-actions.md) $(grep -c -- "$p" recipes/rust-local-check-script.md); done` -> `0\.9\.89 ci=1 local=1; fmt --all --check ci=1 local=1; docs/\*\*, \*\*/\*\.md, LICENSE\* ci=1 local=1; feat\|fix\|perf ci=1 local=1; skip-checks: ci=1 local=1; line-tables-only ci=1 local=1; test --doc ci=1 local=1; toolchain install M ci=1 local=1; manage-deps --dry-run ci=1 local=1;` |

Edits made:

- P18: replaced three capitalized "ALL" with "all".
- P05, P12: added reasons to hard rules 3, 4, 7, 10, and 12; rules 3 and 4 now open with the positive instruction.
- P26, P32: added hard rule 13 (ask before deleting, rewriting history, pushing, tagging, publishing) and hard rule 14 (never invent crate names, paths, runners, versions, or SHAs). The task now says to fill config from the workspace and look up action SHAs.
- P06, P07: replaced the single example with three diverse examples in an examples block.
- R02: moved not_included after verification.
- S03, S04: deliverables now say to keep working until done, then stop and report, with improvements at the end.
- P29, P31: verification now deletes temporary files and fixes the file, never the check.
- R07 (parity): docs-only globs, cargo fmt --all --check, the skip-checks: wording, and the shared config files (linker bullet, fast nextest profile) now match the local recipe.

Status decision: verified. No item fails (48 pass, 0 fail,
19 not applicable), no T0 claim remains in the log, and
scripts/check-recipes.sh prints nothing. The user waived the independent
review. Fix rounds used: 1 of 3.

### rust-local-check-script

Verdicts on the file as committed with this record. Line numbers refer to
recipes/rust-local-check-script.md.

| Item | Verdict | Evidence |
| --- | --- | --- |
| P01 | pass | line 83: `11. Exit codes: 0 pass or skip, 1 check failed, 2 usage error or` |
| P02 | pass | line 194: `a. preflight (target under 1 second): confirm git, jq,` |
| P03 | pass | line 26: `read every Cargo.toml and the output of cargo metadata --locked.` |
| P04 | n/a | task type. Recipes bound scope (not_included, Done when); no above-and-beyond output is wanted. |
| P05 | pass | line 84: `missing tool. Reason: callers can tell a failed check from a` |
| P06 | pass | line 119: `A CLI cross-built for ARM Linux:` |
| P07 | pass | line 125: `A shared library built only for the host:` |
| P08 | pass | `awk '/^<[a-z_]+>$/{o[substr($0,2,length($0)-2)]++} /^<\/[a-z_]+>$/{c[substr($0,3,length($0)-3)]++} END{for(t in o) if(o[t]!=c[t]) print "unbalanced " t; for(t in c) if(!(t in o)) print "unbalanced " t; print "checked"}' recipes/rust-local-check-script.md` -> `checked` |
| P09 | pass | line 16: `You are a senior Rust build-tooling engineer who writes fast,` |
| P10 | n/a | task type. No input of 20k+ tokens is embedded. |
| P11 | n/a | task type. Page scopes it to applications that must state the model's identity. |
| P12 | pass | line 77: `9. Keep the real repo's target dirs between runs: never run` |
| P13 | pass | line 348: `4. A table: mode \| stages in order \| scope \| what it catches.` |
| P14 | pass | line 282: `- Stage success: "[ok] <stage> <seconds>s"` |
| P15 | n/a | task type and API. No math, presentation, or document output; prefill is an API feature. |
| P16 | pass | line 21: `Write one bash script, scripts/check, plus the config files it` |
| P17 | pass | line 21: `Write one bash script, scripts/check, plus the config files it` |
| P18 | pass | `grep -nE '\b(CRITICAL\|MUST\|ALWAYS\|NEVER\|IMPORTANT\|ALL\|ONLY)\b' recipes/rust-local-check-script.md` -> `(no output)` No hit. |
| P19 | n/a | harness. Page offers it as optional tool-execution tuning; no deliverable depends on it. |
| P20 | pass | `grep -ciE 'if in doubt\|default to using' recipes/rust-local-check-script.md` -> `0` |
| P21 | pass | line 56: `4. Order stages cheapest to costliest. Reason: the quickest` |
| P22 | pass | `grep -ciE 'step[- ]by[- ]step\|your reasoning\|chain[- ]of[- ]thought\|<thinking>\|think out loud' recipes/rust-local-check-script.md` -> `0` |
| P23 | pass | line 303: `1. Run shellcheck on scripts/check and fix every warning.` |
| P24 | n/a | harness. Page scopes it to harnesses that compact or save context; a pasted prompt cannot configure that. |
| P25 | n/a | task type. Page scopes it to tasks spanning several context windows; each recipe writes at most four files. |
| P26 | pass | line 88: `13. Ask before deleting files, rewriting git history, pushing, or` |
| P27 | n/a | task type. No research step; inputs come from the workspace. |
| P28 | n/a | task type. No recipe orchestrates subagents. |
| P29 | pass | line 323: `4. Delete the scratch workspace.` |
| P30 | pass | line 86: `12. Implement only what this prompt specifies. Reason: every extra` |
| P31 | pass | line 327: `fix the script, never the check, and make the script work for` |
| P32 | pass | line 92: `14. Never invent crate names, paths, triples, or versions. Reason:` |
| P33 | pass | line 4: `target_model: claude-sonnet-5-5` |
| P34 | n/a | task type. No images, frontend design, or medication questions. |
| S01 | pass | line 5: `suggested_effort: high` |
| S02 | pass | `grep -ciE 'think less\|do not think\|don.t think' recipes/rust-local-check-script.md` -> `0` |
| S03 | pass | line 339: `are reported. Keep working until then; stop to ask only when you` |
| S04 | pass | line 341: `13. Then stop and report. Mention possible improvements at the end` |
| S05 | n/a | page ties it to xhigh and max effort; suggested_effort is high. |
| S06 | n/a | task type. No open-ended request; each task names its deliverables. |
| S07 | n/a | task type. No JSON answer is requested. |
| S08 | pass | `grep -ciE 'hold all\|after every [0-9]+ tool' recipes/rust-local-check-script.md` -> `0` |
| S09 | pass | line 194: `a. preflight (target under 1 second): confirm git, jq,` |
| S10 | n/a | harness and API settings that a pasted prompt cannot set. |
| S11 | pass | line 304: `2. In a scratch workspace in a temporary directory, never in the` |
| T01 | n/a | page scopes it to products that depend on a verbosity level. |
| T02 | pass | `grep -ciE 'hold all\|after every [0-9]+ tool' recipes/rust-local-check-script.md` -> `0` |
| T03 | pass | line 42: `Apply every rule to all three modes (fast, gate, build), not only` |
| T04 | n/a | API settings (temperature) or task types not performed (design, computer use, tone). |
| T05 | pass | line 20: `<task>` |
| T06 | n/a | task type. The recipe has no review step that reports findings. |
| E01 | pass | line 308: `- a change in a reports a, b, c as affected;` |
| E02 | pass | line 309: `- a deliberate clippy warning stops at clippy, never starts` |
| E03 | pass | line 325: `If you have no shell, state that the script is untested. Never` |
| E04 | pass | line 31: `Deliver the fastest possible signal when something is wrong, and` |
| E05 | pass | line 349: `5. A table: mode \| what a green result verifies \| what it does` |
| E06 | pass | line 307: `- a docs-only change exits 0 immediately;` |
| E07 | pass | line 303: `1. Run shellcheck on scripts/check and fix every warning.` |
| E08 | n/a | task type. Page addresses eval sets for an application; a recipe runs once per repository. |
| E09 | n/a | task type. No LLM-graded check. |
| R01 | pass | `scripts/check-recipes.sh; echo "exit $?"` -> `exit 0` |
| R02 | pass | `grep -E '^<[a-z_]+>$' recipes/rust-local-check-script.md \| grep -v example \| tr -d '<>' \| tr '\n' ' '` -> `role task goal hard_rules config hakari hakari_setup change_detection modes config_files output_format verification not_included deliverables` |
| R03 | pass | line 338: `Done when all of these are produced and the verification results` |
| R04 | pass | line 334: `installation, CI workflows, versioning, and releasing.` |
| R05 | pass | `grep -cwiE 'should\|etc\|if appropriate\|if time allows' recipes/rust-local-check-script.md` -> `0` |
| R06 | pass | `grep -c '\| T0 \|' research/rust-local-check-script-log.md` -> `0` |
| R07 | pass | `for p in '0\.9\.89' 'fmt --all --check' 'docs/\*\*, \*\*/\*\.md, LICENSE\*' 'feat\|fix\|perf' 'skip-checks:' 'line-tables-only' 'test --doc' 'toolchain install M' 'manage-deps --dry-run'; do printf '%s ci=%s local=%s; ' "$p" $(grep -c -- "$p" recipes/rust-ci-github-actions.md) $(grep -c -- "$p" recipes/rust-local-check-script.md); done` -> `0\.9\.89 ci=1 local=1; fmt --all --check ci=1 local=1; docs/\*\*, \*\*/\*\.md, LICENSE\* ci=1 local=1; feat\|fix\|perf ci=1 local=1; skip-checks: ci=1 local=1; line-tables-only ci=1 local=1; test --doc ci=1 local=1; toolchain install M ci=1 local=1; manage-deps --dry-run ci=1 local=1;` |

Edits made:

- P05, P12: added reasons to hard rules 2, 3, 7, 8, 9, 10, 11, and 12; rules 9, 10, and 12 now open with the positive instruction.
- P26, P32: added hard rule 13 (ask before deleting, rewriting history, pushing, or committing in the real repo) and hard rule 14 (never invent names). The task now says to fill config from the workspace.
- P06, P07: replaced the single example with three diverse examples in an examples block.
- R02: moved output_format after config_files.
- S03, S04: deliverables now say to keep working until done, then stop and report, with improvements at the end.
- P26, P29, P31: deliberate-failure checks run only in a scratch workspace that is deleted afterwards; the gate runs in the real repo; a failing check is fixed in the script, never in the check.
- R06 (corrected claim): the x86_64 linker reason now names Rust 1.90 [R12] and covers older pinned toolchains.
- R07 (parity): docs-only globs now include .github/ISSUE_TEMPLATE/**, and the cargo deny trigger now includes .config/hakari.toml, matching the CI recipe.

Status decision: verified. No item fails (48 pass, 0 fail,
19 not applicable), no T0 claim remains in the log, and
scripts/check-recipes.sh prints nothing. The user waived the independent
review. Fix rounds used: 1 of 3.

## 3. Conformance statements

- claude-md-write-and-audit: checked on 2026-10-18 against [A1], [A2], [A3], and [A4] as
  fetched that day. 67 items: 50 pass, 0 fail, 17 not
  applicable. This covers only those page versions and the recipe text
  committed with this record, not future model behavior or later
  guidance.
- rust-ci-github-actions: checked on 2026-10-18 against [A1], [A2], [A3], and [A4] as
  fetched that day. 67 items: 48 pass, 0 fail, 19 not
  applicable. This covers only those page versions and the recipe text
  committed with this record, not future model behavior or later
  guidance.
- rust-local-check-script: checked on 2026-10-18 against [A1], [A2], [A3], and [A4] as
  fetched that day. 67 items: 48 pass, 0 fail, 19 not
  applicable. This covers only those page versions and the recipe text
  committed with this record, not future model behavior or later
  guidance.

## 4. Verification

Validity test, run before the audit and again with the final checklist:
a copy of rust-local-check-script was seeded with five defects
(capitalized emphasis, a polite-question task sentence, a request for
step-by-step reasoning, a missing "Done when", and an unclosed tag). The
final checklist failed P18, P16, P22, R03 (and R01), and P08 on the copy,
so every defect was flagged. The copy was then deleted.

Excerpt check: each cited line was printed with sed -n '<line>p' and
compared with its excerpt: 111 matched, 0 mismatched.

scripts/check-recipes.sh: no output, exit 0.

Re-verified T0 claims and the sources used are logged in each recipe's
research log; none remains T0.
