---
name: wf-project-review
description: "把目標專案目前的內容與架構畫成一份 HTML(docs/reviews/YYYY-MM-DD.html)。Use when the user wants an overview, diagram, or visual review of their project's content and architecture."
---

# WF Project Review

先讀 [conventions.md](../../../shared/conventions.md)。這個 skill 只新增報告檔,不修改其他檔案。

## 1. 蒐集

讀取下列來源(存在的才讀),記下每個事實出自哪個檔案:

- `docs/project-brief.md`、`docs/related-work.md`
- `docs/adr/*.md`、`GLOSSARY.md`
- wayfinder map 或 spec/tickets(依 `docs/agents/issue-tracker.md` 的方式查詢)
- 程式碼結構:主要目錄、進入點、模組之間的依賴(專案還沒有程式碼就略過)

完成條件:每個來源都已讀取,或確認不存在。

## 2. 繪製

複製 [template.html](./template.html) 到 `docs/reviews/YYYY-MM-DD.html`(同一天已有就加 `-2`、`-3`),替換每個 `<!-- FILL: ... -->`:

1. **專案概覽**:brief 的一句話目標、使用者、核心功能、不做的事。
2. **架構圖**:Mermaid `flowchart`。有程式碼時畫模組與依賴;還沒有時畫 brief 與 ADR 描述的元件。
3. **決策**:每個 ADR 一張卡片(標題、結論、日期)。
4. **術語**:GLOSSARY 的術語表。
5. **相關專案**:related-work 的比較表。
6. **缺口**:未決問題、brief 與 ADR 矛盾之處、還沒有決策的元件。

來源不存在的區塊寫「尚無資料」,不要省略區塊。圖上每個節點都要能在第 1 步的來源找到依據。

## 3. 回報

用瀏覽器或 Playwright 開啟確認 Mermaid 能渲染。回報檔案路徑與 3 行以內的摘要(重點放在缺口)。
