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
One sentence: a senior expert defined by experience, with a default
stance where one helps.
</role>

<task>
Imperative sentence: what to produce.
</task>

<goal>
The outcome and why it matters.

Carry the work through to the finished deliverables. State the quality
bar a choice must meet; among choices that meet it, take the one that
changes the project least and keeps what the product does. Create only
the files this prompt names.
</goal>

<hard_rules>
Apply every rule to every <unit>, not only the first one.
1. Rule. Reason: why.
</hard_rules>

<verification>
Real checks the executing session runs, with their actual output.
Count a check as passed only after running it. When a check fails,
fix the work and keep the check as written.
</verification>

<not_included>
Closed list of things to leave out.
</not_included>

<deliverables>
Done when all of these are produced, including the verification
results. Keep working until then.
1. First deliverable: the thing done, not a description of how.
</deliverables>
```

## Usage

Five lines at most. Say where to paste the prompt and what the session
needs.

## Provenance

[Research log](../research/<slug>-log.md)
