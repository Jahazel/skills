---
name: design-references
description: Run once per project when setting up a new design direction or when reference images change. Reads all images in .claude/design-references/, leads a structured visual review conversation, then writes notes.md. Run this before /impeccable shape on any new project.
---

# Design References

You are facilitating a structured visual reference review. Your job is to look at every image in the project's `.claude/design-references/` folder, lead a conversation about each one, and then write a `notes.md` file that captures exactly what to take — and what to ignore — from each image.

Do not write `notes.md` until the full conversation is complete.

---

## Step 1: Load the Images

Read every image file in `.claude/design-references/`. If `notes.md` already exists, read it too so you know what's already been captured.

List the images you found so the user can see what you're working with.

---

## Step 2: First Pass — Your Observations

For each image, present a short analysis. Cover what you actually see — not praise, not interpretation, just observation:

- **Layout structure** — sidebar or top nav? fixed or fluid? column grid and asymmetry? how is the viewport divided?
- **Visual hierarchy** — what draws the eye first, second, third? how is prominence established — size, weight, color, or position?
- **Color system** — primary surface, secondary surface, accent usage, semantic colors (success/error), and how much of the screen each occupies
- **Typography** — apparent type scale, weight contrast between heading/body/label, tracking, line height treatment
- **Spacing and density** — is this data-dense or airy? what is the approximate base unit (4pt, 8pt)?
- **Component anatomy** — card treatment (bordered, shadowed, tonal?), button style, input style, table row height, icon style (outlined, filled, duotone?)
- **Corner radius system** — sharp, slightly rounded, pill-shaped? consistent throughout?
- **Emotional register** — clinical tool, editorial, playful, branded, corporate, consumer?

Do all images in one message before asking any questions.

---

## Step 3: Structured Design Conversation

After your observations, open a conversation structured in two parts.

### Part A — Per-image questions

For each image, ask:
1. Is this a **primary reference**, secondary reference, or mood/feel only?
2. What specifically appeals to them — push past vague answers. "I like the personality" → ask what gives it personality. "I like the sidebar" → ask what specifically about the sidebar (its weight? its icons? how the active state looks?).
3. Is there anything in this image they explicitly do NOT want to carry forward?

### Part B — System-level design questions

These are the questions a UX/UI designer asks before touching any component. Ask them all, but conversationally — not as a form.

**User and context:**
- Who is the primary user and what is their mental state when using this? (rushed and scanning, focused and deliberate, ambient and reviewing?)
- What are the 2–3 actions they take most frequently? (This determines what gets primary visual weight.)
- What does the user currently use for this job? What do they love and hate about it?

**Personality and feel:**
- Describe the product in 3 adjectives. How should it feel different from everything else in this space?
- Is this a tool (design serves function) or a product with a brand identity (design is part of the experience)?
- What's one thing the UI should never feel like?

**Visual system:**
- Light mode, dark mode, or both?
- Is there a typeface already decided, or should one be recommended? If decided, which weights will be used?
- Is there a color direction — a hue, a temperature, a palette family? Any colors reserved for specific semantic use (e.g., green/red for P&L only)?
- What is the density target — data-dense like a trading terminal, moderate like a SaaS dashboard, or airy like a marketing tool?

**Components and interaction:**
- Are there any specific components that must feel premium or receive extra craft (e.g., the main chart, the data table, a key input)?
- How should interactive states feel — snappy and immediate, or eased and considered?
- Are there states that need explicit design thought: empty states, loading, error, onboarding?

**Constraints:**
- Are there accessibility requirements (WCAG AA contrast, keyboard navigation)?
- What screen sizes need to be supported — desktop-only, or responsive down to mobile?
- Are there any existing design decisions already locked in (component library, existing styles, specific colors)?

Take the user's answers seriously. If something is vague, follow up once. Don't proceed to Step 4 until you have enough to write specific, actionable rules.

---

## Step 4: Write notes.md

Once the conversation is complete, write `.claude/design-references/notes.md`. Structure it as:

```
# Design Reference Notes

## PRIMARY REFERENCE — `<filename>`
<what it is, what to take from it — specific patterns, components, and layout decisions worth carrying forward>

## `<filename>`
<what to take, what to ignore — be explicit about both>

## Cross-cutting Design Rules
<Actionable rules derived from the full conversation. Each rule should be specific enough that a developer implementing a component knows exactly what to do.>

### User and Context
### Personality
### Color System
### Typography
### Spacing and Density
### Components
### Constraints
```

Rules for writing good notes:
- Specific beats general: "arc gauge indicators for percentage metrics, not bar charts" not "nice charts"
- Name what NOT to take from each image — prevents accidental copying
- Cross-cutting rules must be actionable, not descriptive
- Encode semantic color rules explicitly
- Notes are read by Claude before building any UI — write them so a developer implementing a component blind knows exactly what to produce

Confirm with the user before saving the file.
