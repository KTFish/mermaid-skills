# mmdc usage

Load this file when the `mmdc --version` probe fails, when the user asks
how to install mmdc, or when you need the full flag reference for a custom
invocation.

## Installation

mmdc ships as part of `@mermaid-js/mermaid-cli`. Install globally with npm:

```
npm install -g @mermaid-js/mermaid-cli
```

Or use npx for a one-off invocation without a global install:

```
npx --yes @mermaid-js/mermaid-cli@latest mmdc --input diagram.mmd --output diagram.png
```

Verify the install:

```
mmdc --version
```

## Key flags

| Flag | Description | Example |
|---|---|---|
| `--input` | Path to the `.mmd` source file (required) | `--input diagram.mmd` |
| `--output` | Path for the output file; extension sets format | `--output diagram.png` |
| `--outputFormat` | Override output format: `png`, `svg`, `pdf` | `--outputFormat svg` |
| `--theme` | Mermaid theme: `default`, `dark`, `neutral`, `forest` | `--theme neutral` |
| `--backgroundColor` | Background colour (CSS value or `transparent`) | `--backgroundColor white` |
| `--width` | Output width in pixels (PNG only) | `--width 1200` |
| `--height` | Output height in pixels (PNG only) | `--height 800` |
| `--verbose` | Print detailed render output — useful when diagnosing errors | `--verbose` |
| `--configFile` | Path to a Mermaid config JSON file | `--configFile mermaid.json` |
| `--cssFile` | Inject custom CSS into the render | `--cssFile custom.css` |

## Version pinning

Pin the version in CI or shared scripts to avoid breaking changes:

```
npx @mermaid-js/mermaid-cli@11.4.2 mmdc --input diagram.mmd --output diagram.png
```

Check the current stable release: https://github.com/mermaid-js/mermaid-cli/releases

## Supported output formats

| Format | Extension | Notes |
|---|---|---|
| PNG | `.png` | Rasterised; width/height flags apply |
| SVG | `.svg` | Vector; scales without quality loss |
| PDF | `.pdf` | Out of scope for this skill |

## Puppeteer dependency

mmdc uses Puppeteer (headless Chromium) to render diagrams. If Puppeteer
is not installed or its Chromium binary is missing, you will see errors like
`Error: Failed to launch the browser process`. See
`references/troubleshooting.md` for resolution steps.
