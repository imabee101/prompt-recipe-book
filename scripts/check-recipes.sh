#!/usr/bin/env bash
# Checks CLAUDE.md, every recipe, every research log, and source IDs.
# Prints one line per problem and exits 1 if any. Prints nothing and
# exits 0 when clean. Run from anywhere.
set -u
cd "$(dirname "$0")/.." || exit 2

problems=0
fail() {
  printf '%s\n' "$1"
  problems=$((problems + 1))
}

# CLAUDE.md size (Anthropic's target is under 200 lines per file).
lines=$(wc -l < CLAUDE.md | tr -d ' ')
[ "$lines" -le 200 ] || fail "CLAUDE.md: $lines lines (max 200)"

# Required files.
for req in sources.md templates/recipe.md templates/research-log.md \
  .claude/skills/new-recipe/SKILL.md \
  .claude/skills/new-recipe/references/research-method.md \
  .claude/skills/new-recipe/references/prompt-writing-rules.md; do
  [ -f "$req" ] || fail "missing required file: $req"
done

keys="title slug target_model suggested_effort status last_verified requires pairs_with"
tags="role task goal hard_rules verification not_included deliverables"

for f in recipes/*.md; do
  slug=$(basename "$f" .md)

  # Front matter.
  if [ "$(head -1 "$f")" != "---" ]; then
    fail "$f: missing front matter"
    continue
  fi
  fm=$(awk 'NR == 1 { next } /^---$/ { exit } { print }' "$f")
  for k in $keys; do
    printf '%s\n' "$fm" | grep -q "^$k:" || fail "$f: missing front matter key $k"
  done
  printf '%s\n' "$fm" | grep -q "^slug: $slug\$" || fail "$f: slug does not match file name"
  printf '%s\n' "$fm" | grep -Eq '^status: (draft|verified|stale)$' ||
    fail "$f: status must be draft, verified, or stale"
  printf '%s\n' "$fm" | grep -Eq '^last_verified: [0-9]{4}-[0-9]{2}-[0-9]{2}$' ||
    fail "$f: last_verified must be YYYY-MM-DD"

  # Sections and the single prompt block.
  for h in '## Prompt' '## Usage' '## Provenance'; do
    grep -q "^$h\$" "$f" || fail "$f: missing section $h"
  done
  fences=$(grep -c '^```' "$f")
  [ "$fences" -eq 2 ] || fail "$f: $fences code fence lines (need exactly 2)"

  # Required prompt tags and the stopping condition.
  for t in $tags; do
    grep -q "^<$t>" "$f" || fail "$f: missing <$t> tag"
  done
  grep -q 'Done when' "$f" || fail "$f: missing stopping condition 'Done when'"

  # Usage length.
  usage=$(awk '/^## Usage$/ { on = 1; next } /^## / { on = 0 } on && NF' "$f" | wc -l | tr -d ' ')
  [ "$usage" -le 5 ] || fail "$f: Usage has $usage lines (max 5)"

  # Research log and provenance link.
  log="research/$slug-log.md"
  [ -f "$log" ] || fail "$f: missing research log $log"
  grep -q "research/$slug-log.md" "$f" || fail "$f: Provenance does not link $log"
  if [ -f "$log" ]; then
    grep -q '^## Known gaps$' "$log" || fail "$log: missing '## Known gaps' section"
    grep -q '^## Findings$' "$log" || fail "$log: missing '## Findings' section"
  fi

  # Paired recipe exists.
  pair=$(printf '%s\n' "$fm" | sed -n 's/^pairs_with: *//p')
  if [ -n "$pair" ] && [ "$pair" != "none" ] && [ ! -f "recipes/$pair.md" ]; then
    fail "$f: pairs_with names missing recipe $pair"
  fi
done

# Every research log has a recipe.
for log in research/*-log.md; do
  slug=$(basename "$log" -log.md)
  [ -f "recipes/$slug.md" ] || fail "$log: no matching recipe recipes/$slug.md"
done

# Every source ID used is defined in sources.md.
for f in CLAUDE.md research/*.md .claude/skills/new-recipe/SKILL.md \
  .claude/skills/new-recipe/references/*.md; do
  for id in $(grep -o '\[[A-Z][0-9]\{1,2\}\]' "$f" | sort -u | tr -d '[]'); do
    grep -q "^- \[$id\]" sources.md || fail "$f: source ID $id is not defined in sources.md"
  done
done

[ "$problems" -eq 0 ] || exit 1
