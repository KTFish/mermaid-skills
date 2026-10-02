---
name: export-mermaid
description: >-
  Use this skill when the user wants to export, render, or convert Mermaid
  diagrams from Markdown files (.md) to image files (PNG or SVG). Activate
  on requests to "export diagrams", "render mermaid to image", "extract and
  convert mermaid blocks", or "generate PNG/SVG from .md". Does NOT cover
  editing diagram source (use draw-mermaid) or LaTeX integration.
---

# Export-mermaid

Exports fenced ` ```mermaid ``` ` blocks from `.md` files to `.png` and/or
`.svg` image files using `mmdc` (Mermaid CLI).

## Process

### 1. Anchor

Before doing anything, restate:
- The target `.md` file(s)
- The requested output format (`png` | `svg` | `both`)
- The expected output location (same directory as the source file, same stem)

### 2. Probe mmdc

Run via the shell tool:

```
mmdc --version
```

If the command fails or is not found:

> Read `references/mmdc-usage.md` for installation instructions and
> supported CLI flags. Surface the install guidance to the user and halt.

### 3. Export

Invoke the bundled script via the shell tool:

```
bash scripts/export_diagrams.sh <md_file_path> [--format png|svg|both]
```

The script extracts every fenced mermaid block from the file, runs `mmdc`
on each, and emits a JSON array to stdout with per-diagram results:

```json
[{"input": "tmp.mmd", "output": "diagram.png", "status": "ok", "message": ""}]
```

Default format when `--format` is omitted: `both`.

### 4. Verify (S4)

For each output path in the JSON result, run via the shell tool:

```
test -s <output_path> && echo ok || echo fail
```

This is a deterministic file-existence and non-zero-size check. Do **not**
assert success from the script's stdout alone — the shell check is the
authoritative gate.

### 5. On failure

If any output file fails the size check or the script exits non-zero:

> Read `references/troubleshooting.md` for common render errors and
> resolution steps. Report the failing diagrams to the user with the
> error message from the JSON result. Retry once if the error suggests
> a transient cause; otherwise escalate to the user.

### 6. Report

Present the user with the list of successfully exported output paths. Group
failures separately with their error messages.

## Scripts

- `scripts/export_diagrams.sh` — extracts mermaid blocks and runs mmdc.
  Run with `--help` to see all flags and the stdout JSON schema.

## Out of scope

- Editing or authoring diagram source → use `draw-mermaid`
- Embedding exported images into LaTeX documents → not covered here
- PDF, EPS, or any LaTeX-native format → not covered here
- CI/CD trigger automation → configure separately in your workflow tool
