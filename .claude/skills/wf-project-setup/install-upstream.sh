#!/usr/bin/env bash
# Install mattpocock/skills into a project's skills directory.
#
#   install-upstream.sh --target <skills-dir> --plan
#   install-upstream.sh --target <skills-dir> [--overwrite a,b] [--sidecar c,d]
#
# --plan       download + validate, print one `status<TAB>name` line per skill
#              (new | same | conflict) and the upstream SHA; change nothing.
# --overwrite  replace these conflicting skills with the upstream version.
# --sidecar    keep the local skill, save upstream next to it as <name>.upstream/.
# Conflicts named in neither list are skipped.
#
# Everything is downloaded and validated in a temp dir first. On any failure
# the target is left untouched and the script exits non-zero.
set -euo pipefail

UPSTREAM_URL="${WF_UPSTREAM_URL:-https://github.com/mattpocock/skills}"
TARGET="" PLAN=0 OVERWRITE="" SIDECAR=""

while [ $# -gt 0 ]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --plan) PLAN=1; shift ;;
    --overwrite) OVERWRITE="$2"; shift 2 ;;
    --sidecar) SIDECAR="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done
[ -n "$TARGET" ] || { echo "--target is required" >&2; exit 2; }

in_list() { case ",$2," in *",$1,"*) return 0 ;; *) return 1 ;; esac; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone -q --depth 1 "$UPSTREAM_URL" "$WORK/up" \
  || { echo "ERROR: could not download $UPSTREAM_URL; nothing was changed" >&2; exit 1; }
SHA="$(git -C "$WORK/up" rev-parse HEAD)"
MANIFEST="$WORK/up/.claude-plugin/plugin.json"
[ -f "$MANIFEST" ] && [ -f "$WORK/up/LICENSE" ] \
  || { echo "ERROR: upstream layout changed (plugin.json or LICENSE missing); nothing was changed" >&2; exit 1; }

# skill paths listed by the upstream plugin manifest
mapfile -t PATHS < <(python3 -I -c '
import json, sys
for p in json.load(open(sys.argv[1]))["skills"]:
    print(p)' "$MANIFEST")
[ "${#PATHS[@]}" -gt 0 ] || { echo "ERROR: manifest lists no skills; nothing was changed" >&2; exit 1; }

NAMES=()
for p in "${PATHS[@]}"; do
  src="$WORK/up/$p"
  [ -f "$src/SKILL.md" ] || { echo "ERROR: $p has no SKILL.md; nothing was changed" >&2; exit 1; }
  NAMES+=("$(basename "$p")")
done

status_of() { # name src
  if [ ! -e "$TARGET/$1" ]; then echo new
  elif diff -rq "$2" "$TARGET/$1" >/dev/null 2>&1; then echo same
  else echo conflict; fi
}

if [ "$PLAN" = 1 ]; then
  echo "sha	$SHA"
  for i in "${!NAMES[@]}"; do
    printf '%s\t%s\n' "$(status_of "${NAMES[$i]}" "$WORK/up/${PATHS[$i]}")" "${NAMES[$i]}"
  done
  exit 0
fi

# stage inside the target so the final mv is on one filesystem
mkdir -p "$TARGET"
STAGE="$(mktemp -d "$TARGET/.wf-staging.XXXXXX")"
trap 'rm -rf "$WORK" "$STAGE"' EXIT
declare -a MOVES=() REPORT=()
for i in "${!NAMES[@]}"; do
  n="${NAMES[$i]}"; src="$WORK/up/${PATHS[$i]}"
  case "$(status_of "$n" "$src")" in
    new)  cp -R "$src" "$STAGE/$n"; MOVES+=("$n:$n"); REPORT+=("installed	$n") ;;
    same) REPORT+=("unchanged	$n") ;;
    conflict)
      if in_list "$n" "$OVERWRITE"; then
        cp -R "$src" "$STAGE/$n"; MOVES+=("$n:$n:replace"); REPORT+=("overwritten	$n")
      elif in_list "$n" "$SIDECAR"; then
        cp -R "$src" "$STAGE/$n.upstream"; MOVES+=("$n.upstream:$n.upstream:replace"); REPORT+=("sidecar	$n")
      else
        REPORT+=("skipped	$n")
      fi ;;
  esac
done
cp "$WORK/up/LICENSE" "$STAGE/LICENSE-mattpocock-skills"
MOVES+=("LICENSE-mattpocock-skills:LICENSE-mattpocock-skills:replace")

# stage is complete and valid: commit it
for m in "${MOVES[@]}"; do
  IFS=: read -r from to mode <<<"$m"
  [ "${mode:-}" = replace ] && rm -rf "${TARGET:?}/$to"
  mv "$STAGE/$from" "$TARGET/$to"
done

# record the upstream version in README.md between markers
python3 -I - "$TARGET/README.md" "$UPSTREAM_URL" "$SHA" "$(date +%F)" <<'PY'
import re, sys
path, url, sha, day = sys.argv[1:5]
start, end = "<!-- wf-upstream:start -->", "<!-- wf-upstream:end -->"
block = (f"{start}\n"
         f"上游來源:[{url.split('github.com/')[-1]}]({url})(MIT 授權,見 `LICENSE-mattpocock-skills`)\n"
         f"安裝時的 commit:`{sha}`(安裝日期 {day})\n"
         f"{end}")
try:
    text = open(path, encoding="utf-8").read()
except FileNotFoundError:
    text = "# 專案技能(Project Skills)\n\n"
if start in text and end in text:
    text = re.sub(re.escape(start) + r".*?" + re.escape(end), block, text, flags=re.S)
else:
    text = text.rstrip("\n") + "\n\n" + block + "\n"
open(path, "w", encoding="utf-8").write(text)
PY

echo "sha	$SHA"
printf '%s\n' "${REPORT[@]}"
