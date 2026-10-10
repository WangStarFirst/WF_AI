#!/usr/bin/env bash
# Read-only fact sheet about a project, for wf-project-review.
# Usage: inventory.sh [project-root]   (default: current directory)
# Prints Markdown. Never modifies anything.
set -uo pipefail
ROOT="${1:-.}"
cd "$ROOT" || { echo "cannot enter $ROOT" >&2; exit 1; }
IS_GIT=0; git rev-parse --git-dir >/dev/null 2>&1 && IS_GIT=1

last_change() { # path -> date of last commit touching it, or "(未納入版控)"
  if [ "$IS_GIT" = 1 ]; then
    d="$(git log -1 --format=%cs -- "$1" 2>/dev/null)"; echo "${d:-(未納入版控)}"
  else echo "(非 git)"; fi
}
fm() { # file key -> frontmatter value
  awk -v k="$2" 'NR==1&&$0!="---"{exit} NR>1&&$0=="---"{exit} index($0,k":")==1{sub(k": *","");gsub(/^"|"$/,"");print;exit}' "$1"
}

echo "## 基本資訊"
echo "- 目錄:\`$(pwd)\`"
if [ "$IS_GIT" = 1 ]; then
  echo "- 分支:\`$(git branch --show-current)\`;最近提交:$(git log -1 --format='%cs %s' 2>/dev/null)"
  echo "- Remote:$(git remote -v | awk '{print $2}' | sort -u | tr '\n' ' ')"
  echo "- 提交數:$(git rev-list --count HEAD 2>/dev/null)"
fi

echo; echo "## 必備文件"
echo "| 檔案 | 狀態 | 最後變更 |"; echo "| --- | --- | --- |"
for f in README.md LICENSE CLAUDE.md AGENTS.md GLOSSARY.md docs/agents/issue-tracker.md docs/agents/triage-labels.md docs/agents/domain.md; do
  if [ -e "$f" ]; then echo "| $f | 存在 | $(last_change "$f") |"; else echo "| $f | **缺漏** | — |"; fi
done
ls LICENSE* >/dev/null 2>&1 && echo "(另有:$(ls LICENSE* | tr '\n' ' '))"
[ -d docs/adr ] && echo "- ADR:$(ls docs/adr | wc -l) 份"

echo; echo "## Agent 架構"
if [ -d .claude/skills ]; then
  n=$(find .claude/skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l)
  echo "### Skills($n 個,位於 .claude/skills/)"
  echo "| 名稱 | 呼叫方式 | 說明 |"; echo "| --- | --- | --- |"
  for f in $(find .claude/skills -mindepth 2 -maxdepth 2 -name SKILL.md | sort); do
    mode="模型與使用者"; [ "$(fm "$f" disable-model-invocation)" = true ] && mode="僅使用者"
    echo "| $(fm "$f" name) | $mode | $(fm "$f" description | cut -c1-90) |"
  done
else echo "- 無 .claude/skills/"; fi
if [ -d .claude/agents ]; then
  echo "### Subagents(.claude/agents/)"
  for f in .claude/agents/*.md; do [ -e "$f" ] && echo "- $(fm "$f" name):$(fm "$f" description | cut -c1-90)"; done
else echo "- 無 .claude/agents/"; fi
for f in .claude/settings.json .claude/settings.local.json .mcp.json .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
  [ -e "$f" ] && echo "- 設定:\`$f\`(最後變更 $(last_change "$f"))"
done
for f in CLAUDE.md AGENTS.md; do [ -e "$f" ] && echo "- \`$f\`:$(wc -l < "$f") 行"; done

echo; echo "## 文件健康檢查"
echo "### 指向不存在檔案的連結"
out="$(while IFS= read -r md; do
  dir="$(dirname "$md")"
  grep -oE '\]\(([^)#]+)(#[^)]*)?\)' "$md" 2>/dev/null | sed -E 's/^\]\(([^)#]+).*/\1/' | while read -r link; do
    case "$link" in http*|mailto:*|/*) continue ;; esac
    [ -e "$dir/$link" ] || echo "- \`$md\` → \`$link\`"
  done
done < <(find . -name '*.md' -not -path './.git/*' -not -path '*/node_modules/*' | sort))"
echo "${out:-- 無}"

echo "### 提到但不存在的 docs/ 與 .claude/ 路徑"
out="$(for md in CLAUDE.md AGENTS.md README.md; do
  [ -e "$md" ] || continue
  grep -oE '`(docs|\.claude)/[A-Za-z0-9_./*-]+`' "$md" | tr -d '`' | sort -u | while read -r p; do
    case "$p" in *'*'*) continue ;; esac
    [ -e "$p" ] || echo "- \`$md\` 提到 \`$p\`,但不存在"
  done
done)"
echo "${out:-- 無}"

if [ -e GLOSSARY.md ]; then
  echo "### GLOSSARY 術語在其他檔案的出現次數"
  grep -oE '^\*\*[^*]+\*\*' GLOSSARY.md | tr -d '*' | while read -r term; do
    base="$(echo "$term" | sed -E 's/[(（].*//; s/ *$//')"
    c=$(grep -rIl --exclude-dir=.git --exclude=GLOSSARY.md -F -- "$base" . 2>/dev/null | wc -l)
    echo "- $term:出現在 $c 個檔案"
  done
fi

echo; echo "## 檔案結構(兩層,不含 .git 與上游複製的 skills)"
find . -maxdepth 2 -not -path './.git*' -not -path './.claude/skills/*' | sort | sed 's|^\./||' | grep -v '^\.$' | sed 's/^/- /'
