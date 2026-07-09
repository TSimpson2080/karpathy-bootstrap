# New Repo Karpathy Setup Prompt

Use when starting a new repo (little or no existing product code). Paste into your
coding agent while it operates from the repo root.

---

Set up the Karpathy Method for this new repo. The canonical template folder is at
`~/karpathy-bootstrap`. You do the setup — no manual steps.

1. Inspect the current repo.
2. Copy the contents of `~/karpathy-bootstrap` into the repo root, preserving structure
   (`CLAUDE.md`, `AGENTS.md`, `docs/ai/`, `scripts/`, `.github/`).
3. Read the copied files.
4. Ask me at most 6 questions: what we're building; primary user; core workflows;
   stack to use or preserve; what must never change without approval; commands that
   prove the repo works.
5. After I answer, customize ONLY `docs/ai/PROJECT_SPEC.md` and `docs/ai/VERIFICATION.md`.
   Remove every [bracketed] placeholder in those two files.
6. In `.github/workflows/verify.yml`, uncomment the `verify:` job and fill in the real
   commands from `VERIFICATION.md`.
7. Do not build features, refactor, add dependencies, or rename/reorganize app files.
   Do not edit `KARPATHY_METHOD.md`, `CLAUDE.md`, or `AGENTS.md` unless a placeholder requires it.
8. Run `bash scripts/check-placeholders.sh` and confirm it passes.

Enforced loop: `spec -> inspect -> plan -> small change -> verify -> fix -> report`.

End with: files created/updated; verification commands recorded; setup gaps; and the
exact `git` command I should run to commit.
