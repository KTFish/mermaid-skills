#!/usr/bin/env bash
# export_diagrams.sh — extract fenced mermaid blocks from a Markdown file
# and render each to PNG and/or SVG using mmdc (Mermaid CLI).
#
# Usage:
#   export_diagrams.sh <md_file> [--format png|svg|both]
#
# Stdout:  JSON array — one entry per diagram:
#   [{"input":"<tmp.mmd>","output":"<out_path>","status":"ok|error","message":"<detail>"}]
#
# Stderr:  diagnostic messages (mmdc output, parse warnings)
#
# Exit:    0 if all diagrams exported successfully; 1 if any failed.
#
# Dependencies: mmdc (npm install -g @mermaid-js/mermaid-cli), awk, mktemp

set -euo pipefail

# argument parsing
usage() {
  awk '/^#!/{next} /^#/{sub(/^# ?/,""); print; next} /^[^#]/{exit}' "$0"
  exit 0
}

MD_FILE=""
FORMAT="both"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage ;;
    --format)  FORMAT="$2"; shift 2 ;;
    --format=*) FORMAT="${1#--format=}"; shift ;;
    -*)        echo "Unknown flag: $1" >&2; exit 1 ;;
    *)         MD_FILE="$1"; shift ;;
  esac
done

if [[ -z "$MD_FILE" ]]; then
  echo "Error: <md_file> argument is required." >&2
  usage
fi

if [[ ! -f "$MD_FILE" ]]; then
  echo "Error: file not found: $MD_FILE" >&2
  exit 1
fi

case "$FORMAT" in
  png|svg|both) ;;
  *) echo "Error: --format must be png, svg, or both (got: $FORMAT)" >&2; exit 1 ;;
esac

# helpers
MD_DIR="$(cd "$(dirname "$MD_FILE")" && pwd)"
MD_STEM="$(basename "$MD_FILE" .md)"
TMPDIR_LOCAL="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_LOCAL"' EXIT

json_entry() {
  local input="$1" output="$2" status="$3" message="$4"
  # Escape double-quotes in message
  message="${message//\"/\\\"}"
  printf '{"input":"%s","output":"%s","status":"%s","message":"%s"}' \
    "$input" "$output" "$status" "$message"
}

# extract mermaid blocks
# Writes one .mmd file per fenced block to $TMPDIR_LOCAL/diagram_N.mmd
awk '
  /^```mermaid/ { in_block=1; block=""; next }
  /^```/ && in_block { in_block=0; count++; print block > (tmpdir "/diagram_" count ".mmd") }
  in_block { block = block $0 "\n" }
' tmpdir="$TMPDIR_LOCAL" "$MD_FILE"

MMD_FILES=("$TMPDIR_LOCAL"/diagram_*.mmd)

if [[ ${#MMD_FILES[@]} -eq 0 ]] || [[ ! -f "${MMD_FILES[0]}" ]]; then
  echo "[]"
  exit 0
fi

# render
ENTRIES=()
FAILED=0

render_one() {
  local mmd_file="$1" fmt="$2"
  local idx
  idx="$(basename "$mmd_file" .mmd | sed 's/diagram_//')"
  local count="${#MMD_FILES[@]}"
  local suffix=""
  [[ "$count" -gt 1 ]] && suffix="_${idx}"
  local out_path="${MD_DIR}/${MD_STEM}${suffix}.${fmt}"

  local mmdc_out
  if mmdc_out="$(mmdc --input "$mmd_file" --output "$out_path" 2>&1)"; then
    echo "$mmdc_out" >&2
    ENTRIES+=("$(json_entry "$mmd_file" "$out_path" "ok" "")")
  else
    echo "$mmdc_out" >&2
    ENTRIES+=("$(json_entry "$mmd_file" "$out_path" "error" "$mmdc_out")")
    FAILED=1
  fi
}

for mmd in "${MMD_FILES[@]}"; do
  case "$FORMAT" in
    png)  render_one "$mmd" png ;;
    svg)  render_one "$mmd" svg ;;
    both) render_one "$mmd" png; render_one "$mmd" svg ;;
  esac
done

# emit JSON
printf '['
for i in "${!ENTRIES[@]}"; do
  [[ $i -gt 0 ]] && printf ','
  printf '%s' "${ENTRIES[$i]}"
done
printf ']\n'

exit $FAILED
