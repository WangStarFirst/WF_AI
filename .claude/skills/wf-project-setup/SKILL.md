---
name: wf-project-setup
description: "下載 mattpocock/skills 到專案的 .claude/skills/,再跑一次 setup-matt-pocock-skills。"
disable-model-invocation: true
---

# WF Project Setup

先讀 [conventions.md](../../../shared/conventions.md)。重複執行是安全的:已完成的部分略過並告知。

## 1. 下載上游 skill

安裝由 [install-upstream.sh](./install-upstream.sh) 負責:從 https://github.com/mattpocock/skills 即時下載,先驗證再安裝,失敗時不改任何東西。

1. 預覽:`bash <此 skill 目錄>/install-upstream.sh --target .claude/skills --plan`。每個 skill 會輸出 `new` / `same` / `conflict`,以及上游 SHA。
   - 下載或驗證失敗 → 回報錯誤原因後停止整個 setup。
2. 有 `conflict`(可能是使用者改過的版本)→ 列出清單,詢問每個(或整批)要「略過(建議)」、「覆蓋」,或「另存為 `<名稱>.upstream/` 供比對」。
3. 執行:同一個指令去掉 `--plan`,依回答加上 `--overwrite a,b` / `--sidecar c,d`。
4. 完成條件:每個 skill 都有最終狀態(installed / unchanged / overwritten / sidecar / skipped)。向使用者回報各狀態的數量與上游 SHA(已記錄在 `.claude/skills/README.md`)。

## 2. 設定專案

`docs/agents/issue-tracker.md` 已存在 → 詢問要「沿用(建議)」或「重新設定」。

否則以 **upstream** 方式執行 `setup-matt-pocock-skills`。完成條件:`docs/agents/` 下的設定檔已寫好,`CLAUDE.md` 或 `AGENTS.md` 有 `## Agent skills` 段落。

## 3. 收尾

回報清單:每一步「完成 / 略過 / 失敗」,失敗的附手動補救方式。最後提示下一步是 `/wf-design <專案概述>`。
