---
name: ship
description: Phase 3 — Testing + PR. Use after /build passes all checks. Runs Playwright E2E tests, runs the full quality gate, commits to the feature branch, pushes, and opens a PR that closes the GitHub Issue. CI re-runs Playwright on the open PR.
---

# Ship — Phase 3: Testing + PR

## Overview

Verify the feature works from the user's perspective. Run all quality checks. Commit, push, and open a PR that closes the GitHub Issue. CI re-runs Playwright automatically. The user reviews the diff, approves, and merges — which auto-closes the issue.

## The Flow

```
Ask for the issue number
        ↓
Playwright E2E tests (local dev server)
        ↓
Full quality gate: lint → tsc → Vitest
        ↓
All pass → stage files by name → commit
        ↓
Push to remote
        ↓
Open PR referencing the issue
        ↓
Report PR URL — done
```

## Step 1: Ask for the Issue Number

Before running anything, ask:

> "What is the GitHub Issue number for this feature?"

This is embedded in the commit message and PR body to auto-close the issue on merge.

## Step 2: Run Playwright E2E Tests

Playwright must be installed globally (`playwright --version` to verify).

Navigate to the directory containing `playwright.config.ts`, then:

```bash
playwright test
```

Playwright starts the dev server automatically via `playwright.config.ts`.

**If tests fail:** Stop immediately. Report which tests failed and the error output. Do not proceed to commit. The user must fix the failure in Phase 2 (`/build`) and re-run `/ship`.

**If no `playwright.config.ts` exists:** Stop. Playwright setup belongs in `/build` — return there and complete Step 8 before running `/ship`.

## Step 3: Full Quality Gate

Navigate to the project root (or frontend root if it's a separate package), then run in order — stop at the first failure and report it:

```bash
npm run lint
npx tsc --noEmit
npm test
```

All three must pass before committing.

## Step 4: Stage and Commit

Run `git status` to see all modified files. Stage them explicitly by name — never use `git add .` or `git add -A`:

```bash
git add path/to/file1 path/to/file2 ...
```

Commit using Conventional Commits format:

```
type: short description in present tense (≤50 chars)

Body explaining WHY, not what. One paragraph max.

Closes #[issue number]
Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

**Types:** `feat`, `fix`, `refactor`, `chore`, `docs`, `test`

Pass the message via heredoc to preserve formatting:
```bash
git commit -m "$(cat <<'EOF'
feat: short description

Why this change was made.

Closes #42
Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
EOF
)"
```

## Step 5: Push

```bash
git push -u origin [branch-name]
```

## Step 6: Open PR

```bash
gh pr create --title "short feature description" --body "$(cat <<'EOF'
## Summary
- What changed (bullet points)

## Test plan
- [ ] Playwright E2E tests pass locally
- [ ] [Specific user-facing behavior to verify]

Closes #[issue number]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

## Step 7: Report

Report the PR URL to the user. Done.

CI will re-run Playwright on the open PR. The user reviews the diff, approves, and merges — which auto-closes the GitHub Issue and updates the Milestone progress.

## If Any Step Fails

| Failure | Action |
|---|---|
| Playwright tests fail | Stop. Report test name + error. Return to `/build`. |
| Lint fails | Stop. Report errors. Return to `/build`. |
| tsc fails | Stop. Report errors. Return to `/build`. |
| Vitest fails | Stop. Report failures. Return to `/build`. |
| `gh pr create` fails | Check `gh auth status`. Re-authenticate if needed. |
| No `playwright.config.ts` | Stop. Return to `/build` Step 8 to complete Playwright setup. |
