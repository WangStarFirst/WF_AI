# WF Toolbox

個人常用 plugin 與 skill 的來源 repo,供其他專案安裝與重複使用。

## Language

**Toolbox(工具箱)**:
本 repo,存放個人常用的 skill 與 plugin,是它們的唯一來源(Single Source of Truth)。
_Avoid_: 專案、monorepo

**Target project(目標專案)**:
執行 Toolbox 中的 skill 的那個專案,可以是新專案,也可以是 Toolbox 自己。
_Avoid_: 客戶專案、下游 repo

**wf-project-setup**:
在 Target project 中執行的 skill,負責建立專案起始設定。
_Avoid_: WF Setup、init、bootstrap

**wf-project-review**:
在 Target project 中執行的 skill,負責先檢視專案,再訪談使用者,最後提出建議。
_Avoid_: WF Review、audit、health check

**Upstream(上游)**:
mattpocock/skills,Setup 會即時下載並安裝的外部 skill 集合。
_Avoid_: 原版、官方版
