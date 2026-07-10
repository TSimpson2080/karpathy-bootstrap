#!/usr/bin/env bash
# Backfill the Karpathy Method into repos by opening a PR in each.
# Requires: gh (authenticated), git. Run from the karpathy-bootstrap folder root.
#
#   tools/karpathy-sync.sh owner/repo [owner/repo ...]   # named repos
#   tools/karpathy-sync.sh --all                         # all your source repos
#   DRY_RUN=1 tools/karpathy-sync.sh --all               # show what it would do
#
# Canonical files are overwritten (they should track the source of truth).
# PROJECT_SPEC.md and VERIFICATION.md are added ONLY if absent, so real content
# you've already filled in is never clobbered.
set -euo pipefail
KIT_REF="${KIT_REF:-v1}"
BRANCH="chore/karpathy-method"
SRC="$(cd "$(dirname "$0")/.." && pwd)"
ME="$(gh api user --jq .login)"

repos=()
if [ "${1:-}" = "--all" ]; then
  repos=( $(gh repo list "$ME" --no-archived --source -L 500 --json nameWithOwner -q '.[].nameWithOwner') )
else
  repos=("$@")
fi
[ ${#repos[@]} -gt 0 ] || { echo "Usage: $0 <owner/repo>... | --all"; exit 1; }

tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
for repo in "${repos[@]}"; do
  echo "=== $repo ==="
  if [ "$repo" = "$ME/karpathy-bootstrap" ]; then echo "  skip: source-of-truth repo (never syncs into itself)"; continue; fi
  if [ -n "${DRY_RUN:-}" ]; then echo "  would add/refresh kit and open PR on '$BRANCH'"; continue; fi
  dir="$tmp/$(basename "$repo")"
  gh repo clone "$repo" "$dir" -- -q
  git -C "$dir" checkout -q -B "$BRANCH"
  mkdir -p "$dir/docs/ai" "$dir/scripts" "$dir/.github/workflows"
  cp "$SRC/CLAUDE.md" "$SRC/AGENTS.md" "$dir/"
  cp "$SRC/docs/ai/KARPATHY_METHOD.md" "$SRC/docs/ai/TASK_TEMPLATE.md" "$SRC/docs/ai/PLANNER.md" "$dir/docs/ai/"
  cp "$SRC/scripts/check-placeholders.sh" "$SRC/scripts/agent-preflight.sh" "$dir/scripts/"; chmod +x "$dir"/scripts/*.sh
  cp "$SRC/.github/pull_request_template.md" "$dir/.github/"
  [ -f "$dir/docs/ai/PROJECT_SPEC.md" ] || cp "$SRC/docs/ai/PROJECT_SPEC.md" "$dir/docs/ai/"
  [ -f "$dir/docs/ai/VERIFICATION.md" ] || cp "$SRC/docs/ai/VERIFICATION.md" "$dir/docs/ai/"
  sed "s/USERNAME/$ME/g; s|@v1|@$KIT_REF|" "$SRC/templates/consumer-verify.yml" > "$dir/.github/workflows/verify.yml"
  # Keep the vendored governance files out of the repo's prettier/format checks,
  # so a repo's own style rules never make the kit PR un-mergeable. Idempotent.
  ig="$dir/.prettierignore"
  if ! grep -q 'Karpathy Method (vendored)' "$ig" 2>/dev/null; then
    printf '\n# Karpathy Method (vendored) — not subject to this repo formatting\nCLAUDE.md\nAGENTS.md\ndocs/ai/\nscripts/check-placeholders.sh\nscripts/agent-preflight.sh\n.github/workflows/verify.yml\n' >> "$ig"
  fi
  git -C "$dir" add -A
  if git -C "$dir" diff --cached --quiet; then echo "  already up to date"; continue; fi
  git -C "$dir" commit -q -m "chore: adopt Karpathy Method ($KIT_REF)"
  git -C "$dir" push -q -u origin "$BRANCH" --force-with-lease
  gh pr create --repo "$repo" --head "$BRANCH" --base "$(gh repo view "$repo" --json defaultBranchRef -q .defaultBranchRef.name)" \
    --title "Adopt Karpathy Method ($KIT_REF)" \
    --body "Adds canonical AI operating instructions + CI gate wired to $ME/karpathy-bootstrap@$KIT_REF.

Next in this repo: fill docs/ai/PROJECT_SPEC.md and docs/ai/VERIFICATION.md (CI fails until placeholders are gone), then uncomment the real verify job." \
    2>/dev/null || echo "  PR already open for $BRANCH"
  echo "  PR opened."
done
echo "Done. Review, fill the two docs per repo, and merge."
