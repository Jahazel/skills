---
name: plan
description: Phase 1 — Research + Planning. Use when starting any new feature before touching code. Reads the codebase, identifies the gap, and creates a GitHub Issue with the confirmed plan. No code is written until the user confirms the issue.
---

# Plan — Phase 1: Research + Planning

## Overview

Read the existing code before writing anything. Identify the gap between what exists and what's needed. Create a GitHub Issue with the spec. Stop — no code is written until the user confirms the issue.

## The Planning Flow

```
Understand the request
        ↓
Read relevant existing files
        ↓
Identify the gap
        ↓
Plan by layer (one sentence each)
        ↓
Present the plan in chat — explain approach + any tradeoffs
        ↓
Invite discussion: ask questions, suggest /grill-me for non-trivial features
        ↓
Revise if needed (loop back to plan)
        ↓
Create GitHub Issue with the confirmed plan
        ↓
Stop — no code until user confirms the issue
```

## Step 1: Understand the Request

Before reading any code, get clear on what the user wants:
- What problem does this solve?
- What does "done" look like from their perspective?
- Are there UX references ("like Notion") — if so, which specific pattern?

Don't assume. One clarifying question now saves a full rebuild later.

## Step 2: Read the Relevant Existing Code

For a fullstack app, read in this order:

1. **Backend model** — what fields exist on the schema?
2. **Backend types** — what's in the request/response body types?
3. **Frontend types** — do they match the backend?
4. **Frontend component** — what does the form/view already render?
5. **API layer** — what functions exist?

Most of the time the backend supports the feature but the frontend doesn't expose it, or the types exist but nothing uses them.

## Step 3: Identify the Gap

| Scenario | What it means |
|---|---|
| Field exists in model and types, missing from form | Frontend-only change |
| Field missing everywhere | Full-stack: model → types → controller → frontend |
| Architecture decision needed (storage, 3rd party) | Ask before planning |
| Feature touches 2+ unrelated systems | Break into separate issues |

**Real example — notes field:**
Reading the codebase showed `notes` was already in the Mongoose model, backend types, and frontend types. Only the form was missing a textarea. That's a 1-file frontend change, not a full feature build.

**Real example — image upload:**
No existing support anywhere + requires choosing a storage provider. Architecture decision (Cloudinary vs S3) had to be made before any code was written.

## Step 4: Plan by Layer

Write one sentence per layer — backend to frontend:

**Schema change?** → model field → types interface → request body types (create + update)
**API change?** → new endpoint or existing, controller reads/writes new field
**Frontend change?** → types → API function → component → creation form → detail/edit view

## Step 5: Present and Discuss

Output the plan in chat. Explain the approach and any tradeoffs. Then explicitly invite feedback:

> "Does this match what you had in mind? Any scope changes or questions before I write the issue? You can also `/grill-me` to pressure-test the approach."

Wait for a response. If the user pushes back or asks questions, answer them and revise the plan. Loop back through Step 4 if the scope changes. Only move to issue creation once the user confirms the plan is right.

**When to suggest `/grill-me`:** Any feature that touches multiple layers, has architecture decisions (storage, 3rd-party services), applies to multiple entities, or has UX patterns described loosely ("like Notion"). Skip the suggestion for simple frontend-only changes where the plan is already unambiguous.

## Step 6: Create the GitHub Issue

Create a GitHub Issue with the plan as its body. This is the confirmation artifact — the user confirms the issue, not the chat message.

**Title:** Short feature name (e.g. "Add image upload to trade entries")

**Body:**
```
## Goal
One sentence: what this feature does for the user.

## Acceptance Criteria
- [ ] Specific, testable condition 1
- [ ] Specific, testable condition 2

## Plan
**Schema:** ...
**API:** ...
**Frontend:** ...
```

Run:
```bash
gh issue create --title "..." --body "..."
```

If a Milestone exists for this sprint or feature group, ask the user which one to assign with `--milestone "name"`.

## Step 7: Stop

After the issue is created, report the issue URL and stop. Do not write any code. Phase 2 (`/build`) begins only after the user explicitly confirms the issue.

## What Not to Do

- Don't start writing code to "explore" — read the files instead
- Don't assume the backend needs changes without reading it first
- Don't make architecture decisions without asking
- Don't plan the frontend before confirming the backend contract
- Don't build for both entry types until confirmed — ask if scope is unclear
