#!/usr/bin/env bash
# scripts/changelog-generate.sh - Generate CHANGELOG entries from git commits
# Usage: ./scripts/changelog-generate.sh [SINCE_TAG]
#   SINCE_TAG: git tag to start from (default: latest tag or all commits)
#
# Supported commit formats:
#   Custom:       [TYPE] - description
#   Conventional: type: description  OR  type(scope): description
#
# Mapping to Keep a Changelog sections:
#   Added:   feat, feature, add, init, ADD, FEATURE, INIT
#   Fixed:   fix, bugfix, FIX, BUGFIX
#   Changed: refactor, perf, build, style, docs, chore, ci, test, lint, rule,
#            REFACTOR, STYLE, DOCS, CHORE, CI, TEST, LINT, RULE, UPD
#   Removed: revert

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
    feat|feature|add|init|ADD|FEATURE|INIT)
      echo "Added" ;;
    fix|bugfix|FIX|BUGFIX)
      echo "Fixed" ;;
    refactor|perf|build|style|docs|REFACTOR|STYLE|DOCS|UPD)
      echo "Changed" ;;
    chore|ci|test|lint|rule|CHORE|CI|TEST|LINT|RULE)
      echo "Changed" ;;
    revert)
      echo "Removed" ;;
    *)
      echo "" ;;
  esac
}

# Use temp files per section instead of associative arrays (bash 3 compat)
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Read git log and write entries into per-section temp files
while IFS= read -r line; do
  [ -z "$line" ] && continue

  type=""
  msg=""

  if [[ "$line" =~ ^([a-zA-Z]+)(\(.+\))?:\ (.+)$ ]]; then
    type="${BASH_REMATCH[1]}"
    msg="${BASH_REMATCH[3]}"
  elif [[ "$line" =~ ^\[([A-Z]+)\]\ -\ (.+)$ ]]; then
    type="${BASH_REMATCH[1]}"
    msg="${BASH_REMATCH[2]}"
  else
    continue
  fi

  section=$(map_type_to_section "$type")
  [ -z "$section" ] && continue

  # Capitalize first letter
  msg="$(echo "${msg:0:1}" | tr '[:lower:]' '[:upper:]')${msg:1}"

  echo "- ${msg}" >> "${TMP_DIR}/${section}.txt"
done < <(git log ${RANGE:+"$RANGE"} --pretty=format:"%s" --no-merges)

# Check if anything was collected
found=0
for section in Added Changed Deprecated Removed Fixed Security; do
  [ -f "${TMP_DIR}/${section}.txt" ] && found=1 && break
done

if [ "$found" -eq 0 ]; then
  echo "No conventional commits found since ${SINCE_TAG:-beginning}."
  exit 0
fi

# Insert entries into CHANGELOG using the entry script
for section in Added Changed Deprecated Removed Fixed Security; do
  if [ -f "${TMP_DIR}/${section}.txt" ]; then
    while IFS= read -r entry; do
      entry_msg="${entry#- }"
      "$SCRIPT_DIR/changelog-entry.sh" "$section" "$entry_msg"
    done < "${TMP_DIR}/${section}.txt"
  fi
done

echo ""
echo "Done. Review CHANGELOG.md and commit when ready."
