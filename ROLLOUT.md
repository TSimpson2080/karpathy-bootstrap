# Rollout — one method across all your repos

Personal GitHub account, backfill existing + cover new. Run everything from the
`karpathy-bootstrap` folder root, on a machine where `gh` is authenticated.

## 0. Prereqs
```bash
gh auth status        # must be logged in
gh --version
```

## 1. Publish the source of truth (once)
```bash
tools/create-central-repo.sh
```
Creates `you/karpathy-bootstrap`, pushes it, tags `v1`. If your repos are private,
it prints the one setting to flip so they can call the reusable workflow. Also
mark the repo as a **Template repository** in Settings (for new repos).

## 2. Dry-run the backfill
```bash
DRY_RUN=1 tools/karpathy-sync.sh --all
```
Lists every repo it would touch. Narrow to a few first if you want:
```bash
tools/karpathy-sync.sh you/repo-a you/repo-b
```

## 3. Backfill for real
```bash
tools/karpathy-sync.sh --all
```
Opens a `chore/karpathy-method` PR in each repo: canonical files overwritten,
`PROJECT_SPEC.md`/`VERIFICATION.md` added only if missing. Then, per repo:
fill those two files (CI stays red until the `[placeholders]` are gone) and
uncomment the real verify job. Merge.

## 4. Make it required (enforcement)
After a PR's checks have run once, copy the exact check name from its Checks tab
(default assumed: `karpathy / gate`), then:
```bash
tools/karpathy-protect.sh --all           # or: CONTEXT="karpathy / gate" tools/karpathy-protect.sh you/repo-a
```
Now merges are blocked unless the gate passes. (Private-repo branch protection
needs GitHub Pro; public repos are free.)

## 5. New repos
Create them from the `karpathy-bootstrap` template, or run
`tools/karpathy-sync.sh you/new-repo` once. Then step 4 for that repo.

## Updating the method later
Change the canonical files, bump `Version:` in `docs/ai/KARPATHY_METHOD.md`, move
the tag (`git tag -f v1 && git push -f origin v1`, or cut `v2` and update
`expected_version`), then re-run `tools/karpathy-sync.sh --all`. Repos still on the
old version go red on the drift check instead of rotting silently.

## What this guarantees (and what it doesn't)
- Guaranteed: files present, files current (version check), merges blocked when the
  gate fails.
- NOT guaranteed: that an agent always follows the loop. That's guidance. The one
  hard lever is your real test/lint/build job in `verify.yml` — the more of your
  verification lives there, the closer "used the method" gets to "provably verified."
