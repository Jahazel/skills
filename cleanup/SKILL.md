---
name: cleanup
description: Use after /build passes but before /ship. Scans files touched by the feature for duplication, naming issues, and architectural flags. Implements the smallest service-layer extraction, runs checks, summarizes in conversation what got simpler, and queues architectural issues for /deepen.
---

# Cleanup — Between Build and Ship

## Overview

AI agents take the path of least resistance: they create new functions instead of reusing existing ones. A feature can work while leaving behind duplicated logic, inconsistent naming, shallow modules, and code that confuses future agents.

Run this after `/build` passes all checks. Before `/ship`.

Do not use this as permission to redesign the whole app.

---

## When to Use

- `/build` just passed — feature works locally, checks are green
- The agent created similar helpers in multiple files
- You want a clean, focused PR before review

## When to Skip

- Tiny one-liner fix with no new logic
- Pure config or copy change

---

## What "Service Layer" Means

The UI/route/action decides **what** should happen. The service handles **how** it happens.

Services own: API calls, external requests, parsing, validation, data transformation, sending messages.

Routes/actions/components own: domain policy, business decisions, user-facing logic.

---

## Execution Order

```
1. Identify scope — git diff to find files touched by this feature
         ↓
2. Scan — find all issues in touched files, cite file:line, score 1–10
         ↓
3. Propose — state the smallest extraction before touching anything
         ↓
4. Implement — fix severity 6+ findings; naming issues in touched files
         ↓
5. Verify — run tsc --noEmit, lint, relevant tests
         ↓
6. Summarize in conversation — what was found, fixed, skipped, and what got simpler
         ↓
7. Queue architectural flags — append out-of-scope findings to deepen-queue.md
```

---

## Scan Checklist

### Duplication (scoped to touched files)

**Exact duplicates**
- Copy-pasted code blocks
- Identical functions in different files

**Near-duplicates**
- Same logic, different variable names
- Slightly modified algorithms doing the same thing

**Structural duplicates**
- Repeated patterns or boilerplate across files
- Same shape of logic in multiple places

**Data duplicates**
- Repeated constants or magic values
- Config or schema values defined more than once

For each finding: `file:line` — what it is — severity 1–10 — extraction recommendation.

### Naming + Readability (scoped to touched files)

- Cryptic variable names (single letters, unclear abbreviations)
- Magic numbers or strings with no explanation
- Functions with more than 3 parameters
- Inconsistent naming conventions (camelCase vs snake_case mixing)
- Boolean parameters (prefer named objects)

For each finding: `file:line` — what it is — severity 1–10 — suggested fix.

### Architectural Issues (do not fix — queue for /deepen)

Look for these while scanning. Do not implement fixes — flag them for `/deepen`.

Use the **deletion test**: imagine deleting this module. If complexity vanishes, it was a pass-through (shallow). If complexity reappears across callers, it was earning its keep.

- **Shallow module** — interface nearly as complex as the implementation; callers have to know too much
- **Low locality** — related logic spread across multiple files when it should be colocated
- **Low leverage** — a lot of caller knowledge required for the behavior the module provides

For each: `file:line` — problem type — one-sentence description. These get written to `deepen-queue.md`.

---

## The Cleanup Prompt

```md
The feature is working. Run a cleanup pass on the files touched by this feature.

Step 1 — Scope: Run git diff to identify which files were touched. Work only within those files.

Step 2 — Scan: Find all duplication (exact, near-duplicate, structural, data), naming issues,
and architectural flags (shallow modules, low locality, low leverage).
For each finding, output:
- file:line
- what the issue is
- severity score 1–10 (duplication/naming) or problem type (architectural)
- recommended fix or "queue for /deepen"

Apply the deletion test to suspected shallow modules: would deleting it concentrate
complexity, or just move it?

Do not invent files or functions not present. If context is missing, mark "Unable to verify."

Step 3 — Propose: State the smallest service-layer extraction before touching anything.
What will be moved, where it will live, what will call it.

Step 4 — Implement:
- Extract severity 6+ duplication into reusable service-layer functions.
- Keep domain policy in the calling route/action/component.
- Apply naming fixes from the scan.
- Do not change user-facing behavior.
- Do NOT fix architectural flags — those go to deepen-queue.md only.

Step 5 — Verify: Run tsc --noEmit, lint, and the relevant tests.

Step 6 — Summarize in conversation:
- What was found (file:line + severity).
- What was fixed and what was skipped (score + reason).
- What got simpler.
- Architectural flags queued for /deepen.

Step 7 — Append to deepen-queue.md in the project root:
For each architectural flag from Step 2:
  - File(s) involved
  - Problem type (shallow module / low locality / low leverage)
  - One-sentence description
  - Feature name and date (YYYY-MM-DD)

Create the file if it doesn't exist. Append only — never overwrite.
```

---

## Constraints

- Cite exact `file:line` for every finding — no vague references
- Never invent files or functions not present in the codebase
- Scope stays on feature-touched files only
- Do not change user-facing behavior
- Do not rename things outside the touched files
- Do not fix architectural flags — queue them in deepen-queue.md
- Implement only; do not commit — `/ship` handles that

---

## Verification Checklist

- [ ] Scope was derived from git diff, not guessed
- [ ] Every finding has a file:line citation and severity score
- [ ] Repeated mechanics were actually reduced
- [ ] Calling files became simpler
- [ ] Domain policy stayed in routes/actions/components
- [ ] tsc --noEmit passed
- [ ] lint passed
- [ ] Relevant tests passed
- [ ] Conversation summary states exactly what got simpler
- [ ] Architectural flags appended to deepen-queue.md (if any found)
