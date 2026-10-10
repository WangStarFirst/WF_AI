# WF Toolbox

我個人常用的 skill 與自製 plugin 的來源 repo,供其他專案安裝與重複使用。

## 內容

| 名稱 | 用途 |
| --- | --- |
| `/wf-project-setup` | 在目前專案快速建立起始設定:安裝 [mattpocock/skills](https://github.com/mattpocock/skills)、(選擇性)連接 GitHub 與 LICENSE、輸出使用教學 |
| `/wf-project-review` | Review 整個專案:先檢視專案、目標、Agent 架構與文件維護,再用 grilling 訪談,最後產出 `docs/reviews/YYYY-MM-DD.md` 建議報告(唯讀) |

## 安裝(在其他專案)

```
/plugin marketplace add WangStarFirst/WF_AI
/plugin install wf-toolbox@wf-ai
```

安裝後執行 `/wf-toolbox:wf-project-setup` 即可。

## 目錄結構

```
.claude-plugin/        plugin 與 marketplace 設定(只含 wf-* skill)
.claude/skills/        wf-* 自製 skill,以及上游 mattpocock/skills 的副本
docs/agents/           issue tracker、triage 標籤、領域文件的設定
docs/reviews/          /wf-project-review 產生的報告
GLOSSARY.md            專案術語
```

上游副本只供本 repo 使用,由 `/wf-project-setup` 管理,不包含在 plugin 內。

## 授權

MIT,見 [LICENSE](./LICENSE)。`.claude/skills/` 內的上游內容版權屬 Matt Pocock,見 `.claude/skills/LICENSE-mattpocock-skills`。
