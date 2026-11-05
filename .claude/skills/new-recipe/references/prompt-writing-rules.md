# Prompt skeleton and writing rules

Every recipe prompt uses these XML tags, in this order, with the same tag
names across recipes [A1]. Omit a tag only when it has no content.

## Skeleton

- `<role>`: one sentence naming a senior expert by experience, never by
  authority; add a default stance where one helps ("treats every input
  as hostile until the code proves otherwise") [A1].
- `<task>`: what to produce, as an imperative sentence. Write "Write X",
  never "Can you write X". Current models act on direct instructions and
  only suggest when asked a question [A1].
- `<goal>`: the outcome and why it matters. Context lets the model
  generalize from the intent [A1]. Second paragraph: carry the work
  through to the deliverables; a fixed quality bar first, then the
  choice that changes the project least and keeps what the product
  does; create only the files the prompt names.
- `<hard_rules>`: numbered rules, each with its reason. Open with a scope
  sentence: "Apply every rule to every <unit>, not only the first one."
- `<config>` with an `<example>`: the editable inputs. Wrap examples in
  `<example>` tags [A1].
- Task sections: one tag per aspect (jobs, modes, cache, steps).
- `<output_format>`: exact text, flags, exit codes, tables.
- `<verification>`: real checks the executing session must run and
  report [A2].
- `<not_included>`: a closed list of things to leave out [A1] [A2].
- `<deliverables>`: a numbered list in delivery order. Open with a
  stopping condition: "Done when ..." [A2].

If a recipe embeds long inputs, put them at the top of the prompt and the
instructions after them [A1].

## Writing rules

1. Colleague test: if a colleague with no context would be confused by the
   prompt, Claude will be too [A1].
2. Give the reason for every rule, inside the rule. Claude generalizes
   from an explanation better than from a bare command [A1].
3. Be prescriptive about outputs and constraints. Be general about
   reasoning: ask the model to think, and do not script its thinking
   steps [A1].
4. Never ask the model to write out its reasoning in the response. Ask
   for a short explanation or a summary of actions. Such requests can
   trigger a safeguard refusal on current models [A2].
5. State positive instructions first ("Include only the jobs above"). Put
   exclusions in `<not_included>`. Skip ALL-CAPS emphasis; aggressive
   wording makes current models overtrigger [A1].
6. State scope explicitly: "apply this to every job", "in all three
   modes". Current models follow instructions literally [A3].
7. Add a stopping condition and a `<not_included>` list to every recipe.
   Otherwise the model may stop early to check in, or do more than asked
   [A2].
8. Add a `<verification>` section for any recipe that produces code or
   config. Models sometimes report code as done without running a check
   [A2].
9. Use 3 to 5 examples when the output format is the main risk. One
   minimal example is enough for plain config blocks [A1].
10. Match the prompt's style to the output you want [A1].
11. Write for the target model in the front matter. Treat any technique
    that names a model as measured on that model [A1].
12. Start at suggested_effort high and re-sweep against real outputs when
    the target model changes; effort levels are recalibrated per model
    [A2].

## Keep the session acting

Lessons from real runs (see the research logs' user and session report
rows). Each wording below made a session stop or ask.

13. Invite no question and no stop: no "ask before", "stop and report",
    "if you cannot", or fallback markers such as UNRESOLVED. State a
    limit as a fact ("Leave history as it is"). The session may still
    ask on its own [A2].
14. Describe no situation that may never happen. Each one gives the
    session a reason to stop and check which case it is in.
15. Every deliverable must be reachable under the hard rules. A rule that
    forbids an action a deliverable needs (push, merge, tag) stops the
    run.
16. A deliverable is the thing done (the release run, the merged pull
    request), never a description of how someone would do it.
17. Give every policy choice a default in the prompt (a license list, a
    first version, a merge path). An open policy is a question.
18. Write each prompt for a session that has never seen another recipe.
    Name no other recipe or its output in the prompt; matching between
    recipes goes in Usage, for the reader.
19. Keep prompts transferable: no project-specific names, and check repo
    state instead of trusting it ("a green run proves only what it
    ran").
20. Require proof in the work itself: a test that fails before the fix
    and passes after, every existing test kept, a failed check fixed in
    the work and kept as written.

## Revising a recipe

- Change words inside existing rules before adding a rule. Every added
  rule is one more thing to weigh.
- Paraphrase the user in the prompt; record their words only in the
  research log's requirements.

## Removing ambiguity

- Replace "should", "if appropriate", "if time allows", and "etc." with one
  chosen default or a closed list.
- Give numbers (timeouts, versions, limits) and exact commands and flags.
- Define every event, mode, and case separately.
- Where the user might want a different choice, choose one, state it in
  the closing note, and let the user change it. Put the choice in the
  prompt as a default, never as a question for the session.
