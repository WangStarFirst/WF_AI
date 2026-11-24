---
name: wf-design
description: "WF 設計階段:從專案概述出發,參考相關專案,用 grill-with-docs 或 wayfinder 完成設計,必要時做 prototype,最後畫出架構並詢問是否開始實作。Use when the user wants to design or plan a project, or runs /wf-design."
argument-hint: "專案概述"
---

# WF Design

先讀 [conventions.md](../../../shared/conventions.md),步驟類型與 brief 格式照它做。

## 1. 專案概述

- 已有 `docs/project-brief.md` → 依「產出已存在」處理;使用者這次有帶參數時,建議改成「用參數更新」。
- 沒有 → 用參數當概述;沒有參數就請使用者提供(幾句話即可)。依 brief 格式寫成 `docs/project-brief.md`。

完成條件:`docs/project-brief.md` 存在,使用者已看過。

## 2. 開發習慣

以 **wf** 方式執行 `wf-ask-habit`。

完成條件:wf-ask-habit 已回報加入的習慣,或使用者選擇跳過。

## 3. 相關專案調查

已有 `docs/related-work.md` 時依「產出已存在」處理;否則以 **wf** 方式執行 `wf-relate-work`。

完成條件:`docs/related-work.md` 存在,brief 已依採用的建議更新。

## 4. 選擇設計方式

依 brief 與調查結果判斷設計規模,用 **ask** 詢問,附上建議與理由:

- **grill-with-docs**:決策一個 session 能收斂完。邊問邊寫 ADR 與 `GLOSSARY.md`。
- **wayfinder**:決策多、未知多,超過一個 session。決策拆成 issue tracker 上的 tickets,逐一解決。

完成條件:使用者已選定其中一種。

## 5. 執行設計

以 **upstream** 方式執行選定的 skill,把 brief 當作起點。

- 遇到**無法靠訪談回答的問題**(要親眼看到、實際操作,或要跑跑看才知道)→ 以 **wf** 方式執行 `wf-prototype`,帶上這個問題;拿到結論後回到訪談。
- wayfinder 的 map 還沒走完就要換 session → **manual**:`/wf-handoff 繼續 wf-design 的 wayfinder`,新 session 執行 `/wf-design`(步驟 1–4 會沿用既有結果)。

完成條件:grill-with-docs 的設計樹沒有未決分支;或 wayfinder 的 map 已沒有 open 的決策 ticket。

## 6. 收尾

1. 以 **wf** 方式執行 `wf-project-review`。
2. 用 **ask** 詢問:「設計完成,要開始實作嗎?」選項:開始實作(建議)/ 還要修改設計。
   - 開始實作 → 從 `/wf-lazy-start` 進來的就回到它的下一步;否則請使用者輸入 `/wf-implement`。
   - 修改設計 → 回到第 5 步。

完成條件:架構報告已產出,使用者已回答是否開始實作。
