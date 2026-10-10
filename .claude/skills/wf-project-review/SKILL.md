---
name: wf-project-review
description: "Review 整個專案:先檢視專案、目標、Agent 架構與文件維護,再用 grilling 訪談你,最後產出建議報告(唯讀,不改專案)。"
disable-model-invocation: true
---

# WF Project Review

對 **Target project**(目前的工作目錄)做完整 Review。所有對話與報告用繁體中文。

**唯讀**:除了第 4 步的報告檔,不得新增、修改或刪除任何檔案;不得 commit。使用者要動手改,會另外指示。

## 1. 檢視

1. 執行 `bash <此 skill 目錄>/inventory.sh`,取得事實清單(必備文件、skills、subagents、設定檔、連結健康、術語使用、結構)。把輸出當作線索,不是結論:它會有誤報,例如上游文件中的範例連結、依設計延後建立的 `docs/adr/`。逐項判斷後再採用。
2. 讀取專案的說明文件(`README.md`、`CLAUDE.md`、`AGENTS.md`、`GLOSSARY.md`、`docs/`),整理出你對**專案目標**的理解。沒有任何文件寫明目標時,記為缺口,不要猜。
3. 檢視 **Agent 架構**,範圍為:`.claude/skills/`、`.claude/agents/`、`CLAUDE.md`/`AGENTS.md`、`.claude/settings.json`(hooks 與權限)、plugin 設定、MCP 設定。關注:職責重疊或衝突、沒人會呼叫的 skill、描述與實際行為不符、`CLAUDE.md` 的內容是否過長或過期。
4. 檢視**文件是否有維護**,只用可驗證的訊號:
   - 文件之間是否矛盾,或引用不存在的檔案
   - `GLOSSARY.md` 的術語在程式與 skill 中是否一致
   - README 與實際目錄結構是否相符
   - 文件最後修改時間與相關檔案相比是否過舊
   - 必備文件是否缺漏(`README`、`LICENSE`、`CLAUDE.md`、`docs/agents/*`)
5. 完成條件:上述四項都有結論(或明確記為「資料不足」),並且每個發現都有具體證據(檔案路徑與行)。

## 2. 訪談(grilling)

呼叫 Skill 工具,技能名稱用 `grilling`(`/grill-me` 只是它的使用者入口,其他 skill 不能叫用)。

- 把第 1 步的發現當作訪談的起點:矛盾、缺口、看不出理由的設計,都轉成帶有建議答案的問題。
- 專案目標與取捨是使用者的決定,要問;能從檔案查到的事實自己查,不要問。
- 遵守 grilling 的規則:一輪問完所有目前能問的問題,等使用者回答;使用者確認達成共識才結束。

## 3. 整理建議

綜合第 1、2 步,分三類各列建議:

- **刪改**:該刪、該合併、該改寫的內容
- **Agent 架構**:職責、命名、呼叫方式、`CLAUDE.md` 的調整
- **未來發展**:接下來值得做的事

每條建議標示優先級(高 / 中 / 低)與理由。證據不足的建議要標明,或不寫。

## 4. 輸出報告

依 [report-template.md](./report-template.md) 的固定章節寫成 `docs/reviews/YYYY-MM-DD.md`(日期為今天;同日已有檔案時,先問再覆蓋)。

最後在對話中:給摘要與最優先的三條建議,附報告路徑。詢問使用者想先處理哪一條;**在使用者下指示之前不要動手**。
