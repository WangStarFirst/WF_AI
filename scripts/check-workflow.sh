#!/usr/bin/env bash
# 檢查 workflow.json、wf skill 目錄、plugin.json、docs/index.html 是否一致。
#   scripts/check-workflow.sh        只檢查,不一致時 exit 1
#   scripts/check-workflow.sh --fix  把 workflow.json 同步嵌入 docs/index.html
set -euo pipefail
cd "$(dirname "$0")/.."
exec python3 -I - "$@" <<'PY'
import json, re, sys, pathlib

root = pathlib.Path(".")
fix = "--fix" in sys.argv[1:]
errors = []
wf = json.loads((root / "workflow.json").read_text(encoding="utf-8"))

ids = [s["id"] for s in wf["skills"]]
id_set = set(ids)
if len(ids) != len(id_set):
    errors.append("workflow.json: skills 有重複的 id")

dirs = {p.name for p in (root / ".claude/skills").iterdir() if p.is_dir() and p.name.startswith("wf-")}
for x in sorted(id_set - dirs): errors.append(f"workflow.json 有 {x},但 .claude/skills/{x}/ 不存在")
for x in sorted(dirs - id_set): errors.append(f".claude/skills/{x}/ 存在,但 workflow.json 沒有列出")

plugin = json.loads((root / ".claude-plugin/plugin.json").read_text(encoding="utf-8"))
plugin_ids = {pathlib.PurePosixPath(p).name for p in plugin["skills"]}
for x in sorted(id_set - plugin_ids): errors.append(f"plugin.json 沒有列出 {x}")
for x in sorted(plugin_ids - id_set): errors.append(f"plugin.json 列出 {x},但 workflow.json 沒有")

kinds = set(wf["stepKinds"])
if wf["entry"] not in id_set: errors.append(f"entry {wf['entry']} 不是已知的 skill")
for s in wf["skills"]:
    sid = s["id"]
    if s["invocation"] not in ("user", "model"):
        errors.append(f"{sid}: invocation 必須是 user 或 model")
    md = root / ".claude/skills" / sid / "SKILL.md"
    if md.exists():
        text = md.read_text(encoding="utf-8")
        m = re.match(r"---\n(.*?)\n---\n", text, re.S)
        fm = m.group(1) if m else ""
        name = re.search(r"^name:\s*(\S+)", fm, re.M)
        if not name or name.group(1) != sid:
            errors.append(f"{sid}: SKILL.md 的 name 與目錄名稱不符")
        disabled = re.search(r"^disable-model-invocation:\s*true", fm, re.M) is not None
        if disabled != (s["invocation"] == "user"):
            errors.append(f"{sid}: workflow.json 的 invocation={s['invocation']} 與 SKILL.md 的 disable-model-invocation 不一致")
    else:
        errors.append(f"{sid}: 缺少 SKILL.md")
    for i, step in enumerate(s["steps"], 1):
        if step["kind"] not in kinds:
            errors.append(f"{sid} 第 {i} 步: 未知的 kind {step['kind']}")
        if step["kind"] == "wf" and step.get("ref") not in id_set:
            errors.append(f"{sid} 第 {i} 步: 參照不存在的 wf skill {step.get('ref')}")
        if step["kind"] in ("upstream", "manual") and not step.get("ref"):
            errors.append(f"{sid} 第 {i} 步: {step['kind']} 步驟需要 ref")
for st in wf["stages"]:
    if st["next"] not in id_set:
        errors.append(f"stage {st['id']}: next {st['next']} 不是已知的 skill")

# docs/index.html 內嵌的 workflow.json
html_path = root / "docs/index.html"
html = html_path.read_text(encoding="utf-8")
pat = re.compile(r'(<script id="workflow-data" type="application/json">)(.*?)(</script>)', re.S)
m = pat.search(html)
if not m:
    errors.append("docs/index.html 找不到 <script id=\"workflow-data\">")
else:
    embedded = json.loads(m.group(2)) if m.group(2).strip() else None
    if embedded != wf:
        if fix:
            body = "\n" + json.dumps(wf, ensure_ascii=False, indent=2).replace("</", "<\\/") + "\n"
            html_path.write_text(pat.sub(lambda mm: mm.group(1) + body + mm.group(3), html, count=1), encoding="utf-8")
            print("已把 workflow.json 同步到 docs/index.html")
        else:
            errors.append("docs/index.html 內嵌的流程與 workflow.json 不同步(執行 scripts/check-workflow.sh --fix)")

if errors:
    print("✗ 檢查失敗:")
    for e in errors: print("  -", e)
    sys.exit(1)
print(f"✓ 一致:{len(ids)} 個 wf skill、{len(wf['stages'])} 個階段")
PY
