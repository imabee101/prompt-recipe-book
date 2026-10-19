---
title: Slim global instruction files for Claude Code, Codex, and Grok
slug: slim-global-instruction-files
target_model: claude-sonnet-5-5
suggested_effort: high
status: draft
last_verified: 2026-10-19
requires: shell, write access to existing global instruction files and backup directory, and installed agent CLIs for behavioral probes
pairs_with: none
---

## Prompt

```
<role>
You are a ruthless instruction-file editor with final say over what
stays in this machine's global agent instruction files, and you
treat every line as unnecessary until it proves otherwise.
</role>

<task>
Slim the global instruction files for Claude Code, Codex, and Grok
on this machine. Locate each file, back it up, cut it under the
rules below, test the result, and report. Then produce the
deliverables.
</task>

<goal>
Leave each global file with only lines that are true in every
project and change the agent's behavior. Reason: global files load
into every session of every project, so each extra line costs
context and attention everywhere and can conflict with project
files.

The user read this prompt and chose to run it, so the cuts it calls
for are approved. Finish them in this run and record each judgment
call so the user can review it afterwards. Every line was written
for a purpose, so each cut line goes to a destination in the
report, and every file stays restorable from its backup.
</goal>

<hard_rules>
Apply every rule to every file and every line, not only the first
one.
1. Treat each line as a delete unless it passes the keep test.
   Reason: agents over-keep, and an unsure agent keeps a line unless
   deletion is the default.
2. Keep test: a line stays only when all five answers are yes.
   a. It is true in every project on this machine.
   b. It describes the user or the environment, not a project,
      language, or framework.
   c. The agent would not do it by default. Lines such as "be
      careful", "write clean code", and "follow best practices"
      fail here.
   d. You can finish this sentence with a specific, observable
      mistake: "Without this line, the agent would <action> in
      <situation>."
   e. It is concrete enough to verify.
   Reason: a line that cannot name its failure has no demonstrated
   value.
3. Treat these as reasons to cut: "uncertain", "might be useful",
   "harmless", "the user wrote it", "it is one line". Reason: these
   are the rationalizations that produce bloat.
4. Cut at least half the lines of each file and finish at 25 lines
   or fewer. If a file is already shorter, cut every line that
   fails the test and say so. Reason: a quota overrides the habit
   of keeping.
5. Treat a wrong cut as cheap and bloat as costly. Every file is
   backed up, a restore takes one command, and a cut line returns
   only on evidence (rule 8). Reason: agents play safe by keeping
   lines, yet keeping lines is the choice that degrades results.
6. Run an adversarial second pass: for each surviving line, write
   the strongest argument for deleting it, and keep the line only
   when that argument fails against a named failure. Reason: the
   first pass is biased toward keeping.
7. Give each cut line one destination: delete, a named project's
   instruction file, a skill, or a hook or permission rule. List
   moved lines in the report and edit no project files. Reason:
   project knowledge belongs with the project.
8. Test cuts by behavior. For each category of removed lines
   (style, workflow, tools, safety), start one fresh
   non-interactive session with the slim file (claude -p, codex
   exec, or the Grok equivalent) and run a probe task that the
   removed lines governed. Restore a line only when the probe shows
   the failure the line prevented, and record that output. When no
   fresh session can start, restore nothing and mark the cuts
   "untested". Reason: evidence decides what returns, not caution.
9. Back up every file before editing, to
   ~/instruction-backups/<YYYY-MM-DD>/<tool>/, outside every tool's
   config directory so no tool loads the backup. Confirm the backup
   with diff before editing. Reason: the backup makes rule 5 true.
10. Place a line in one file only when a tool reads another tool's
    file for compatibility (Grok reads CLAUDE.md). Check what each
    tool loads before deciding. Reason: duplicated lines double the
    cost.
11. Keep every backup. Edit only the three global files, and write
    only to the backup directory. Remove any secret found in a
    file, and report its file, line, and kind with the value
    redacted. Reason: backups make every cut reversible, and a
    report is read by more people than the file was.
12. Report a check as passed only after running it. Reason: an
    unrun check is a guess.
13. Make every judgment call yourself and keep working. When this
    prompt leaves a choice open, decide from these sources, in
    order: (a) this prompt's explicit requirements; (b) the reason
    on the closest rule, which names what that rule protects;
    (c) each tool's own report of what it loads, and its
    documentation; (d) the option easiest to undo. Record each call
    under Decisions. Reason: the user approved this prompt by
    running it and reviews decisions after the run, and these
    sources already answer what a mid-run question would ask.
</hard_rules>

<locations>
List paths to find each file, and use only files that exist.
- Claude: ~/.claude/CLAUDE.md and ~/.claude/rules/*.md.
- Codex: ~/.codex/AGENTS.override.md (it wins when present), else
  ~/.codex/AGENTS.md. CODEX_HOME may relocate the directory.
- Grok: ~/.grok/GROK.md, ~/.grok/AGENTS.md, ~/.grok/rules/, and any
  file the tool reports loading. Grok clients differ, so trust the
  tool's own report over this list.
Confirm what each tool loads: /context in Claude Code, and for Codex
and Grok a prompt asking the tool to list the instruction files it
loaded. Report "not found" for a missing tool and create no file.
</locations>

<examples>
<example>
Line: "Always write clean, readable code."
Decision: cut. It is default behavior (fails c) and names no
failure (fails d).
</example>
<example>
Line: "Use pnpm, not npm."
Decision: cut from the global file. It is project-specific (fails
a, b). Destination: the instruction file of the project that uses
pnpm.
</example>
<example>
Line: "Ask before deleting files."
Decision: keep. Without this line, the agent would run rm on user
files during a task that only asked for cleanup advice. It passes
all five tests.
</example>
<example>
Line: "Reply in short sentences with no preamble."
Decision: keep only if the adversarial pass cannot defeat it:
without this line, the agent would open each reply with a summary of
the request. If the probe shows no difference, cut it.
</example>
</examples>

<decision_examples>
How hard rule 13 settles open points. The file facts are
illustrative; take real ones from this machine.
<example>
Open point: Codex has both ~/.codex/AGENTS.override.md and
~/.codex/AGENTS.md.
Evidence: <locations> says the override wins when present, and
Codex's loaded-files answer names only the override.
Choice: slim the override, keep AGENTS.md as it is, and list it in
the report as not loaded.
Undo: restore the override from its backup.
</example>
<example>
Open point: a line in ~/.claude/CLAUDE.md names a repository path,
"In ~/work/billing, run make seed before tests".
Evidence: it fails keep tests a and b.
Choice: cut it, with destination: the billing project's CLAUDE.md.
Leave that project file as it is.
Undo: restore the line from the backup.
</example>
<example>
Open point: Grok is installed, but its client reports no
instruction file at all.
Evidence: the loaded-files prompt answers "none".
Choice: report Grok as "no file loaded" and create no file.
Undo: nothing to undo.
</example>
</decision_examples>

<verification>
1. Run wc -l on each final file and confirm 25 or fewer, or state
   the exemption.
2. Run diff between each backup and its original and confirm they
   are identical.
3. Confirm every kept line has its failure sentence in the report.
4. Run the rule 8 probes and print their output.
5. Confirm each tool still loads its file: /context for Claude, and
   the loaded-files prompt for Codex and Grok.
Report the actual output of each check. If you cannot run a check,
say so.
</verification>

<not_included>
New rules, new global files, edits to project files, merging the
three files into one, and installing tools.
</not_included>

<deliverables>
Done when every file meets this prompt and the verification results
are reported. Keep working until then, making each judgment call
under hard rule 13. Then stop and report, in this order:
1. Per file: line counts before and after, and the final text.
2. Per kept line: "Without this line, the agent would ... in ...".
3. Per cut line: the line, the reason for the cut, and its
   destination.
4. Probe results: category, probe prompt, outcome, and any restored
   line with its failure output.
5. Backup paths and one restore command per file.
6. The cuts marked "untested".
7. Decisions: a table of open point | evidence | choice | how to
   undo.
8. Possible improvements beyond this prompt, one line each.
</deliverables>
```

## Usage

Paste into Claude Code on the machine whose global instruction files need trimming.
The session needs shell access and permission to edit those files and create backups.
Missing tools and unavailable fresh-session probes must be reported as specified.
Draft: review the research log's unresolved assumptions before execution.

## Provenance

[Research log](../research/slim-global-instruction-files-log.md)
