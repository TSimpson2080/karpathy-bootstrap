#!/usr/bin/env bash
# Print a paste-ready planning brief for a repo: the canonical PLANNER.md plus
# that repo's current PROJECT_SPEC.md and VERIFICATION.md, straight from its
# default branch. Paste the whole output into your ChatGPT/Claude planning
# session before you plan work, so the planner runs inside the method and is
# grounded in this repo's real spec + verification commands.
#
# Requires: gh (authenticated).
#   tools/planner-brief.sh owner/repo
#   tools/planner-brief.sh owner/repo | pbcopy      # macOS: straight to clipboard
set -euo pipefail
repo="${1:-}"
[ -n "$repo" ] || { echo "Usage: $0 <owner/repo>" >&2; exit 1; }

fetch(){ gh api -H "Accept: application/vnd.github.raw" "repos/$repo/contents/$1" 2>/dev/null; }

echo "# PLANNING BRIEF — $repo"
echo "# Paste this entire block into your planning session before planning work."
echo "# You are the PLANNER. Follow the operating instructions, then plan against the two repo docs."
echo
for f in docs/ai/PLANNER.md docs/ai/PROJECT_SPEC.md docs/ai/VERIFICATION.md; do
  echo "========================================"
  echo "===== $repo : $f"
  echo "========================================"
  if ! fetch "$f"; then
    echo "(could not fetch $f — is the Karpathy kit merged into $repo's default branch yet?)"
  fi
  echo
done
