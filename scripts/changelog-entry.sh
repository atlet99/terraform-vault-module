#!/usr/bin/env bash
# scripts/changelog-entry.sh - Add an entry to CHANGELOG.md under [Unreleased]
# Usage: ./scripts/changelog-entry.sh <SECTION> <MESSAGE>
#   SECTION: Added | Changed | Deprecated | Removed | Fixed | Security
#   MESSAGE: The changelog entry text

set -euo pipefail

CHANGELOG="CHANGELOG.md"
SECTION="${1:?ERROR: SECTION is required (Added|Changed|Deprecated|Removed|Fixed|Security)}"
MSG="${2:?ERROR: MSG is required}"

VALID_SECTIONS="Added Changed Deprecated Removed Fixed Security"
if ! echo "$VALID_SECTIONS" | grep -qw "$SECTION"; then
  echo "ERROR: Invalid section '$SECTION'. Must be one of: $VALID_SECTIONS"
  exit 1
fi

if [ ! -f "$CHANGELOG" ]; then
  echo "ERROR: $CHANGELOG not found"
  exit 1
fi

# Use awk to insert the entry under the correct section within [Unreleased] only
awk -v section="$SECTION" -v msg="$MSG" '
BEGIN {
  in_unreleased = 0
  section_found = 0
  inserted = 0
}
# Detect [Unreleased] heading
/^## \[Unreleased\]/ {
  in_unreleased = 1
  print
  next
}
# Detect next version heading -> stop looking
in_unreleased && /^## \[/ {
  # If we never found our section, insert it now before this line
  if (!inserted) {
    print ""
    print "### " section
    print ""
    print "- " msg
    inserted = 1
  }
  in_unreleased = 0
  print
  next
}
# Found our section heading inside [Unreleased]
in_unreleased && $0 == "### " section {
  section_found = 1
  print
  next
}
# Insert entry right after the section heading (first blank or bullet line)
in_unreleased && section_found && !inserted {
  # If next line is empty, print entry after it
  if ($0 == "") {
    print ""
    print "- " msg
    inserted = 1
    next
  }
  # If next line is already a bullet, insert before it
  if ($0 ~ /^- /) {
    print "- " msg
    inserted = 1
    print
    next
  }
}
{ print }
END {
  # Edge case: [Unreleased] is the last section and we did not insert yet
  if (!inserted) {
    print ""
    print "### " section
    print ""
    print "- " msg
  }
}
' "$CHANGELOG" > "${CHANGELOG}.tmp" && mv "${CHANGELOG}.tmp" "$CHANGELOG"

echo "Added to [Unreleased] -> $SECTION: $MSG"
