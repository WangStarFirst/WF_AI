# WF 共用規則

所有 wf skill 都依照這份規則。**Target project** 指目前的工作目錄(使用者正在做的專案)。對話與產出一律用繁體中文。

## 執行步驟的方式

每個步驟的類型與 `workflow.json` 的 `stepKinds` 一致:

- **wf**:另一個 wf skill。可被模型呼叫的(`wf-design`、`wf-relate-work`、`wf-prototype`、`wf-project-review`、`wf-help`)用 Skill 工具呼叫;只能手動執行的(`wf-project-setup`、`wf-implement`)讀取它的 SKILL.md(與本 skill 同層的 `../<名稱>/SKILL.md`)照著做。
- **upstream**:上游 mattpocock skill。上游 skill 多半設了 `disable-model-invocation`,Skill 工具叫不到,所以:
  1. 讀取 Target project 的 `.claude/skills/<名稱>/SKILL.md` 全文。
  2. 在同一個 session 照著做;它提到的同層檔案(例如 `UI.md`)從同一個目錄讀取。
  3. 檔案不存在 → 停下來,請使用者先執行 `/wf-project-setup`。
- **manual**:需要開新 session 的步驟。停下來,告訴使用者:要輸入的完整 `/指令`、新 session 要做什麼、做完後回到哪一步。不要自己模擬這一步。
- **subagent**:用 Agent 工具交給 subagent,prompt 寫清楚要回傳的格式;主 session 只保留結論。
- **ask**:用 AskUserQuestion 詢問。把建議選項放第一個並標「(建議)」,附一句理由;等使用者回答再繼續。

## 專案概述(brief)

`docs/project-brief.md` 是專案內容的唯一來源,所有 wf skill 都讀這份。格式:

```markdown
# <專案名稱>

## 一句話目標
## 使用者與情境
## 核心功能
## 不做的事
## 限制(技術、時間、預算)
## 未決問題
```

內容沒有的段落寫「(未定)」,不要猜。修改 brief 時保留使用者原本的用詞。
