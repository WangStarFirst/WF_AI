---
name: wf-handoff
description: "直接執行上游 handoff:把目前的對話整理成交接文件,給新 session 接手。"
argument-hint: "下一個 session 要做什麼"
disable-model-invocation: true
---

# WF Handoff

以 [conventions.md](../../../shared/conventions.md) 的 **upstream** 方式執行 `handoff`,把使用者給的參數原封不動帶入。行為與上游 `/handoff` 相同,只有存放位置不同:

- 存到 Target project 的 `docs/handoffs/YYYY-MM-DD-<主題>.md`(主題取自參數或對話,用英文小寫加連字號),不存在系統暫存目錄。雲端 session 換 session 會換容器,存在專案裡新 session 才讀得到。
- 寫完後回報檔案路徑,並詢問要不要 commit(雲端 session 要 commit 並 push,新 session 才拿得到)。
