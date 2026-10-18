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
</goal>

<hard_rules>
Apply every rule to every <unit>, not only the first one.
1. Rule. Reason: why.
</hard_rules>

<verification>
Real checks the executing session runs and reports. Never claim a
check passed without running it.
</verification>

<not_included>
Closed list of things to leave out.
</not_included>

<deliverables>
Done when all of these are produced and the verification results are
reported. Then stop and report.
1. First deliverable.
</deliverables>
```

## Usage

Five lines at most. Say where to paste the prompt and what the session
needs.

## Provenance

[Research log](../research/<slug>-log.md)
