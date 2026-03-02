#!/usr/bin/env bash
# scripts/changelog-generate.sh - Generate CHANGELOG entries from git commits
# Usage: ./scripts/changelog-generate.sh [SINCE_TAG]
#   SINCE_TAG: git tag to start from (default: latest tag or all commits)
#
# Supported commit formats (matching commit-msg hook):
#   Custom:       [TYPE] - description
#   Conventional: type: description  OR  type(scope): description
#
# Custom types:  ADD, CI, FEATURE, BUGFIX, FIX, INIT, DOCS, TEST, REFACTOR, STYLE, CHORE, LINT, RULE
# Conventional:  feat, fix, docs, style, refactor, test, chore, ci, build, perf, revert,
#                add, feature, bugfix, init, lint, rule
#
# Mapping to Keep a Changelog sections:
#   Added:      feat, feature, add, init, ADD, FEATURE, INIT
#   Fixed:      fix, bugfix, FIX, BUGFIX
#   Changed:    refactor, perf, build, style, docs, chore, ci, test, lint, rule,
#               REFACTOR, STYLE, DOCS, CHORE, CI, TEST, LINT, RULE, UPD
#   Removed:    revert

set -euo pipefail

CHANGELOG="CHANGELOG.md"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Determine the starting point
SINCE_TAG="${1:-}"
if [ -z "$SINCE_TAG" ]; then
  SINCE_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
fi

if [ -n "$SINCE_TAG" ]; then
  RANGE="${SINCE_TAG}..HEAD"
  echo "Generating changelog entries since ${SINCE_TAG}..."
else
  RANGE=""
  echo "Generating changelog entries from all commits..."
fi

# Map commit type to Keep a Changelog section
map_type_to_section() {
  local type="$1"
  case "$type" in
    # Added
    feat|feature|add|init|ADD|FEATURE|INIT)
      echo "Added"
      ;;
    # Fixed
    fix|bugfix|FIX|BUGFIX)
      echo "Fixed"
      ;;
    # Changed
    refactor|perf|build|style|docs|REFACTOR|STYLE|DOCS|UPD)
      echo "Changed"
      ;;
    chore|ci|test|lint|rule|CHORE|CI|TEST|LINT|RULE)
      echo "Changed"
      ;;
    # Removed
    revert)
      echo "Removed"
      ;;
    *)
      echo ""
      ;;
  esac
}

# Collect entries by section
declare -A SECTIONS

# Read git log
while IFS= read -r line; do
  [ -z "$line" ] && continue

  type=""
  msg=""

  # Match conventional commits: type(scope): description  OR  type: description
  if [[ "$line" =~ ^([a-zA-Z]+)(\(.+\))?:\ (.+)$ ]]; then
    type="${BASH_REMATCH[1]}"
    msg="${BASH_REMATCH[3]}"
  # Match [TYPE] - description format
  elif [[ "$line" =~ ^\[([A-Z]+)\]\ -\ (.+)$ ]]; then
    type="${BASH_REMATCH[1]}"
    msg="${BASH_REMATCH[2]}"
  else
    continue
  fi

  section=$(map_type_to_section "$type")
  [ -z "$section" ] && continue

  # Capitalize first letter of message
  msg="$(echo "${msg:0:1}" | tr '[:lower:]' '[:upper:]')${msg:1}"

  # Append to section
  if [ -n "${SECTIONS[$section]+x}" ]; then
    SECTIONS[$section]+=$'\n'"- ${msg}"
  else
    SECTIONS[$section]="- ${msg}"
  fi
done < <(git log ${RANGE:+"$RANGE"} --pretty=format:"%s" --no-merges)

# Check if we found anything
if [ ${#SECTIONS[@]} -eq 0 ]; then
  echo "No conventional commits found since ${SINCE_TAG:-beginning}."
  exit 0
fi

# Insert entries into CHANGELOG using the entry script
SECTION_ORDER="Added Changed Deprecated Removed Fixed Security"
for section in $SECTION_ORDER; do
  if [ -n "${SECTIONS[$section]+x}" ]; then
    while IFS= read -r entry; do
      # Strip the leading "- " for the script
      entry_msg="${entry#- }"
      "$SCRIPT_DIR/changelog-entry.sh" "$section" "$entry_msg"
    done <<< "${SECTIONS[$section]}"
  fi
done

echo ""
echo "Done. Review CHANGELOG.md and commit when ready."
