#!/usr/bin/env bash
# PreToolUse hook for Bash: deny a git commit whose command adds Claude
# attribution trailers. The repo owner wants commits attributed only to them.
cmd=$(jq -r '.tool_input.command // empty')
case "$cmd" in
  *"git commit"*|*"git -C "*" commit"*) ;;
  *) exit 0 ;;
esac
# Match a trailer at the start of a message line, or given as its own -m or
# --trailer argument, so prose that only mentions one passes.
trailer='(Co-Authored-By:.*Claude|Claude-Session:)'
if printf '%s\n' "$cmd" | grep -qiE "^[[:space:]\"']*$trailer|(-m|--message|--trailer)[[:space:]=]*[\"']?$trailer"; then
  echo "Blocked: remove the Co-Authored-By: Claude and Claude-Session: lines; this repo does not use Claude attribution." >&2
  exit 2
fi
exit 0
