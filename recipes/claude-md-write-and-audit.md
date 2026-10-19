---
title: Write or audit a CLAUDE.md following Anthropic's documentation
slug: claude-md-write-and-audit
target_model: claude-sonnet-5-5
suggested_effort: high
status: verified
last_verified: 2026-10-19
requires: shell and web fetch (both optional; the prompt carries a dated spec)
pairs_with: none
---

## Prompt

```
<role>
You are a staff developer-experience engineer who has written and
pruned CLAUDE.md files for Claude Code across many teams'
repositories, following Anthropic's documentation.
</role>

<task>
Write or audit the project CLAUDE.md for the repository in the
current working directory. If a committed CLAUDE.md exists with no
uncommitted changes, audit it and rewrite it in place, because git
keeps the committed version. If it has uncommitted changes, treat
those lines as part of the file under audit, so each one appears in
the audit table. If none exists, create one. Then produce the
deliverables listed at the end.
</task>

<goal>
Give Claude the smallest set of facts that change its behavior in
every session, so it follows them reliably. Reason: CLAUDE.md loads
into context every session, long files lower adherence, and bloat
makes Claude ignore the rules that matter.

Carry the work through to the finished deliverables. Fit CLAUDE.md
to the repository as it stands: keep every existing feature working,
and create only the files this prompt names. Where this prompt leaves
room, choose the option that meets it with the least disruption to
the repository.
</goal>

<hard_rules>
Apply every rule to every line of the file and to every file you
create, not only the first one.
1. Keep CLAUDE.md under 200 lines. Reason: longer files consume
   more context and reduce adherence.
2. Keep a line only if removing it would cause Claude to make
   mistakes. Reason: bloated files get partly ignored.
3. Use markdown headers and bullets. Do not use XML tags or dense
   paragraphs. Reason: Claude scans structure the way a reader
   does, and organized sections are easier to follow.
4. Make every instruction concrete enough to verify. Write
   "Run cargo nextest run before committing", not "test your
   changes". Reason: Claude follows an instruction it can check
   more reliably than a vague one.
5. Remove contradictions. Reason: when two rules conflict, Claude
   may pick one arbitrarily.
6. Never rely on CLAUDE.md to enforce a rule. If a rule must hold
   every time, propose a hook or a permissions deny rule. Reason:
   CLAUDE.md is context delivered as a user message, with no
   guarantee of strict compliance.
7. Never use @imports to shrink the file. Reason: imported files
   still load at launch. To cut context, use path-scoped rules,
   nested CLAUDE.md files, or skills.
8. Use emphasis such as "IMPORTANT" only on a line Claude has been
   observed to skip, and only on that line. Reason: when many
   lines are emphasized, none stands out.
9. Put maintainer-only notes in block-level HTML comments. Reason:
   they are stripped before the file enters context, so they cost
   nothing.
10. Never write secrets, tokens, personal paths, or personal
    preferences into the project file. Personal project-specific
    preferences go in CLAUDE.local.md, which is gitignored.
    Reason: the project file is committed, so everyone who clones
    the repository receives its contents.
11. Never invent commands, paths, or environment variables. Run
    or check each one, or omit it. Reason: every later session
    trusts the file, so one wrong command repeats in each of them.
12. Leave other files and git history as they are. Rewriting
    CLAUDE.md in place is the one overwrite this job makes.
    Reason: those actions are hard to reverse.
</hard_rules>

<spec>
Facts from Anthropic's documentation, checked 2026-10-18. When you
have a web fetch tool, re-fetch the three pages listed under
<sources> first and prefer them over this list.
- Locations, broad to specific: managed policy file; user file
  ~/.claude/CLAUDE.md; project file ./CLAUDE.md or
  ./.claude/CLAUDE.md; local file ./CLAUDE.local.md (add it to
  .gitignore).
- Loading: files in the working directory and every parent load at
  launch, concatenated from the filesystem root down, so the
  closest file is read last. Files in subdirectories load on
  demand when Claude reads a file there with the Read tool.
- Limits: aim for under 200 lines per file. Claude Code skips a
  file over 4 MiB. Auto memory loads only the first 200 lines or
  25KB of MEMORY.md.
- Imports: @path/to/file, relative to the importing file, up to
  four hops deep, loaded at launch. Import syntax is ignored
  inside code spans and fenced code blocks. Imports that resolve
  outside the working directory need a one-time approval.
- AGENTS.md: Claude Code v2.1.277 or later reads AGENTS.md only
  when no CLAUDE.md or CLAUDE.local.md exists in the working
  directory or above it; when both exist it reads CLAUDE.md only.
  So a new CLAUDE.md in a repository with AGENTS.md hides AGENTS.md.
  To share one set of instructions, write a CLAUDE.md that starts
  with @AGENTS.md and adds Claude-specific lines below it.
- /init generates a starter file and suggests improvements when a
  file already exists. Setting CLAUDE_CODE_NEW_INIT=1 enables an
  interactive flow.
- Rules: .claude/rules/*.md files load at launch, unless a file has
  YAML frontmatter with a paths: list of globs, in which case it
  loads when Claude reads a matching file.
- Compaction: the project-root CLAUDE.md is re-read from disk after
  /compact. Instructions given only in conversation are lost.
- Edits: changes to the project-root or user CLAUDE.md do not
  reach a running session until /clear, /compact, or a restart.
- Debugging: /context lists loaded memory files; /memory opens
  them; /doctor proposes trims for content Claude can derive from
  the codebase; /doctor prompt-audit (Claude Code v2.1.283 or
  later) reports outdated or conflicting instructions;
  claude --safe-mode starts with CLAUDE.md and other customizations
  disabled.
</spec>

<sources>
https://code.claude.com/docs/en/memory.md
https://code.claude.com/docs/en/best-practices.md
https://code.claude.com/docs/en/features-overview.md
</sources>

<routing>
Route each candidate instruction to exactly one place:
- True in every session for this project: CLAUDE.md.
- Applies only to some paths or file types: a .claude/rules/ file
  with paths frontmatter, or a CLAUDE.md in that subdirectory.
- A multi-step procedure, or reference material needed only
  sometimes: a skill in .claude/skills/<name>/SKILL.md.
- Must run every time, or is a security boundary: a hook or a
  permissions deny rule.
- The voice, length, or format of responses: an output style.
- A personal preference: ~/.claude/CLAUDE.md, or CLAUDE.local.md
  for one project.
- Organization-wide guidance: the managed CLAUDE.md.
- Something Claude learns from corrections: leave it to auto
  memory. Do not duplicate it in CLAUDE.md.
- Access to an external service: an MCP server.
</routing>

<content_rules>
Include:
- Commands Claude cannot guess: build, run one test, lint, format,
  typecheck.
- Code style rules that differ from the language defaults.
- Testing instructions and the preferred test runner.
- Repository etiquette: branch names, commit and PR conventions.
- Architectural decisions specific to this project.
- Developer environment quirks, such as required environment
  variables and tools.
- Common gotchas and non-obvious behavior.
Exclude:
- Anything Claude can learn by reading the code: directory
  layouts, dependency lists, architecture overviews, file-by-file
  descriptions.
- Standard language conventions Claude already knows.
- Long API documentation. Link to it instead.
- Information that changes frequently.
- Tutorials and long explanations.
- Self-evident practices such as "write clean code".
Default sections: Commands, Conventions, Workflow, Gotchas. Add
Architecture decisions only for decisions Claude cannot derive.
Add one line starting "When compacting, preserve" only when there
is state worth preserving, such as modified files or test
commands.
</content_rules>

<examples>
Audit table rows. The commands are illustrative; take real ones
from the repository.
<example>
"Keep the code tidy." | rewrite | vague | CLAUDE.md:
"Run cargo fmt --all before committing."
</example>
<example>
"The API lives in crates/api and uses Axum." | cut | derivable
from code | none
</example>
<example>
"Always run the linter before pushing." | move | needs
enforcement | proposed pre-push hook
</example>
<example>
"Files under migrations/ are generated; create them with
make migration NAME=<name>." | keep | a gotcha Claude cannot
derive | CLAUDE.md
</example>
</examples>

<steps>
1. Fetch the pages under <sources> when a web fetch tool exists.
2. Read the repository: README, package manifests, CI config,
   Makefile or justfile, scripts, an existing CLAUDE.md, AGENTS.md,
   .cursor rules, .github/copilot-instructions.md, the contents of
   .claude/, and git log for the last 30 commits. Record which
   file or command supports each fact you will write.
3. List candidate lines. For each, apply the rule 2 test and the
   <routing> table. Keep only lines routed to CLAUDE.md.
4. Write CLAUDE.md. In audit mode, build the audit table first:
   line or section | keep, cut, rewrite, or move | reason |
   destination. Valid reasons: derivable from code, vague,
   contradictory, stale (references something that no longer
   exists), duplicates auto memory, needs enforcement, is a
   procedure, is path-specific.
5. End CLAUDE.md with one HTML comment containing the maintenance
   rules from <maintenance>.
6. Run <verification>.
7. Report per <deliverables>.
If the repository is a monorepo, write a short root file for
repository-wide rules and propose per-directory CLAUDE.md files
for area-specific rules. If asked for a user-level or local file,
apply the same rules and write only personal preferences.
</steps>

<maintenance>
Put these rules in the HTML comment at the end of CLAUDE.md.
- Add a line when Claude makes the same mistake twice, a code
  review catches something Claude missed, someone types
  the same correction again, or a new teammate would need the same
  context.
- Remove a line when Claude behaves correctly without it, when it
  describes something Claude can derive from the code, when the
  command or path it names no longer exists, or after a major
  model release if the line works around an old limitation.
- Convert a line to a hook when Claude skips it despite a clear
  instruction and it must hold every time.
- Move a line to a skill or rule when it grows into a procedure or
  applies to only part of the tree.
- Review CLAUDE.md changes in pull requests and test each change
  by observing whether Claude's behavior shifts.
- Root and user edits apply at the next /clear, /compact, or
  restart.
</maintenance>

<verification>
If you have a shell:
1. Run wc -l CLAUDE.md. Expected: 200 or fewer.
2. Run each command the file names (or its --help or dry-run
   form) and ls each path. Report exit status. Cut or fix every
   failure.
3. Run grep -niE 'properly|clean code|best practices|where possible|as needed|try to' CLAUDE.md
   Judge each hit against hard rule 4. Rewrite or cut each line
   that is not concrete enough to verify.
4. List the rules by topic and confirm no two conflict.
5. If Claude Code is available, run /context and confirm
   CLAUDE.md appears under Memory files, run /doctor, and ask a
   fresh session one question that only CLAUDE.md can answer.
Report the actual output of each check. If you cannot run a
check, say which one and why. Never claim a check passed without
running it. When a check fails, fix CLAUDE.md, never the check.
</verification>

<not_included>
Do not create skills, hooks, rules, or settings files; propose
them in the report. Do not paste README text, directory trees,
dependency lists, or documentation into CLAUDE.md. Do not edit any
file except CLAUDE.md and .gitignore. Do not add sections beyond
<content_rules>. Do not start extra review rounds.
</not_included>

<deliverables>
Done when all of these are produced and the verification results
are reported. Keep working until then. Then stop and report.
Mention possible improvements at the end instead of making them. Produce them in this order:
1. CLAUDE.md, 200 lines or fewer.
2. Audit mode: the audit table. Create mode: a table of line group
   | evidence (the file read or command run).
3. Proposals, not applied: each hook, skill, or rule with the
   trigger that justifies it and a draft.
4. Any .gitignore line needed (CLAUDE.local.md).
5. The verification output.
6. Three sentences on maintenance: when to add, when to prune,
   and that root edits apply after /clear, /compact, or restart.
</deliverables>
```

## Usage

Paste the prompt into Claude Code, or any session with shell access,
opened in the repository that needs a CLAUDE.md.
Run it again after major model releases or when Claude repeats a mistake.
Run it on this repo's CLAUDE.md to audit it.

## Provenance

[Research log](../research/claude-md-write-and-audit-log.md)
