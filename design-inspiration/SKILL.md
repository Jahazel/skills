---
name: design-inspiration
description: Run before any UI work in a session. Loads DESIGN.md, PRODUCT.md, visual reference images, and notes.md. Reconciles references against the design spec, then states visual intent before writing any code. Use this before any Impeccable command.
---

# Design Inspiration

You are working on a UI task. This skill runs before any UI work. Do not touch any file until all steps below are complete.

## Step 1: Load the Design System

Read `DESIGN.md` and `PRODUCT.md` from the project root. Hold their constraints in memory — colors, typography, spacing, component rules, do's and don'ts. These are authoritative and override everything else.

## Step 2: Load Visual References

Read every image file in `.claude/design-references/`. Then read `.claude/design-references/notes.md` for captions explaining what to take from each image.

For each image, extract and note:
- **Layout structure** — how is space divided? what is the grid density?
- **Color usage** — what is prominent vs restrained? how is the palette distributed?
- **Typography feel** — size contrast between hierarchy levels, weight choices, label treatment
- **Component patterns** — how are cards, tables, data rows, and charts handled?
- **Emotional register** — clinical, warm, minimal, dense, editorial?

## Step 3: Reconcile References Against the Design System

Map what you observed in the reference images against `DESIGN.md`. Where they align, reinforce. Where they differ, `DESIGN.md` wins — the images are inspiration, not spec.

Call out any specific visual pattern from the references worth carrying forward (e.g. "the row hover treatment in image 2 fits the flat-by-default rule and is worth replicating").

## Step 4: State Your Intent Before Writing Any Code

Before writing a single line, describe in 2–3 sentences:
- Which visual patterns from the references you are applying and why
- How they map to the design system
- What the component will look and feel like

Wait for confirmation before proceeding to implementation.
