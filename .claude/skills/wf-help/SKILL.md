---
name: wf-help
description: "依專案目前的產出判斷所在階段,告訴使用者下一步與可用的 wf skill。Use when the user asks what to do next, where they are in the workflow, or which skill to use."
---

# WF Help

1. 讀取 [workflow.json](../../../workflow.json)。
2. 依序檢查 `stages`:每個 stage 的 `doneWhen` 全部存在於 Target project(目錄要有至少一個檔案),就算完成。第一個未完成的 stage 是**目前階段**;全部完成就是 `implement`。
3. 回報(繁體中文,10 行以內):
   - 已完成與未完成的階段(一行一個,用 ✅ / ⬜)
   - **下一步**:目前階段的 `next` skill,附上要輸入的 `/指令` 與一句話說明(取自 `skills[].summary`)
   - **隨時可用**:其他 wf skill,一行一個 `/名稱`:summary
4. 偵測不到上游 skill(`.claude/skills/setup-matt-pocock-skills/` 不存在)時,下一步一律是 `/wf-project-setup`。

只讀取,不修改任何檔案。
