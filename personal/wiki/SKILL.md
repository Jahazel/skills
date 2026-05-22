---
name: wiki
description: Use when the user asks anything about their freelance web development wiki at /Users/jahazelsanchez/Code/wiki/ — workflow reference (testing conventions, conventional commits, session workflow with design/planning/implementation/deploy phases, AI agent skills and progressive disclosure, session principles, Claude Code hooks, CLAUDE.md template), synthesis questions ("based on my wiki", "what does my second brain say", "given my notes"), ingest ("ingest [filename]"), or lint ("lint the wiki"). The wiki is the authoritative source for these topics — consult it before answering from base knowledge.
user-invocable: true
argument-hint: "[lookup|ingest|lint] [target]"
---

# Wiki

Unified entry point for the user's freelance web development second brain at `/Users/jahazelsanchez/Code/wiki/`. Three modes: **lookup** (read), **ingest** (write), **lint** (audit).

The wiki schema (directory layout, page format, frontmatter, domains, naming conventions, rules) lives in `/Users/jahazelsanchez/Code/wiki/CLAUDE.md`. Read that file for structural questions about the wiki itself.

## Routing

| First word of invocation | Mode |
|---|---|
| no argument, or any natural-language question | **lookup** — consult the topic map below |
| `lookup [topic]` | explicit lookup |
| `ingest [filename]` | run the ingest workflow on `raw/[filename]` |
| `lint` | run the lint workflow |

Natural-language questions like "what's the testing convention?", "how do we do commits?", or "based on my wiki, what should I do about X?" default to **lookup mode**.

---

## Lookup mode

### Topic → page map

Jump directly to the page below — do not read `index.md` first.

| Topic | Page |
|---|---|
| Master session overview — glanceable map from session start to deploy, operating principles | `pages/workflow.md` |
| Design phase — brand vs product register, `/design-references` → `/design-inspiration` → `/impeccable`, per-project files | `pages/phase-design.md` |
| Planning phase — `/plan` creates GitHub Issue, `/grill-me` pressure-test, when to skip each | `pages/phase-plan.md` |
| Build phase — backend-first order, tsc gate between layers, lint-check.js auto-runs, stops when checks pass | `pages/phase-build.md` |
| Cleanup phase — service layer extraction, duplication scan, naming pass, architectural flags queued to deepen-queue.md, severity scoring | `pages/phase-cleanup.md` |
| Deepen phase — periodic whole-codebase scan, HTML report with before/after diagrams, grilling loop, GitHub Issue, deepen-queue.md | `pages/phase-deepen.md` |
| Test + Ship phase — Playwright locally, quality gate order, commit, push, PR, CI re-runs, review-fix loop | `pages/phase-ship.md` |
| Source code as context — npx open-source, reference/repos/ folder, eliminates hallucination on unfamiliar packages, conditional step between /plan and /build | `pages/source-code-context.md` |
| Security guardrails — package age rule (14 days), 2FA via authenticator app, password manager, breach response pattern | `pages/security.md` |
| Git hooks — gitleaks pre-commit hook blocks secret commits, git hooks vs Claude Code hooks | `pages/git-hooks.md` |
| Deploy workflow — Render/Vercel/Atlas stack, order of operations, five gotchas, pre-deploy checklist, security audit | `pages/deploy.md` |
| Testing conventions, Playwright E2E setup, Vitest, quality gate order, fnm/Node setup | `pages/testing.md` |
| Git commits, branches, PR format, conventional commits | `pages/commits.md` |
| Claude Code hook events, active hooks (`session-briefing`, `lint-check`, `session-end`), config shape, MCP server | `pages/session-hooks.md` |
| What skills are, progressive disclosure, how to build skills correctly, recursive improvement loop | `pages/skills.md` |
| The wiki skill itself — modes, design rationale, self-maintenance, token math | `pages/wiki-skill.md` |
| Context window layers, fill-level degradation, CLAUDE.md what belongs vs doesn't, global vs project, template | `pages/context-management.md` |
| Trading Journal portfolio project — stack, what it demonstrates, live URLs | `pages/trading-journal.md` |

All paths above are relative to `/Users/jahazelsanchez/Code/wiki/`.

### Synthesis bundles

When the user asks "based on my wiki", "what does my second brain say", "given my notes", or any cross-page synthesis question, read the relevant bundle below — don't guess pages from `index.md`.

- **Technical reference / dev workflow** — `pages/workflow.md`, `pages/phase-design.md`, `pages/phase-plan.md`, `pages/phase-build.md`, `pages/phase-cleanup.md`, `pages/phase-deepen.md`, `pages/phase-ship.md`, `pages/source-code-context.md`, `pages/testing.md`, `pages/commits.md`, `pages/deploy.md`, `pages/security.md`
- **Agent / skill architecture** — `pages/skills.md`, `pages/context-management.md`
- **Claude Code tooling** — `pages/session-hooks.md`
- **Freelance ops** — read every page currently listed in the Finance and Work sections of `index.md`. These domains are being filled organically; fall back to MCP search if the catalog is sparse.
- **Portfolio / projects** — `pages/trading-journal.md`, plus every page in the Projects section of `index.md`.

### Filing back

After surfacing an answer, if the synthesis is substantial and reusable, offer to file it as a new wiki page (which triggers ingest mode with the synthesis as the source). Don't ask reflexively — only when the answer is non-trivial enough that someone would want to re-find it later.

### Fallback order when the topic map doesn't match

1. Use the `obsidian` MCP server to keyword-search the vault.
2. If MCP search returns nothing useful, read `/Users/jahazelsanchez/Code/wiki/index.md` for the full catalog.

---

## Ingest mode

When the user says `ingest [filename]` (or asks to file a synthesis as a new page):

1. **Read the source.** Source file is at `/Users/jahazelsanchez/Code/wiki/raw/[filename]`. (For filed syntheses, write the synthesis to `raw/` first, then ingest from there.)
2. **Discuss key takeaways with the user** if they want — follow their lead.
3. **Decide whether to create a `pages/src-[short-title].md` source summary.**
   - **Create** only if the source has unique content not absorbable into existing concept pages — memorable quotes, design rationale, framing that would otherwise be lost.
   - **Skip** if the content is workflow guidance or updates that fit cleanly into existing concept pages. Past lints have aggressively deleted absorbed src pages — don't create one just to delete it next lint pass.
4. **Identify all entities and concepts** in the source. Update existing concept pages in `/Users/jahazelsanchez/Code/wiki/pages/` or create new ones. Match the page format in `wiki/CLAUDE.md`.
5. **Add cross-links** between related pages using `[[page-name]]` syntax. Scan existing pages for mentions of any new concept and add backlinks.
6. **Update `/Users/jahazelsanchez/Code/wiki/index.md`** if new pages were created. Insert under the matching domain section.
7. **Update this skill's Topic → page map** above if a new concept page was created with a distinct topic. The skill maintains itself — this step is not optional.
8. **Append to `/Users/jahazelsanchez/Code/wiki/log.md`** with the entry: `## [YYYY-MM-DD] ingest | [Source Title]` followed by a one-paragraph summary of what changed across the wiki.

A single ingest typically touches 3–10 pages. Be thorough with cross-references. The raw source file is preserved — never modify or delete files in `raw/`.

---

## Lint mode

When the user says `lint` (or "lint the wiki"):

1. **Read all pages in `/Users/jahazelsanchez/Code/wiki/pages/`.**
2. **Check for:**
   - **Contradictions** between pages — flag with specific page names.
   - **Orphan pages** — no inbound links from any other concept page (`index.md` doesn't count as an inbound link).
   - **Stale claims** superseded by newer sources or by reality.
   - **Important concepts mentioned across multiple pages but lacking a dedicated page**.
   - **Missing cross-references** — page A mentions concept B without linking to it.
   - **Data gaps** in domains where more sources would add value.
   - **Absorbed source summaries** — `src-*.md` pages whose content is fully covered by concept pages. Flag for deletion. Preserve unique content (quotes, rationale, framing) in concept pages before deleting.
   - **Topic map drift** — pages that exist in `pages/` but aren't in this skill's Topic → page map, or map entries that point to deleted pages.
3. **Present findings as a prioritized list** (HIGH / MEDIUM / LOW).
4. **Ask the user which issues to fix.** Do not auto-fix.
5. **Fix the approved issues.** For src deletions, do the content-preservation step first; for orphans, add inbound links from semantically related concept pages.
6. **Append to `/Users/jahazelsanchez/Code/wiki/log.md`** with the entry: `## [YYYY-MM-DD] lint | N issues found, M resolved` followed by a one-paragraph summary.

---

## Rules (always apply)

- Never modify files in `/Users/jahazelsanchez/Code/wiki/raw/` — they are immutable source documents.
- Never delete pages without explicit user confirmation.
- Never silently resolve contradictions by picking a side. Add a `> **Conflict (YYYY-MM-DD):**` callout on both pages and flag the tension.
- Never skip updating `index.md` and `log.md` after an ingest.
- Keep page frontmatter current (`updated:` field, `sources:` count).
- Use `[[page-name]]` Obsidian-style internal links throughout.
- When this skill's Topic → page map is changed, the change happens in the same operation as the corresponding page creation or deletion — never as a follow-up.

For the full wiki schema (directory layout, page frontmatter format, domain definitions, naming conventions, cross-linking rules), see `/Users/jahazelsanchez/Code/wiki/CLAUDE.md`.
