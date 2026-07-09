#!/usr/bin/env bash
# Run at the START of every coding task. Prints this repo's spec + verification
# commands + hard stops, so the "inspect" step of the loop can't be skipped.
# Informational by default (exit 0); exits 2 if the kit isn't configured yet, so
# it can also be wired as a hard pre-task hook.
set -uo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"; cd "$root"
hr(){ printf '\n──────────────────────────────────────────\n%s\n──────────────────────────────────────────\n' "$1"; }
show(){ if [ -f "$1" ]; then cat "$1"; else echo "MISSING: $1"; fi; }

ver="$(grep -m1 '^Version:' docs/ai/KARPATHY_METHOD.md 2>/dev/null | sed 's/^Version:[[:space:]]*//')"
echo "Karpathy Method preflight — kit version ${ver:-UNKNOWN}"

rc=0
if out="$(bash scripts/check-placeholders.sh 2>&1)"; then
  echo "Kit configured for this repo: OK"
else
  echo "WARNING: kit not fully configured for this repo —"
  printf '%s\n' "$out" | sed 's/^/  /'
  rc=2
fi

hr "PROJECT_SPEC.md — what this repo is"; show docs/ai/PROJECT_SPEC.md
hr "VERIFICATION.md — how to prove work (run these; don't invent)"; show docs/ai/VERIFICATION.md
hr "HARD STOPS — need explicit approval before you cross them"
awk '/^## Hard stops/{p=1;next} /^## /{p=0} p' docs/ai/KARPATHY_METHOD.md 2>/dev/null || echo "MISSING: docs/ai/KARPATHY_METHOD.md"
hr "LOOP"
echo "spec -> inspect -> plan -> small change -> verify -> fix -> report"
echo "Do not claim completion without running the VERIFICATION commands above."
exit $rc
