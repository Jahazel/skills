---
name: deepen
description: Periodic whole-codebase architectural scan. Run every few weeks — not after each feature. Reads deepen-queue.md for signals from /cleanup passes, scans for shallow modules and low-locality clusters, generates an HTML report with before/after diagrams, grills you on one candidate, and creates a GitHub Issue that feeds back into /plan.
---

# Deepen — Periodic Architecture Review

Finds shallow modules, low-locality clusters, and undertested seams. Not a per-feature tool — run every few weeks to address accumulated architectural entropy.

Uses the vocabulary in [LANGUAGE.md](LANGUAGE.md). Uses dependency classification in [DEEPENING.md](DEEPENING.md).

---

## When to Run

- Every few weeks in an active codebase
- When `deepen-queue.md` has accumulated several entries from `/cleanup` passes
- Before a large feature that touches architectural boundaries

## When to Skip

- Right after a build/ship — wait for signals to accumulate
- `deepen-queue.md` is empty and the codebase feels clean

---

## Process

### 1. Read Prior Signals

Check for `deepen-queue.md` in the project root. If it exists, read it — these are architectural issues flagged by previous `/cleanup` passes, grounded in real feature work. Weight them higher than fresh scan findings.

If a `CONTEXT.md` exists (project domain glossary), read it too. Use its vocabulary when naming candidates in the report.

---

### 2. Explore

Use the Explore agent to walk the codebase organically. Don't follow rigid heuristics. Look for friction:

- **Shallow modules** — interface nearly as complex as the implementation. Apply the deletion test: would deleting it concentrate complexity, or just move it?
- **Low locality** — related logic scattered across files when it should sit in one place
- **Low leverage** — callers must know too much to use a module that should be simple
- **Untested seams** — important interfaces with no test coverage
- **Parallel implementations** — the same concept implemented in two places with no shared seam

Weight `deepen-queue.md` entries higher when ranking candidates.

---

### 3. Generate HTML Report

Write a self-contained HTML file to the OS temp directory. Resolve from `$TMPDIR`, falling back to `/tmp`. Filename: `deepen-<timestamp>.html`. Open with `open <path>` on macOS.

Use **Tailwind via CDN** for layout. Use **Mermaid via CDN** for dependency graphs and call-flow diagrams. Use **hand-built divs/SVG** for module depth cross-sections and mass diagrams.

Each candidate gets a card:

- **Title** — names the deepening (e.g. "Collapse auth token handling into one module")
- **Files** — which files are involved (`font-mono text-sm`)
- **Problem** — one sentence using LANGUAGE.md terms
- **Solution** — one sentence on what changes
- **Wins** — bullets ≤6 words using glossary terms: "locality: change concentrates here", "leverage: one interface, N call sites", "delete 3 shallow wrappers"
- **Before/After diagram** — side by side; Mermaid for call graphs, hand-built for depth cross-sections
- **Strength** — `Strong` (emerald badge), `Worth exploring` (amber), `Speculative` (slate)
- **Dependency category** — from DEEPENING.md

End with a **Top Recommendation** section: which candidate to tackle first and why.

Do NOT propose interfaces yet. After opening the file, ask: "Which of these would you like to explore?"

---

### 4. Grilling Loop

Once the user picks a candidate:

1. **Classify dependencies** using [DEEPENING.md](DEEPENING.md) — determines the adapter strategy and testing approach
2. **Propose a module shape** — name, interface (types/methods), what sits behind the seam
3. **Ask design questions** — constraints, adapters needed, which tests survive, what callers get simpler

Side effects as decisions crystallize:
- Naming a concept not in `CONTEXT.md`? Add it (create `CONTEXT.md` lazily if absent)
- User rejects the candidate with a load-bearing reason? Offer to write an ADR in `docs/adr/` so future runs don't re-suggest it. Only offer when the reason is genuinely load-bearing — skip "not worth it right now"

---

### 5. Create GitHub Issue

Once the shape is agreed:

```bash
gh issue create --title "[deepen] <module name>" --body "..."
```

Issue body includes:
- Proposed module name and interface sketch
- Files involved
- Dependency category from DEEPENING.md
- Testing strategy (adapters needed)
- Wins stated in locality/leverage terms

This issue feeds directly into `/plan` in the next session.

---

### 6. Clear Resolved Queue Entries

Remove entries from `deepen-queue.md` that were addressed in this session. Leave unresolved entries intact for the next run.

---

## Constraints

- Use [LANGUAGE.md](LANGUAGE.md) vocabulary exactly — module, interface, seam, adapter, leverage, locality
- Never propose an interface without classifying dependency type first (see [DEEPENING.md](DEEPENING.md))
- Don't introduce a seam unless two adapters are justified (one adapter = hypothetical seam only)
- Do not implement — `/plan` and `/build` handle that
- Do not commit changes to `deepen-queue.md` — write it and note it in conversation
