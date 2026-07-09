# Verification

Source of truth for how AI agents verify work in this repo.
Fill every bracketed placeholder below with a real command. CI fails while any remain.
For a midstream repo, record the commands that actually exist today — including
what is missing.

## Commands
Run the narrowest relevant check first.

```bash
# Typecheck
[command]

# Lint
[command]

# Test
[command]

# Build
[command]
```

## Verification order
1. Targeted test for the changed code.
2. Typecheck.
3. Lint.
4. Full test suite.
5. Build.
6. Manual / e2e check if user-facing.

## Minimum verification by change type
- Docs only: review changed docs.
- UI: relevant component test + typecheck + lint + manual/screenshot.
- Business logic: targeted tests + typecheck + full suite when practical.
- Data model / auth / payment / legal / tax / health / compliance: human approval first, then targeted tests + typecheck + full suite + build + manual review.

## If a check cannot be run
State exactly:

```text
I could not run <command> because <reason>.
The human should run: <command>
```

## Known gaps
Record reality — missing coverage, absent scripts, currently-failing commands.

- [Gap 1]
- [Gap 2]
