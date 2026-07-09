# AI Coding Agents — Repo Operating Instructions

Work in small, verifiable loops:

```text
spec -> inspect -> plan -> small change -> verify -> fix -> report
```

Start every task by running `bash scripts/agent-preflight.sh` — it prints this
repo's spec, the verification commands to run, and the hard stops, so the
"inspect" step is never skipped.

Read before changing code:

- `docs/ai/KARPATHY_METHOD.md` — the canonical process (full guardrails, report format, definition of done)
- `docs/ai/PROJECT_SPEC.md` — what this repo is and what must not change
- `docs/ai/VERIFICATION.md` — the source of truth for verification commands

Do not claim completion unless the relevant `VERIFICATION.md` commands passed, or
you state exactly which command you could not run and why. Run those commands;
do not invent them.

Tasks may arrive pre-specified in `docs/ai/TASK_TEMPLATE.md` shape from a planner
(ChatGPT/Claude). Treat that spec as your Spec step, but still inspect the repo to
confirm it — if the repo contradicts the plan, stop and say so in your report.

## Hard stops — require explicit human approval

Mirror of the canonical list in `docs/ai/KARPATHY_METHOD.md`, inlined because
this file is always loaded. CI fails if the two copies drift.

- core architecture
- database schema or migrations
- authentication or authorization behavior
- payment, tax, financial, health, legal, or compliance logic
- new dependencies
- deleting or weakening tests, validation, or security checks
- broad refactors
- public APIs
- deployment configuration
- product requirements

## Completion report

End every task with the completion report format defined in
`docs/ai/KARPATHY_METHOD.md`.
