---
name: wf-lazy-add
description: "開發中增刪改功能:釐清變更 → 同步 brief 與 ADR → 實作,中間不停。"
argument-hint: "要增、刪、改的功能描述"
disable-model-invocation: true
---

# WF Lazy Add

先讀 [conventions.md](../../../shared/conventions.md)。需要 `docs/project-brief.md`。

## 1. 讀取現況

沒有參數 → 用 **ask** 請使用者描述要增、刪、改什麼。讀取 brief、`docs/adr/`、`GLOSSARY.md`,以及和這次變更相關的程式碼。

完成條件:已知道變更內容,以及它影響哪些功能、ADR 與模組。

## 2. 釐清變更

以 **upstream** 方式執行 `grill-with-docs`,起點是這次的變更描述與第 1 步找到的影響範圍。

完成條件:這次變更的設計樹沒有未決分支。

## 3. 同步文件

- **新增/修改**:更新 brief 的「核心功能」;新決策寫成 ADR。
- **刪除**:功能從「核心功能」移到「不做的事」,註明日期與原因;相關 ADR 不刪除,狀態改為「已廢止(日期、原因、取代者)」。

完成條件:brief 與 ADR 已反映這次變更,使用者已看過差異。

## 4. 實作

讀取 [wf-implement](../wf-implement/SKILL.md) 照著做,規格是第 3 步更新後的 brief 與 ADR。

完成條件:wf-implement 已結束。

## 5. 架構圖

有刪除功能或新增模組時,以 **wf** 方式執行 `wf-project-review`;純修改則略過。

完成條件:已更新架構圖,或已說明略過的原因。
