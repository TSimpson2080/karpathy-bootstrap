#!/usr/bin/env bash
# Karpathy Method setup gate.
# Fails if the kit was left half-configured or the guardrail copies drifted.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

# 1) The two customizable files must EXIST and contain no unfilled [Placeholder]
#    tokens. A missing file is a failure — not a silent pass.
#    The placeholder regex matches "[Word...]" but NOT markdown checkboxes "[ ]".
for f in docs/ai/PROJECT_SPEC.md docs/ai/VERIFICATION.md; do
  if [ ! -f "$root/$f" ]; then
    echo "FAIL: required file $f is missing (kit not configured for this repo)"
    fail=1
    continue
  fi
  if grep -nE '\[[A-Za-z][^]]*\]' "$root/$f" >/dev/null 2>&1; then
    echo "FAIL: unfilled placeholder(s) in $f:"
    grep -nE '\[[A-Za-z][^]]*\]' "$root/$f" | sed 's/^/    /'
    fail=1
  fi
done

# 2) The "Hard stops" LIST must match the canonical one in KARPATHY_METHOD.md
#    across every mirror (CLAUDE.md, AGENTS.md, docs/ai/PLANNER.md).
#    We compare only the bullet items — not the surrounding prose — so prettier
#    re-wrapping the paragraphs never causes a false failure, and the canonical
#    file is the single source of truth (not just "the mirrors agree").
hardstops() { awk '/^## /{p=0} /^## Hard stops/{p=1} p' "$1" | grep -E '^[-*] ' | sed -E 's/^[-*][[:space:]]+//; s/[[:space:]]+$//'; }
canon="docs/ai/KARPATHY_METHOD.md"
if [ -f "$root/$canon" ]; then
  for f in CLAUDE.md AGENTS.md docs/ai/PLANNER.md; do
    [ -f "$root/$f" ] || continue
    if ! diff <(hardstops "$root/$canon") <(hardstops "$root/$f") >/dev/null 2>&1; then
      echo "FAIL: 'Hard stops' list in $f differs from canonical $canon"
      fail=1
    fi
  done
else
  echo "FAIL: canonical $canon is missing (kit not installed correctly)"
  fail=1
fi

if [ "$fail" -ne 0 ]; then
  echo ""
  echo "Setup gate failed: fill placeholders and align guardrails before merging."
  exit 1
fi
echo "OK: no unfilled placeholders; guardrails consistent."
