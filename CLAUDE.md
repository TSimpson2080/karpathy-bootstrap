# Claude Code — Repo Operating Instructions

Work in small, verifiable loops:

```text
spec -> inspect -> plan -> small change -> verify -> fix -> report
```

Read before changing code:

- `docs/ai/KARPATHY_METHOD.md` — the canonical process (full guardrails, report format, definition of done)
- `docs/ai/PROJECT_SPEC.md` — what this repo is and what must not change
- `docs/ai/VERIFICATION.md` — the source of truth for verification commands

Do not claim completion unless the relevant `VERIFICATION.md` commands passed, or
you state exactly which command you could not run and why. Run those commands;
do not invent them.

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
