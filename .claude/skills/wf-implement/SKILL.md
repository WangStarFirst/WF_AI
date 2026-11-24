---
name: wf-implement
description: "WF 實作階段:找出並安裝適合的 skill,依規模選擇單一或多 session 實作,完成後做 retro。"
disable-model-invocation: true
---

# WF Implement

先讀 [conventions.md](../../../shared/conventions.md)。輸入是設計階段的產出:`docs/project-brief.md`、`docs/adr/`、`GLOSSARY.md`、wayfinder map(有的話)。

## 1. 找適合的 skill

以 **subagent** 方式執行,prompt 包含 brief 的核心功能、限制與 ADR 標題,要求它依專案用到的技術與任務類型搜尋 skill:

1. **本機**:目前 session 可用的 skill,以及 `.claude/skills/` 已安裝的。
2. **plugin marketplace**:用 SearchPlugins 等可用工具搜尋。
3. **網路**:搜尋 GitHub 與 skill 目錄網站上的 `SKILL.md`。

每個候選回傳:名稱、來源網址、用途、和本專案的關聯、最近更新日期、授權。已安裝的標記「已有」。

把候選整理成表格,用 **ask** 讓使用者勾選要安裝的(multiSelect)。網路來源的 skill 安裝前先讀過 SKILL.md 與其中的腳本,把會執行的指令告訴使用者。

安裝:plugin 用 `/plugin install`(請使用者輸入);單一 skill 下載到專案的 `.claude/skills/<名稱>/`,並在 `.claude/skills/README.md` 記下來源網址與 commit。

完成條件:每個候選都有「安裝 / 略過」的結果。

## 2. 選擇實作方式

工作量超過一個 session 能容納(多個獨立模組、tickets 超過 5 張、或來自 wayfinder)→ 建議多 session;否則建議單一 session。用 **ask** 確認。

- **多 session**:以 **upstream** 方式依序執行 `to-spec`、`to-tickets`;再走 **manual**:`/wf-handoff 依序實作 tickets`,然後依 blocking 順序為每張 ticket 開新 session 執行 `/implement-spec <ticket>`,全部完成後回來做第 3 步。
- **單一 session**:以 **upstream** 方式執行 `implement`,把 brief 與 ADR 當作規格。

完成條件:實作完成並通過專案的測試或檢查。

## 3. 回顧

**manual**:請使用者執行 `/retro`。它會提出改善 agent 環境的建議;採用的改動另外處理。

完成條件:使用者已收到 `/retro` 指令與說明。
