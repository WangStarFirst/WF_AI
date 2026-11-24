---
name: wf-lazy-start
description: "一鍵開始:依序執行 wf-project-setup → wf-design → wf-implement。"
argument-hint: "專案概述(可省略,之後會問)"
disable-model-invocation: true
---

# WF Lazy Start

先讀 [conventions.md](../../../shared/conventions.md)。以下每步都以 **wf** 方式執行,步驟之間直接銜接,不另外詢問。

1. **wf-project-setup**。完成條件:它的收尾清單已回報。失敗就停在這裡,告訴使用者修好後重新執行 `/wf-lazy-start`(已完成的步驟會自動略過)。
2. **wf-design**,參數是使用者給 `/wf-lazy-start` 的專案概述(沒有就不帶)。完成條件:wf-design 已問過「是否開始實作」。
3. **wf-implement**:使用者在上一步同意開始實作才執行。不同意就結束,告訴使用者之後可以執行 `/wf-implement`,或用 `/wf-help` 查看下一步。完成條件:wf-implement 已結束,或使用者選擇不實作。
