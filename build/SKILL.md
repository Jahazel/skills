---
name: build
description: Phase 2 — Implementation. Use when a GitHub Issue is confirmed and ready to build. Implements the plan layer by layer — backend first, type check at each layer, then frontend, lint, and tests. Stops when checks pass — does not commit or push.
---

# Build — Phase 2: Implementation

## Overview

Execute the confirmed plan from the GitHub Issue. Backend first, verify it compiles, then frontend, verify it compiles, lint, tests. Stop when all checks pass and report back. Phase 3 (`/ship`) handles commit, push, and PR.

## The Execution Order

```
Read relevant files
        ↓
Backend changes (model → types → controller → route → app.ts)
        ↓
npx tsc --noEmit (backend)
        ↓
Frontend changes (types → API function → component → wire into forms/views)
        ↓
npx tsc --noEmit (frontend)
        ↓
npm run lint (frontend)
        ↓
npm test (frontend)
        ↓
Playwright setup (config + spec + vitest exclude + GH Actions workflow)
        ↓
Report results — stop
```

Never skip a type check step. Errors caught at the backend layer are cheaper than errors discovered after the frontend is also written.

## Step 1: Read Before Writing

Before touching any file, read:
- The data model file for the entity being changed
- The backend types (request body interfaces)
- The frontend types (mirrored interfaces)
- The component(s) you'll modify

## Step 2: Backend Changes (in order)

1. **Data model** — add field to schema
2. **Model types file** — add field to Document/entity interface
3. **Backend request types** — add field to `CreateBody` and `UpdateBody`
4. **Controller** — destructure new field, pass to model constructor (create) and update block (update)
5. **New route/controller** (if needed) — controller first, then route file, then wire into the app entry point

**Pattern — adding a field to an existing entity:**
```
<entity>.model.ts       → add field to schema
<entity>.types.ts       → add field to Create + Update body interfaces
<entity>.controller.ts  → destructure field, pass through create and update handlers
<feature>.controller.ts → new file if a new endpoint is needed
<feature>.routes.ts     → new file: define route, wire middleware
app.ts / index.ts       → register new router
```

## Step 3: Type Check Backend

Navigate to the backend root, then:

```bash
npx tsc --noEmit
```

Fix all errors before touching the frontend. Pre-existing warnings (tsconfig deprecations, etc.) are fine to ignore — only fix new errors introduced by your changes.

## Step 4: Frontend Changes (in order)

1. **Frontend types** — mirror the backend contract
2. **API layer** — add API function if a new endpoint exists
3. **New component** (if needed) — build and test standalone first
4. **Wire into creation forms** — import component, add state, pass to submit
5. **Wire into detail/edit views** — import component, pass existing data as initial state, save on change

**Pattern — adding a component wired to a new field:**
```
<entity>.types.ts         → add field to frontend Create/Update data interfaces
api.ts                    → add API function for any new endpoint
<Feature>.tsx             → new component: handle its own state, expose onChange
<CreateForm>.tsx          → import component, add state, merge into submit payload
<DetailView>.tsx          → import component, pass existing value, save on change
```

## Step 5: Type Check Frontend

Navigate to the frontend root, then:

```bash
npx tsc --noEmit
```

Fix new errors. Ignore pre-existing warnings.

## Step 6: Lint

```bash
npm run lint
```

Do not proceed with failing lint errors.

## Step 7: Run Tests

```bash
npm test
```

If a test fails after your changes, fix the code — or, if the behavior genuinely changed intentionally, update the test to match the new expected behavior.

## Step 8: Playwright Setup

After all checks pass, ensure Playwright infrastructure exists before `/ship` runs.

**`playwright.config.ts`** — create if missing:
```ts
import { defineConfig, devices } from "@playwright/test";
export default defineConfig({
  testDir: "./e2e",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  reporter: "list",
  use: { baseURL: "http://localhost:5173", trace: "on-first-retry" },
  webServer: {
    command: "npm run dev",
    url: "http://localhost:5173",
    reuseExistingServer: !process.env.CI,
    timeout: 30_000,
  },
  projects: [{ name: "chromium", use: { ...devices["Desktop Chrome"] } }],
});
```

**`vitest.config.ts`** — must exclude `e2e/**` to prevent Vitest picking up Playwright specs. Add if missing:
```ts
test: {
  exclude: ["e2e/**", "node_modules/**"],
}
```

**`.github/workflows/playwright.yml`** — create if missing. Always include `VITE_API_URL: /api` on the test step — `.env` is gitignored so Vite env vars must be explicit on CI or route mocks won't fire:
```yaml
name: Playwright Tests
on:
  pull_request:
    branches: [main]
  push:
    branches: [main]
jobs:
  e2e:
    name: E2E Tests
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: frontend
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: frontend/package-lock.json
      - name: Install dependencies
        run: npm ci
      - name: Install Playwright browsers
        run: npx playwright install chromium --with-deps
      - name: Run Playwright tests
        run: npx playwright test
        env:
          VITE_API_URL: /api
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: frontend/playwright-report/
          retention-days: 7
```

**E2E spec** — write `frontend/e2e/<feature-name>.spec.ts` for this feature:
- Mock API routes with `page.route()`
- Set auth via `page.addInitScript()` to write localStorage
- Test the golden path described in the acceptance criteria
- Add `frontend/test-results/` and `frontend/playwright-report/` to `.gitignore` if not already there

Run `npm test` one more time after updating `vitest.config.ts` to confirm nothing broke.

## Step 9: Stop and Report

All checks passed and Playwright infrastructure is in place. Report to the user:

> "Type-check, lint, and tests all pass. Playwright spec written. Ready for `/ship`."

Do not commit. Do not push. Phase 3 (`/ship`) handles commit, push, and PR.

## Common Mistakes

**Writing frontend before backend compiles:** You'll write frontend types against a contract that doesn't exist yet, then have to fix both sides.

**Forgetting to update both create and update bodies:** Adding a field to `CreateBody` but not `UpdateBody` means it can be set at creation but never changed.

**Skipping the detail/edit view:** A field available at creation but not editable after is a half-built feature. Always check both the creation form AND the detail view.

**Not mirroring types across backend and frontend:** The frontend Create/Update data interfaces must match their backend counterparts. When one changes, update both.

**Staging unrelated files:** Stage files explicitly by name in `/ship`, not with `git add .`. Keep changes scoped to the issue.
