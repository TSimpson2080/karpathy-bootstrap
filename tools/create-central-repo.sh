#!/usr/bin/env bash
# One-time: publish this folder as your source-of-truth repo and tag it v1.
# Run from the karpathy-bootstrap folder root. Requires: gh (authenticated), git.
set -euo pipefail
ME="$(gh api user --jq .login)"

[ -d .git ] || { git init -q; git add -A; git -c user.email=you@local -c user.name=you commit -q -m "Karpathy Method v1"; }

gh repo create "$ME/karpathy-bootstrap" --private --source=. --remote=origin --push \
  -d "Canonical AI operating instructions (Karpathy Method)"

git tag -f v1
git push -f origin v1

echo ""
echo "Created $ME/karpathy-bootstrap and tagged v1."
echo "IMPORTANT if your repos are PRIVATE: in that repo, open"
echo "  Settings > Actions > General > Access >"
echo "  'Accessible from repositories owned by $ME'"
echo "so other private repos can call the reusable workflow."
echo "Also mark it a Template repository (Settings > check 'Template repository')"
echo "so new repos can be created pre-wired."
