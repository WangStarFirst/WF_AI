---
name: wf-relate-work
description: "調查至少 3 款相關專案或競品,逐條提出補充/改進/簡化/刪除建議,採用的寫回專案概述。Use when the user wants related work, competitor or prior-art research for their project."
---

# WF Relate Work

先讀 [conventions.md](../../../shared/conventions.md)。輸入是 `docs/project-brief.md`;不存在就先請使用者執行 `/wf-design`。

## 1. 調查(subagent)

用 Agent 工具派一個 subagent,prompt 包含 brief 全文,並要求:

- 用網路搜尋找出**至少 3 款**相關專案或競品(開源專案、商業產品、論文都算),優先找和 brief 的「核心功能」重疊最多的。
- 每款回傳:名稱、網址、一句話定位、和本專案重疊的功能、它有而本專案沒有的、它刻意不做的、值得借鏡的設計。
- 每個結論附上來源網址;查不到的寫「查無資料」。

完成條件:回傳至少 3 款,每款都有網址。不足 3 款就再派一次,換關鍵字。

## 2. 寫成文件

寫成 `docs/related-work.md`:日期、每款專案一節、最後一張比較表(功能 × 專案)。

## 3. 逐條建議

依調查結果,對 brief 提出建議,每條標上一個類別:

- **補充**:別人有、本專案也該有的
- **改進**:本專案有,但別人做得更好的
- **簡化**:可以做得更少、更單純的
- **刪除**:別人證明沒必要、或已被做爛的

每條附上依據(哪款專案)。用 **ask** 讓使用者逐條決定採用與否,一次最多 4 條。

## 4. 寫回 brief

把採用的建議寫進 `docs/project-brief.md` 對應段落,沒採用的記在 `docs/related-work.md` 最後的「未採用建議」,附使用者給的理由。

完成條件:每條建議都有「採用 / 未採用」的結果。回報一句話摘要給呼叫端。
