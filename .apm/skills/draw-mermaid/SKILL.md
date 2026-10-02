---
name: draw-mermaid
description: >-
  Use this skill when creating, editing, or reviewing Mermaid diagram source
  (.mmd files or markdown-embedded ```mermaid``` blocks). Activate on requests
  to draw, fix, or improve a diagram; to choose layout direction; to apply node
  labels, casing, or structural rules; or to add custom grayscale styling to
  diagram nodes. Does NOT cover rendering to image files or SVG export.
---

# Draw-mermaid

Rules for authoring Mermaid diagram source (`.mmd` files or markdown-embedded
` ```mermaid ``` ` blocks).

## 1. Syntax and labels

- **Multi-word labels**: wrap in square brackets with double quotes:
  `A["My node label"]`
- **Label length**: keep node names short and direct; no parenthesised metadata
  inside labels.
- **Forbidden character**: never use `&` in labels, edges, subgraphs, or
  captions — write "and" instead.

> Read `references/syntax-rules.md` if you need the full quoting rules,
> character-restriction rationale, or encounter a syntax edge case.

## 2. Text casing

All diagram text (subgraph titles, node labels, edge descriptions) must use
**sentence case** — capitalise only the first word and proper nouns.

- Correct: `A["Generated prompts"]`
- Incorrect: `A["Generated Prompts"]`

## 3. Layout and structure

- **Default direction**: `graph TD` (top-down). Switch to `flowchart LR` only
  when space or readability clearly requires it.
- **Complexity limit**: if a diagram feels cluttered, split it into a
  high-level overview (maximum 4 boxes) plus one or more detailed sub-diagrams.

## 4. Custom styling

By default, use standard Mermaid styling. For publication-ready documents
(LaTeX figures, papers), avoid `classDef` rules — they degrade rendering
quality in many exporters.

When custom styling is explicitly requested:

> Read `references/color-palette.md` for the grayscale class definitions,
> hex values, and `:::className` application syntax.

The verbatim `classDef` template for copy-paste is in
`assets/grayscale-classes.mmd`.

## 5. Diagram shape preferences

> Read `references/shape-preferences.md` when the diagram contains human
> actors or C4 Person elements.

## Out of scope

Exporting or rendering diagrams to SVG, PNG, or PDF is **not** part of this
skill. That is a deterministic CLI operation (`mmdc`) and belongs to a
separate `export-mermaid` skill.
