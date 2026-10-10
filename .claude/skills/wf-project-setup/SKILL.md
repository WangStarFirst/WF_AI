---
name: wf-project-setup
description: "在目前專案快速建立起始設定:安裝 mattpocock/skills、(選擇性)連接 GitHub 與 LICENSE、輸出使用教學。"
disable-model-invocation: true
---

# WF Project Setup

在 **Target project**(目前的工作目錄)建立起始設定。所有對話與產出用繁體中文。

**原則**

- 重複執行是安全的:已完成的步驟略過並告知;要覆蓋任何既有內容,一律先問使用者。
- 任何一步失敗:說明原因,保留已完成的部分,不要偷偷換方案。

## 1. 安裝 mattpocock/skills

目標目錄是 `.claude/skills/`(相對於專案根目錄)。安裝由 [install-upstream.sh](./install-upstream.sh) 負責(即時從上游 GitHub 下載、先驗證再安裝)。

1. 預覽:`bash <此 skill 目錄>/install-upstream.sh --target .claude/skills --plan`。
   輸出每個 skill 的狀態 `new` / `same` / `conflict`,以及上游 SHA。
   - 下載或驗證失敗 → 腳本不會改任何東西。回報錯誤原因後**停止整個 Setup**,不使用舊版當備援。
2. 有 `conflict`:列出清單(可能是使用者改過的版本),預設略過。詢問使用者每個(或整批)要「略過」、「覆蓋」或「另存為 `<name>.upstream/` 供比對」。
3. 執行:同一指令去掉 `--plan`,依答案加上 `--overwrite a,b` / `--sidecar c,d`。
4. 完成條件:腳本輸出的每個 skill 都有狀態(installed / unchanged / overwritten / sidecar / skipped),向使用者回報各狀態數量。上游 SHA 已由腳本寫進 `.claude/skills/README.md`。

## 2. 連接 GitHub

用 AskUserQuestion 問:「這個專案要連接 GitHub 嗎?」。選項與後續流程依答案分支。

### 2a. 選「要」

依序處理,每項都先檢查現況,已有就略過:

1. **Remote**:`git remote -v`。沒有 remote 時詢問 repo 名稱(預設為目前資料夾名)與公開/私有,然後建立 repo。優先用 `gh repo create`,不可用時用 GitHub MCP 的 `create_repository`。
2. **LICENSE**:見下方「LICENSE」。
3. **README.md**:不存在才建立,內容只放專案名稱與一句描述(向使用者要這句話)。
4. **.gitignore**:不存在才建立,先詢問主要技術(Node、Python、Go…或無);有就用 `gh api /gitignore/templates/<名稱> --jq .source`,沒有就只寫 `.DS_Store`、`.env`、`node_modules/`。
5. **首次 commit 與 push**:`git add` 明確列出的檔案、commit、push 到預設分支(在雲端 session 則推到指定的開發分支)。

GitHub 操作(建立 repo、push)失敗時:最多重試一次;仍失敗就停止這一段,**保留所有已建立的本機檔案**,輸出一份使用者自己要執行的指令清單。

### 2b. 選「不要」

- 還不是 git repo 才執行 `git init`。
- 不設定 remote、不 push。
- 仍執行下方的「LICENSE」(授權與是否上 GitHub 無關)。

### LICENSE

專案根目錄已有 `LICENSE*` 就略過並告知。否則用 AskUserQuestion 詢問,**每個選項附上說明與適用場景**(內容見 [licenses.md](./licenses.md),照該表呈現)。

取得全文:`gh api /licenses/<key> --jq .body`(key 見 licenses.md);取代 `[year]`(今年)與 `[fullname]`(詢問使用者要寫的名字,預設取 `git config user.name`)。`gh` 不可用時,告知使用者並輸出手動取得全文的網址,不要憑記憶寫授權全文。

選「不加」時,在對話中提醒:沒有授權的程式碼,預設他人不得使用或修改。

## 3. 詢問是否執行 `/setup-matt-pocock-skills`

問使用者要不要現在執行。它會設定 issue tracker、triage 標籤與 `CLAUDE.md`。
要的話,此時已知道有沒有 GitHub remote,告訴它(若剛建立了 GitHub repo,推薦 GitHub 作為 issue tracker),然後執行該 skill。不要的話略過,並在最後提醒之後可自行執行。

## 4. 輸出使用教學

教學由剛安裝的內容**即時生成**,不要寫死(上游更新後,教學要跟著更新)。

1. 讀取 `.claude/skills/` 中的上游 `README.md`(若有)與每個已安裝 skill 的 `SKILL.md` 前置資料(`name`、`description`)。
2. 用繁體中文寫成 `docs/matt-pocock-skills-guide.md`,包含:
   - 這套 skill 是什麼、設計理念(取自上游 README)
   - 第一步:`/setup-matt-pocock-skills`
   - 依工作階段分組的 skill 一覽(想法 → 規格 → 工單 → 實作 → 審查),每個 skill 一行:名稱、何時用
   - 建議的上手順序(3 到 5 步)
   - 如何更新到上游最新版(重新執行 `/wf-project-setup`)
3. 已存在同名檔案時,先問再覆蓋。
4. 在對話中給 5 行以內的摘要與上手順序,並附檔案路徑。

## 5. 收尾

回報一份清單:每一步「完成 / 略過 / 失敗」,失敗項附手動步驟。詢問是否要 commit 這些變更;未經同意不要 commit。
