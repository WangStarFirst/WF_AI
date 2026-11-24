---
name: wf-habit-add
description: "新增開發習慣:在來源 repo 直接寫入 habits 檔;在其他專案則先暫存到 docs/habits-pending.md。"
argument-hint: "習慣描述(可省略,之後會問)"
disable-model-invocation: true
---

# WF Habit Add

先讀 [conventions.md](../../../shared/conventions.md)。類型與來源在 [habits.json](../../../habits.json);新增**類型**不在本 skill 範圍,請使用者在 WF_AI 的 `habits.json` 手動加一筆。

## 1. 判斷位置

讀取 Target project 的 `git remote get-url origin`,與 `habits.json` 每筆的 `repo` 比對(忽略大小寫與 `.git` 結尾)。

- 符合 → **來源模式**,寫入該筆的 `habitsPath`。
- 不符合 → **暫存模式**,寫入 `docs/habits-pending.md`。用 **ask** 確認類型(列出 `habits.json` 的類型)。

來源模式下若已有 `docs/habits-pending.md`(從衍生專案複製過來的),先用 **ask** 問要不要匯入,匯入的項目併入第 2 步的清單。

完成條件:已決定模式與目標檔案。

## 2. 整理習慣

逐條處理(參數或使用者的描述),直到使用者說沒有了:

1. 用 **ask** 選分類:列出既有的 `##` 分類,加「新分類」。分類已有 4 條時建議新分類(AskUserQuestion 每題最多 4 個選項)。
2. 改寫成 1–3 行可直接貼進 CLAUDE.md 的規則。內容太長或有外部資料(影片、網頁)→ 改成**連結型**:整理成 `docs/habits/<名稱>.md`,習慣內文只寫 `連結:docs/habits/<名稱>.md`。
3. 給使用者看改寫結果,確認或修改。

完成條件:每條習慣都已被使用者確認。

## 3. 寫入

依 [wf-ask-habit](../wf-ask-habit/SKILL.md) 第 4 步的格式寫入目標檔案(`###` 放在對應的 `##` 底下)。來源模式匯入過 pending 檔時,刪除該檔。暫存模式寫完後告訴使用者:到來源 repo 執行 `/wf-habit-add` 匯入。

完成條件:目標檔案已寫入,`docs/habits/` 下被連結的檔案都存在,已回報新增的習慣。
