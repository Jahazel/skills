---
name: grill-me
description: Stress-test a plan or design by walking the full decision tree before any code is written. Use after fullstack-feature-planning presents a plan, or any time you want to pressure-test a design. Asks one question at a time with a recommendation, explores the codebase instead of asking when the answer is in the code.
---

# Grill Me

## Overview

Relentlessly interview the user about every open branch of a plan until shared understanding is reached and no unresolved decisions remain. Slot this between planning and confirmation — after the plan is presented, before any file is touched.

## When to Use

- After `/fullstack-feature-planning` presents a plan and the feature is non-trivial
- When a design has architecture decisions that haven't been fully resolved
- When you want to surface assumptions before they become mid-implementation surprises
- Skip for simple or frontend-only changes where the plan is already unambiguous

## The Flow

```
Read the plan from context
        ↓
Identify all open branches (assumptions, decisions, edge cases)
        ↓
For each branch:
  Can the codebase answer this? → Read the code, report what you found, move on
  Can't be answered by code?   → Ask the user (one question, with a recommendation)
        ↓
Repeat until all branches are resolved
        ↓
Output a final decision summary
```

## How to Conduct the Interview

**One question at a time.** Never ask multiple questions in a single message. Wait for the answer before moving to the next branch.

**Always lead with a recommendation.** Don't ask open-ended questions cold. State your recommended answer first, then ask if the user agrees or wants to override.

Example:
> **Scope:** Should this apply to both TradeEntry and NoTradeEntry, or just TradeEntry?
> My recommendation: both — the data model is identical and users will expect consistent behavior.

**Explore the codebase instead of asking** when the question can be answered by reading files. If you're wondering whether a field already exists in the schema, read the model. Report what you found and move on without using it as a question.

Example:
> I checked `tradeEntry.model.ts` — the `notes` field already exists in the schema. No schema change needed. Moving on.

**Walk dependencies in order.** Resolve upstream decisions before downstream ones. Don't ask about the UI until storage is decided. Don't ask about the frontend component until the API contract is confirmed.

## Branches to Walk

For any plan, systematically check these:

**Scope**
- Does this apply to one entity or multiple?
- Create-only, or also editable after creation?
- Does it affect related views (detail, list, edit)?

**Data**
- Does the field/table/schema already exist?
- Where does the data live? (database field, third-party service, local state?)
- What are the constraints? (required, optional, max length, format?)

**API**
- New endpoint or existing one handles it?
- What's the request/response shape?
- Does auth apply?

**Edge cases**
- What happens when the data is empty or missing?
- What if the user has no items yet?
- What if the operation fails halfway?

**Frontend**
- Which specific UX pattern? ("like Notion" is not a spec)
- When does it save? On submit or immediately?
- What does the empty state look like?

Don't ask all of these — only the ones left open by the plan.

## Ending the Interview

Stop when every open branch has been resolved — either by reading the codebase or by getting a confirmed answer from the user.

Close with a decision summary:

```
## Decisions Confirmed

- Scope: applies to both TradeEntry and NoTradeEntry
- Storage: Cloudinary via existing upload endpoint
- Schema: images field already exists in model — no migration needed
- UX: thumbnails shown inline, uploaded immediately on select, removed on click
- Save behavior: images array passed with the form submit, not saved independently
- Empty state: hide the image section label until at least one image exists
```

This summary becomes the confirmed spec that `/fullstack-implementation-workflow` executes against.

## What Not to Do

- Don't ask questions the codebase can answer — read it first
- Don't ask multiple questions at once
- Don't skip the recommendation — cold open-ended questions produce vague answers
- Don't grill on simple features — use judgment on when this adds value vs. slows things down
- Don't start implementing — this skill ends at the decision summary, not the code
