# WF Toolbox 維護說明

這個 repo 是 plugin，裡面的 wf skill 會安裝到**其他專案**執行。SKILL.md 中的「Target project」指的是那些專案，不是這個 repo。

- 流程的唯一定義是 `workflow.json`。新增、修改或刪除 wf skill 時，同步修改 `workflow.json` 和 `.claude-plugin/plugin.json`，再執行 `scripts/check-workflow.sh --fix`；這個指令必須通過。
- 所有 wf skill 共用的規則（步驟類型怎麼執行、brief 格式）放在 `shared/conventions.md`，不要在個別 SKILL.md 重複寫。
- SKILL.md 用繁體中文撰寫，寫法依照上游 `writing-for-agents` skill：每一步都要有完成條件；只能手動執行的 skill 設 `disable-model-invocation: true`。
- 上游 mattpocock skill 不放在這個 repo，由 `.claude/skills/wf-project-setup/install-upstream.sh` 在目標專案即時下載。
