# Karpathy Bootstrap Templates

Canonical, repo-level AI operating instructions for Claude Code, Codex, Cursor,
Windsurf, and other AI coding agents. Drop-in: copy into a repo, fill two files,
wire one CI job.

## What's here

```text
CLAUDE.md                       # thin, always-loaded; points to the canonical process
AGENTS.md                       # same body as CLAUDE.md, for non-Claude agents
docs/ai/KARPATHY_METHOD.md      # THE canonical process (version-stamped)
docs/ai/PROJECT_SPEC.md         # fill in: what this repo is  (gated by CI)
docs/ai/VERIFICATION.md         # fill in: how to verify work (gated by CI)
docs/ai/TASK_TEMPLATE.md        # copy per task
scripts/check-placeholders.sh   # setup gate: placeholders filled + guardrails consistent
.github/workflows/verify.yml    # runs the gate; add your real test/lint/build job
.github/pull_request_template.md
```

## Install

From the repo root:

```bash
cp -R ~/karpathy-bootstrap/* ~/karpathy-bootstrap/.github .
```

Then customize ONLY `docs/ai/PROJECT_SPEC.md` and `docs/ai/VERIFICATION.md`, and
uncomment the `verify:` job in `.github/workflows/verify.yml` with your real
commands. Everything else is canonical — leave it alone.

## Enforcement, honestly

- `scripts/check-placeholders.sh` (run by CI) **does** fail the build if the two
  customizable files still contain `[placeholders]`, or if the "Hard stops"
  guardrail list drifts between `CLAUDE.md` and `AGENTS.md`.
- The rest of the loop is instruction to a probabilistic agent, plus a human PR
  checklist. It is *guidance*, not a hard gate — until you wire your real
  test/lint/build commands into the `verify:` job. Do that; it's the difference
  between "we told the agent to verify" and "unverified work can't merge."

## Setup prompts

See `NEW_REPO_PROMPT.md` and `MIDSTREAM_REPO_PROMPT.md`. Both reference the single
canonical path `~/karpathy-bootstrap`.

## Rolling out across many repos

See `ROLLOUT.md`. In short: publish this folder as `you/karpathy-bootstrap`
(`tools/create-central-repo.sh`), backfill every repo via PRs
(`tools/karpathy-sync.sh --all`), and require the check before merge
(`tools/karpathy-protect.sh --all`). Each repo references the reusable workflow by
tag, so you update the method once and re-sync — repos on a stale version go red
on the drift check instead of rotting silently.
