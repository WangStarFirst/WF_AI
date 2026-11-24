---
name: wf-ask-habit
description: "依 brief 判斷專案類型,從 habits.json 的來源讀取該類型的開發習慣,讓使用者勾選後寫進 CLAUDE.md;類型有模板且專案是空的時先下載模板。Use when starting a new project and choosing development habits, or runs /wf-ask-habit."
---

# WF Ask Habit

先讀 [conventions.md](../../../shared/conventions.md)。類型清單在 [habits.json](../../../habits.json)。

## 1. 判斷類型

比對 `docs/project-brief.md`(沒有就用對話內容)與每個類型的 `signals`,用 **ask**(multiSelect)確認:符合的類型標「(建議)」放前面,其餘類型也列出,最後加「跳過」。

- 選「跳過」或沒有任何類型 → 結束,回報「未加入開發習慣」。

完成條件:使用者已選定類型或跳過。

## 2. 取得來源

對每個選定的類型,把 `repo` 以 `git clone --depth 1` 抓到暫存目錄(private repo 會沿用使用者的 git 權限)。clone 失敗 → 告訴使用者錯誤與 repo 網址,略過這個類型。

完成條件:每個類型都已 clone 成功或已告知略過。

## 3. 下載模板

只在 `template: true` 且 Target project 尚無程式碼(Unity 看 `Assets/` 是否存在)時執行;否則略過。

先用 **ask** 確認「下載模板(建議)/ 不下載」。下載時把暫存目錄複製到 Target project,**排除**:`.git`、`.claude/skills/`、`skills-lock.json`、`habitsPath` 指的檔案、`docs/habits/`。已存在的檔案:

- `CLAUDE.md`:以模板版本為主,原有內容中模板沒有的段落接在後面;同名段落用 **ask** 問要留哪份。
- `.gitignore`、`.gitattributes`:逐行聯集。
- 其他:用 **ask** 問覆蓋或保留。

完成條件:模板已複製,或使用者選擇不下載/條件不符而略過。

## 4. 勾選習慣

讀取 `habitsPath`。格式:`##` 是分類,`###` 是一條習慣;內文只有一行 `連結：<相對路徑>`(全形或半形冒號皆可)的是**連結型**,內容以該檔為準,其餘是**文字型**。

每個分類一題(multiSelect),一次 AskUserQuestion 最多 4 題,超過就分批。選項標題是習慣名稱,說明是內文的一句話摘要(連結型先讀連結的檔案再摘要)。

完成條件:每個分類都已詢問。

## 5. 寫入

在 Target project 的 `CLAUDE.md` 加入(或更新)`## 開發習慣` 段落,第一行寫「與上方規則衝突時,以本段為準。」,接著依分類列出:

- 文字型:`### 名稱` + 原文。
- 連結型:把檔案複製到 `docs/habits/`,寫 `### 名稱` + 一句摘要 + 連結。

已有 `## 開發習慣` 時依「產出已存在」處理(沿用時改為合併新勾選的項目)。最後刪除暫存目錄。

完成條件:`CLAUDE.md` 有 `## 開發習慣` 段落,連結的檔案都存在;已回報加入的習慣清單。
