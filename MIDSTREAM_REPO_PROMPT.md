# Midstream Repo Karpathy Setup Prompt

Use when the repo already exists and work is underway. Paste into your coding agent
while it operates from the repo root.

---

Set up the Karpathy Method for this existing repo. The canonical template folder is at
`~/karpathy-bootstrap`. You do the setup — no manual steps. Do not redesign the repo.

1. Inspect the repo: package files, README, app structure, tests, config, existing docs.
2. Copy the contents of `~/karpathy-bootstrap` into the repo root, preserving structure.
   Do not overwrite a useful existing `CLAUDE.md`/`AGENTS.md`/PR template — if there is a
   real conflict, ask before replacing.
3. Read the copied files.
4. Determine the actual stack, architecture, scripts, test setup, and current gaps.
5. Ask me at most 5 questions, only for what you cannot determine from the repo.
6. Customize ONLY `docs/ai/PROJECT_SPEC.md` and `docs/ai/VERIFICATION.md`. Document reality —
   including missing tests, failing commands, or outdated docs. Remove every [bracketed]
   placeholder in those two files.
7. In `.github/workflows/verify.yml`, uncomment the `verify:` job and fill in the real
   commands that exist today.
8. Do not refactor, change product behavior, add dependencies, rename/reorganize folders,
   or fix bugs unless I explicitly ask. Do not edit `KARPATHY_METHOD.md`, `CLAUDE.md`, or
   `AGENTS.md` unless a placeholder requires it.
9. Run `bash scripts/check-placeholders.sh` and confirm it passes.

Enforced loop: `spec -> inspect existing code -> plan -> small change -> verify -> fix -> report`.

End with: what you discovered; files created/updated; verification commands recorded;
known gaps; recommended first hardening task; and the exact `git` command to commit.
