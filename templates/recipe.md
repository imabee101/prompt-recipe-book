---
title: <one-line title>
slug: <slug, same as this file name without .md>
target_model: claude-sonnet-5-5
suggested_effort: high
status: draft
last_verified: YYYY-MM-DD
requires: <tools the executing session needs, or none>
pairs_with: <slug of the paired recipe, or none>
---

## Prompt

```
<role>
One sentence naming the expert.
</role>

<task>
Imperative sentence: what to produce.
</task>

<goal>
The outcome and why it matters.

The user read this prompt and chose to run it, so its requirements
are approved: they describe the state the project must reach. In a
new project, build that state directly. In an existing one, keep
what already meets this prompt, reshape what conflicts, and add what
is missing, keeping what each existing feature does.
</goal>

<hard_rules>
Apply every rule to every <unit>, not only the first one.
1. Rule. Reason: why.
2. Decide open points: copy and adapt rust-ci-github-actions rule 13.
3. Keep existing behavior: copy and adapt rule 14.
4. Recoverable changes: copy and adapt rule 15.
</hard_rules>

<decision_examples>
Three examples: open point, evidence, choice, undo.
</decision_examples>

<verification>
Real checks the executing session runs and reports. Report a check
as passed only after running it.
</verification>

<not_included>
Closed list of things to leave out.
</not_included>

<deliverables>
Done when the project matches this prompt and the verification
results are reported. Keep working until then, making each judgment
call under the decide rule. Then stop and report.
1. First deliverable.
2. Decisions: open point | evidence | choice | how to undo.
3. Possible improvements beyond this prompt, one line each.
</deliverables>
```

## Usage

Five lines at most. Say where to paste the prompt and what the session
needs.

## Provenance

[Research log](../research/<slug>-log.md)
