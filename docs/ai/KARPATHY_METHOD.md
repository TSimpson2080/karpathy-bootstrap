# Karpathy Method

Version: 1.0

Canonical source for this repo's AI workflow. `CLAUDE.md` and `AGENTS.md` point
here and MUST NOT duplicate this content — only the short "Hard stops" list is
mirrored into them (because those files are always loaded), and CI keeps the two
copies identical.

This repository uses a spec-driven, verification-first AI development workflow.
Every task goes through one small loop:

```text
Spec -> inspect -> plan -> small change -> verify -> fix -> report
```

## Core rule

Do not make code changes until you understand:

1. what behavior should change;
2. where that behavior lives in the repo;
3. how the change will be verified; and
4. what must not be changed.

## Required workflow

### 1. Spec
Identify the requested change, the user-facing behavior, relevant constraints,
acceptance criteria, likely affected files, and verification commands. For
non-trivial work, write or update a short task spec (see `TASK_TEMPLATE.md`).

### 2. Inspect
Read the relevant code before editing. Do not assume architecture — read it.

### 3. Plan
State the smallest safe change, the files likely touched, the checks to run, and
the risks/assumptions. Keep it short.

### 4. Small change
Implement the smallest change that satisfies the task. Prefer localized edits;
preserve existing architecture and style; make no unrelated cleanup.

### 5. Verify
Run the narrowest relevant check first, then broaden. `docs/ai/VERIFICATION.md`
is the source of truth for commands — run them, do not invent them. Preferred
order: targeted test -> typecheck -> lint -> full test suite -> build -> manual
check if relevant.

### 6. Fix
On failure: read the actual error, fix the root cause, re-run the failed check,
repeat until it passes or you are blocked. Do not bypass checks.

### 7. Report
End every task with the completion report below.

## Completion report

```text
Summary:
-

Files changed:
-

Verification:
-

Risks / follow-ups:
-
```

## When uncertain

Make the safest reasonable assumption, state it clearly, proceed with the
smallest reversible change, and flag the uncertainty in the report. Ask a
question only when proceeding risks meaningful rework, data loss, a security or
compliance problem, or a product decision the AI should not make.

## Hard stops — require explicit human approval

Do not do any of the following without explicit approval:

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

## Definition of done

A task is done only when the requested behavior is implemented, acceptance
criteria are satisfied, relevant checks passed (or failures are documented
honestly), no unrelated changes were introduced, and the completion report is
provided.
