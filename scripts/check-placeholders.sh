#!/usr/bin/env bash
# Karpathy Method setup gate.
# Fails if the kit was left half-configured or the guardrail copies drifted.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

# 1) No unfilled [Placeholder] tokens in the two files that MUST be customized.
#    Matches "[Word...]" but NOT markdown checkboxes "[ ]".
for f in docs/ai/PROJECT_SPEC.md docs/ai/VERIFICATION.md; do
  if grep -nE '\[[A-Za-z][^]]*\]' "$root/$f" >/dev/null 2>&1; then
    echo "FAIL: unfilled placeholder(s) in $f:"
    grep -nE '\[[A-Za-z][^]]*\]' "$root/$f" | sed 's/^/    /'
    fail=1
  fi
done

# 2) The "Hard stops" block must be identical in CLAUDE.md and AGENTS.md.
extract() { awk '/^## /{p=0} /^## Hard stops/{p=1} p' "$1"; }
if ! diff <(extract "$root/CLAUDE.md") <(extract "$root/AGENTS.md") >/dev/null 2>&1; then
  echo "FAIL: 'Hard stops' section differs between CLAUDE.md and AGENTS.md"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  echo ""
  echo "Setup gate failed: fill placeholders and align guardrails before merging."
  exit 1
fi
echo "OK: no unfilled placeholders; guardrails consistent."
