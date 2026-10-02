# Troubleshooting

Load this file when the export script exits non-zero or any output file fails
the `test -s` size check.

## Puppeteer / Chromium not found

**Error message:**
```
Error: Failed to launch the browser process
```
or
```
Could not find expected browser (chrome) locally
```

**Cause:** mmdc depends on Puppeteer's bundled Chromium. The post-install
script may have been skipped.

**Resolution:**
```bash
# Re-run Puppeteer's install script
node node_modules/puppeteer/install.js

# Or, force a clean reinstall of the CLI
npm uninstall -g @mermaid-js/mermaid-cli
npm install -g @mermaid-js/mermaid-cli
```

On Linux servers without a display:
```bash
# Install required system libraries (Debian/Ubuntu)
apt-get install -y libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
  libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
  libgbm1 libasound2

# Then set the no-sandbox flag if running as root
export PUPPETEER_ARGS="--no-sandbox"
```

## Unsupported syntax token

**Error message:**
```
UnknownDiagramError: No diagram type detected
```
or a parse error referencing a specific line.

**Cause:** The mermaid block contains syntax the installed mmdc version does
not support, or the diagram type identifier is misspelled.

**Resolution:**
1. Open the failing `.mmd` file and check the first line (diagram type keyword).
2. Run `mmdc --version` and compare against the mermaid-js changelog for the
   feature that was used.
3. Update mmdc: `npm install -g @mermaid-js/mermaid-cli@latest`
4. If the block uses a newer syntax not yet released, simplify the diagram or
   pin to a version that supports it.

## Output file is zero bytes

**Symptom:** The script exits 0 but `test -s <output>` fails.

**Cause:** mmdc rendered an empty canvas (e.g. diagram is syntactically valid
but produces no visible content) or silently wrote an empty file on an error
path.

**Resolution:**
1. Run mmdc directly with `--verbose`:
   ```bash
   mmdc --input diagram.mmd --output diagram.png --verbose
   ```
2. Check for warnings about empty diagrams or missing data.
3. Validate the diagram source in draw-mermaid or the Mermaid live editor
   (https://mermaid.live) before re-exporting.

## Permission denied

**Error message:**
```
EACCES: permission denied, open '<output_path>'
```

**Cause:** The output directory is not writable by the current user.

**Resolution:**
```bash
# Check permissions
ls -la "$(dirname <output_path>)"

# Fix
chmod u+w "$(dirname <output_path>)"
```

## Font rendering issues (Linux headless)

**Symptom:** Text in the exported image appears as boxes or is missing.

**Cause:** Missing system fonts in a headless environment.

**Resolution:**
```bash
# Debian/Ubuntu
apt-get install -y fonts-noto fonts-liberation

# Then re-run the export
```

## Enabling verbose output for any error

Add `--verbose` to the mmdc call to get the full Puppeteer + Mermaid render
log. The script passes all mmdc stderr to its own stderr, so you will see it
in the terminal:

```bash
mmdc --input diagram.mmd --output diagram.png --verbose
```
