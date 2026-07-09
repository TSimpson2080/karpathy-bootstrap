#!/usr/bin/env bash
# Require the karpathy check before merge on each repo's default branch.
# Run AFTER at least one PR has run once, so the check name exists.
# Requires: gh (authenticated). NOTE: protecting PRIVATE-repo branches needs GitHub Pro;
# public repos are free.
#
#   tools/karpathy-protect.sh owner/repo [owner/repo ...]
#   tools/karpathy-protect.sh --all
#
# Default required context is "karpathy / gate" (caller job "karpathy" -> reusable
# job "gate"). Confirm the exact name on a PR's Checks tab; override with CONTEXT=.
set -euo pipefail
CONTEXT="${CONTEXT:-karpathy / gate}"
ME="$(gh api user --jq .login)"

repos=()
if [ "${1:-}" = "--all" ]; then
  mapfile -t repos < <(gh repo list "$ME" --no-archived --source -L 500 --json nameWithOwner -q '.[].nameWithOwner')
else
  repos=("$@")
fi
[ ${#repos[@]} -gt 0 ] || { echo "Usage: $0 <owner/repo>... | --all"; exit 1; }

for repo in "${repos[@]}"; do
  branch="$(gh repo view "$repo" --json defaultBranchRef -q .defaultBranchRef.name)"
  echo "=== $repo ($branch) require: $CONTEXT ==="
  if gh api -X PUT "repos/$repo/branches/$branch/protection" \
      -H "Accept: application/vnd.github+json" --input - >/dev/null <<JSON
{
  "required_status_checks": { "strict": true, "contexts": ["$CONTEXT"] },
  "enforce_admins": false,
  "required_pull_request_reviews": null,
  "restrictions": null
}
JSON
  then echo "  protected"; else echo "  FAILED (private repos need GitHub Pro; verify the check name and your permissions)"; fi
done
