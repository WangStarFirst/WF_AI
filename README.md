# WF Toolbox

以 [mattpocock/skills](https://github.com/mattpocock/skills) 為基礎的 Claude Code 工作流 plugin，從設定、設計到實作，一路引導你完成一個專案。

架構與流程圖：[docs/index.html](./docs/index.html)（由 `workflow.json` 產生）

## 安裝（在你的專案）

```
/plugin marketplace add WangStarFirst/WF_AI
/plugin install wf-toolbox@wf-ai
```

接著執行：

```
/wf-lazy-start <用幾句話描述你的專案>
```

不確定下一步該做什麼時，執行 `/wf-help`。

## 流程

```
/wf-lazy-start
 ├─ /wf-project-setup   下載 mattpocock/skills → setup-matt-pocock-skills
 ├─ /wf-design          專案概述 → /wf-relate-work → grill-with-docs 或 wayfinder
 │                      →（必要時）/wf-prototype → /wf-project-review → 是否開始實作？
 └─ /wf-implement       搜尋並安裝 skill → 單一 session：implement
                                          多 session：to-spec → to-tickets → implement-spec
                        → retro
```

| Skill | 誰能執行 | 用途 |
| --- | --- | --- |
| `/wf-lazy-start` | 只能手動 | 依序執行 setup → design → implement |
| `/wf-project-setup` | 只能手動 | 下載上游 skill 到 `.claude/skills/`，跑 `setup-matt-pocock-skills` |
| `/wf-design` | 手動或模型 | 專案概述 → 相關專案調查 → 訪談設計 → 架構圖 → 詢問是否實作 |
| `/wf-relate-work` | 手動或模型 | 用 subagent 調查至少 3 款相關專案，逐條建議補充、改進、簡化或刪除 |
| `/wf-prototype` | 手動或模型 | 反覆做 prototype 直到問題有答案，結論寫成 ADR |
| `/wf-project-review` | 手動或模型 | 把專案內容與架構畫成 `docs/reviews/YYYY-MM-DD.html` |
| `/wf-implement` | 只能手動 | 找並安裝 skill，選擇單一或多 session 實作，完成後做 retro |
| `/wf-grill-me` | 只能手動 | 直接執行上游 `grill-me` |
| `/wf-handoff` | 只能手動 | 直接執行上游 `handoff`，交接文件存到 `docs/handoffs/`，新 session 才讀得到 |
| `/wf-help` | 手動或模型 | 依目前的產出判斷所在階段，告訴你下一步 |

### 在你的專案中產生的檔案

| 檔案 | 由誰產生 |
| --- | --- |
| `.claude/skills/<上游 skill>/` | `/wf-project-setup` |
| `docs/agents/`、`CLAUDE.md` 的 `## Agent skills` | `setup-matt-pocock-skills` |
| `docs/project-brief.md` | `/wf-design`（專案內容的唯一來源） |
| `docs/related-work.md` | `/wf-relate-work` |
| `docs/adr/`、`GLOSSARY.md` | `grill-with-docs`、`/wf-prototype` |
| `docs/reviews/YYYY-MM-DD.html` | `/wf-project-review` |
| `docs/handoffs/` | `/wf-handoff` |

## 設計原則

- **不修改上游**：上游 skill 大多只能手動觸發，所以 wf skill 會讀取它們的 `SKILL.md`，在同一個 session 照著做；需要開新 session 的步驟會請你自己輸入指令（先 `/wf-handoff`，再到新 session 繼續）。細節見 [shared/conventions.md](./shared/conventions.md)。
- **單一來源**：流程定義在 `workflow.json`，專案內容定義在 `docs/project-brief.md`。
- **詢問而非猜測**：每個需要決定的地方都會給建議並等你回答。

## 增減流程（模組化）

```
workflow.json                    流程的唯一定義：skills、步驟類型、階段
.claude/skills/wf-*/SKILL.md     每個 wf skill 的實際行為
shared/conventions.md            所有 wf skill 共用的規則
.claude-plugin/                  plugin 與 marketplace 設定
docs/index.html                  架構頁（內嵌 workflow.json）
scripts/check-workflow.sh        一致性檢查
```

1. 新增、修改或刪除 `.claude/skills/wf-<名稱>/`。
2. 同步修改 `workflow.json` 與 `.claude-plugin/plugin.json`。
3. 執行：

```bash
scripts/check-workflow.sh --fix
```

它會把流程同步到 `docs/index.html`，並檢查三者是否一致：skill 名稱、能不能被模型呼叫、步驟參照與階段。

## 授權

MIT，見 [LICENSE](./LICENSE)。上游 mattpocock/skills 由 `/wf-project-setup` 在安裝時下載，版權屬 Matt Pocock（MIT）。
