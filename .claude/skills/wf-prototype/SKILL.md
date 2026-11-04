---
name: wf-prototype
description: "反覆做拋棄式 prototype,直到一個設計問題有明確答案,再把結論寫成 ADR。Use when a design question can't be settled by discussion alone and needs something to see or run."
argument-hint: "要回答的設計問題"
---

# WF Prototype

先讀 [conventions.md](../../../shared/conventions.md)。

## 1. 定義問題

把要回答的問題寫成一句**可判定**的話(例如「三層巢狀選單在手機上能不能單手操作?」),並寫下「怎樣算有答案」。和使用者確認後才開始。

## 2. 迴圈

1. 以 **upstream** 方式執行 `prototype`,做一輪拋棄式 prototype。
2. 讓使用者看或操作,問:問題有答案了嗎?
   - 有 → 進入第 3 步。
   - 沒有 → 記下這輪學到什麼、下一輪要改什麼,回到 1。
3. context 快滿時(對話很長、或 prototype 檔案多到難以追蹤),先把目前的學習寫成 `docs/adr/` 的草稿,再走 **manual**:請使用者輸入 `/handoff 繼續 wf-prototype:<問題>`,到新 session 執行 `/wf-prototype <問題>` 接手。

## 3. 寫下結論

- 結論是架構或取捨決策 → 寫成 ADR,放在 `docs/adr/`(格式依專案的 `docs/agents/domain.md`)。
- 結論只影響範圍或需求 → 寫回 `docs/project-brief.md`。
- 記下 prototype 檔案的位置,詢問要「刪除(建議)」或「保留」。

完成條件:問題有一句話的答案,已寫進 ADR 或 brief。把答案回報給呼叫端。
