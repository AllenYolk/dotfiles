# Neovim 使用手册

这是一套面向 Python、Markdown 和终端工作的 minimal Neovim 配置，配置源位于本仓库的 `nvim/`。它可部署到 macOS 和 Linux；插件版本由 `nvim/lazy-lock.json` 固定。

## 安装与配置

本页只讲使用。安装依赖、创建链接、同步插件和故障恢复遵循 [Neovim 操作](operations/neovim.md)；所有第三方工具见 [依赖矩阵](operations/dependencies.md)。不要把密钥、WakaTime 配置或本机 `.env` 放进仓库。

## 基本约定

本文中的 `<leader>` 是空格键。例如 `<leader>ff` 就是连续按空格、f、f。

最重要的原则是：先回到 Normal 模式，再执行快捷键。

### 模式入门

| 模式 | 进入方式 | 回到 Normal 模式 | 适用场景 |
|---|---|---|---|
| Normal | `Esc` | 已在 Normal 模式 | 移动、删除、复制、搜索、执行快捷键 |
| Insert | `i`（光标前）、`a`（光标后）、`o`（下方新行） | `Esc` | 输入文字 |
| Visual | `v`（字符）、`V`（整行）、`Ctrl-v`（块） | `Esc` | 选择后复制、删除、缩进，或对部分 Git hunk 操作 |
| Command-line | `:` | `Esc` | 执行 `:Gitsigns ...`、`:Lazy` 等命令 |

例如 `v` 选择文字后按 `d` 删除、按 `y` 复制；`V` 选中多行后按 `>` 缩进。若快捷键没有反应，先按一次 `Esc`。

## 快速导航

| 要做什么 | 首选入口 |
|---|---|
| 找文件或全文 | `<Space>ff` / `<Space>fg` |
| 阅读或修改 Python | `gd`、`K`、`<Space>ca`、`<Space>cf` |
| 处理 Markdown | `:RenderMarkdown toggle`、`:RenderMarkdown preview` |
| 看当前文件的 Git 修改 | `:Gitsigns preview_hunk`、`:Gitsigns diffthis` |
| 局部暂存并检查提交内容 | `:Gitsigns stage_hunk`、终端 `git diff --cached` |
| 查提交、分支或工作区状态 | `:FzfLua git_commits`、`:FzfLua git_branches`、`:FzfLua git_status` |
| 打开终端执行完整 Git 命令 | `<Space>tn` |

## 推荐工作流

```bash
nvim .
```

进入项目后，推荐使用 `<Space>ff` 找文件、`<Space>fg` 搜索全文、`gd` 跳转定义、`K` 查看文档、`<Space>cf` 格式化 Python，保存时让 Ruff 自动 lint。

远程工作时：

```bash
ssh roshan4-gpu
tmux new -As work
nvim .
```

CPU 机器同理。

### 远程剪贴板

通过 SSH 运行 Neovim 时，配置会自动选择 OSC52；远端 tmux 也已开启剪贴板转发。复制到本地 Mac：

```text
"+y      复制选中内容或当前行到本地剪贴板
```

OSC52 适合复制代码和文本，但会把选中内容通过终端控制序列传回本地。不要对不可信终端复制密码、密钥或其他敏感内容。

## 快捷键速查

### 文件、窗口和终端

| 快捷键 | 作用 |
|---|---|
| `<Space>w` | 保存文件 |
| `<Space>q` | 退出当前窗口 |
| `<Space>e` | 打开内置文件浏览器 |
| `<Space>o` | 用 Oil 打开文件管理器 |
| `<Space>h/j/k/l` | 在左/下/上/右窗口间移动 |
| `<Space>tn` | 在下方打开终端 |
| `<Esc><Esc>` | 从终端模式回到 Normal 模式 |
| `<Space>cd` | 将当前文件所在目录设为工作目录 |
| `<Space>xx` | 打开 quickfix 列表 |
| `<Esc>` | 清除搜索高亮 |

### 搜索

| 快捷键 | 作用 |
|---|---|
| `<Space>ff` | 文件名搜索 |
| `<Space>fg` | 项目全文搜索（依赖 ripgrep） |
| `<Space>fb` | 已打开 buffer 搜索 |
| `<Space>fh` | Neovim 帮助标签搜索 |

按下 `<Space>` 后稍等片刻，which-key 会显示当前可用的快捷键。

### LSP 和诊断

| 快捷键 | 作用 |
|---|---|
| `gd` | 跳到定义 |
| `gD` | 跳到声明 |
| `gr` | 查找引用 |
| `K` | 查看悬浮文档 |
| `<Space>rn` | 重命名符号 |
| `<Space>ca` | 代码动作 |
| `<Space>D` | 跳到类型定义 |
| `[d` / `]d` | 上一个/下一个诊断 |
| `<Space>dd` | 打开当前诊断详情 |

### 补全

`blink.cmp` 提供 LSP、路径和 buffer 补全。Minuet 使用独立的 ghost text，不与 blink.cmp 的候选菜单混合。

| 快捷键 | 作用 |
|---|---|
| `Ctrl-Space` | 手动打开补全菜单 |
| `Ctrl-n` / `Ctrl-p` | 下一个/上一个候选项 |
| `Tab` | 接受当前候选项；snippet 中跳到下一个占位符 |
| `Shift-Tab` | 回到上一个 snippet 占位符 |
| `Ctrl-e` | 关闭补全菜单 |
| `Ctrl-b` / `Ctrl-f` | 上下滚动补全文档 |

### AI 补全

Minuet 通过 OpenCode Go 的 `deepseek-v4-flash` 在代码 buffer 中显示灰色 ghost text，并关闭模型思考以降低延迟。凭据按以下优先级读取：`OPENCODE_GO_API_KEY` 环境变量、`OPENCODE_GO_API_KEY_FILE` 指向的私有文件、`~/.config/nvim/.env`、`~/.hermes/.env` 兼容回退。私有文件只需包含一行 `OPENCODE_GO_API_KEY=...`；该密钥不会写入或同步到 dotfiles。

| 快捷键 | 作用 |
|---|---|
| `Ctrl-l` | 接受整条 Minuet 建议 |
| `Ctrl-j` | 接受当前建议的一行 |
| `Ctrl-]` | 忽略当前 AI 建议 |

`Tab` 仍保留给 blink.cmp 候选确认和 snippet 占位符跳转。Minuet 在 Markdown、帮助页和 Oil 中不自动启用。它会将当前编辑上下文发送给 OpenCode Go 以生成建议。

### Python 格式化和 lint

| 操作 | 行为 |
|---|---|
| `<Space>cf` | 用 Ruff 格式化当前 Python buffer |
| 保存 Python 文件 | 自动运行 Ruff lint |
| `<Space>dd` | 查看 lint 或 LSP 诊断 |

当前不会保存时自动改写文件，避免编辑器突然改变代码。

## Git：差异、暂存与历史

本配置使用 `gitsigns.nvim` 处理**当前 buffer 的 hunk**，使用 fzf-lua 查找 Git 对象，提交、合并、rebase 等仓库级操作仍通过 Git 命令行完成。先在 Git 仓库根目录或其子目录中启动 `nvim .`；未跟踪文件没有可比较的 Git hunk。

### 当前文件的 diff

左侧 signcolumn 会标记新增、修改和删除 hunk。光标停在某个 hunk 内，再使用以下命令：

| 命令 | 作用 |
|---|---|
| `:Gitsigns nav_hunk next` / `prev` | 跳到下一个/上一个 hunk |
| `:Gitsigns preview_hunk` | 在浮窗查看当前 hunk 的补丁 |
| `:Gitsigns preview_hunk_inline` | 在当前 buffer 内展开补丁 |
| `:Gitsigns diffthis` | 打开当前文件相对 index 的 diff，等同于查看该文件的未暂存修改 |
| `:Gitsigns diffthis HEAD` | 打开当前文件相对 `HEAD` 的 diff，包含已暂存和未暂存修改 |
| `:Gitsigns diffthis HEAD~1` | 与上一个提交比较当前文件 |
| `:Gitsigns change_base HEAD~1` | 把左侧 hunk 的比较基准临时改为上一个提交 |
| `:Gitsigns change_base` | 恢复默认比较基准 |

`diffthis` 打开的是 Neovim diff 视图；用 `:diffoff!` 退出 diff 模式，必要时用 `:only` 收回其它窗口。`change_base` 只改变 Gitsigns 的显示基准，不会改写 Git 历史或工作区。

### 局部暂存与撤销

| 命令 | 作用与边界 |
|---|---|
| `:Gitsigns stage_hunk` | 暂存当前 hunk；当光标位于已暂存 hunk 时再次执行会取消暂存。Visual 模式下可对选中部分 hunk 生效 |
| `:Gitsigns reset_hunk` | 将当前 hunk 恢复到 index 版本，会丢弃该 hunk 的未暂存修改 |
| `:Gitsigns stage_buffer` | 暂存当前文件全部修改；使用前先审阅 diff |
| `:Gitsigns reset_buffer` | 将当前文件全部恢复到 index 版本，会丢弃未暂存修改 |

本配置没有为这些操作设置 `<leader>hs` 等快捷键；请从命令行输入 `:Gitsigns` 并使用上表命令。`reset_hunk` 和 `reset_buffer` 是有破坏性的工作区操作，先用 `preview_hunk` 或 `diffthis` 确认。

### Blame、历史与分支

| 命令 | 作用 |
|---|---|
| `:Gitsigns blame_line` | 在浮窗显示当前行最后一次提交的信息 |
| `:Gitsigns blame` | 打开当前文件的 blame 面板 |
| `:Gitsigns show` | 打开当前文件的 index 版本；此 buffer 可写，保存会直接更新暂存区，仅在明确要编辑已暂存内容时使用 |
| `:Gitsigns show HEAD~1` | 打开指定历史版本以供检查；不要在此类版本 buffer 中保存修改 |
| `:FzfLua git_status` | 在选择器中查看工作区状态并打开文件 |
| `:FzfLua git_commits` | 搜索项目提交历史 |
| `:FzfLua git_bcommits` | 搜索当前文件的提交历史 |
| `:FzfLua git_branches` | 搜索分支并执行选择器提供的分支操作 |
| `:FzfLua git_files` | 只搜索 Git 已跟踪文件 |

fzf-lua 由 `<Space>ff`、`<Space>fg`、`<Space>fb` 或 `<Space>fh` 按需加载。因此新启动 Neovim 后，先执行任一映射一次，再输入这些 `:FzfLua` Git 命令。它们适合定位对象；实际的 merge、rebase、push、pull 和冲突处理仍在终端完成。

### 提交前的推荐闭环

1. 用 `:FzfLua git_status` 或终端 `git status --short` 了解范围。
2. 逐文件使用 `:Gitsigns preview_hunk` 或 `:Gitsigns diffthis` 审阅未暂存修改。
3. 只对确认过的变更执行 `:Gitsigns stage_hunk`；需要取消暂存时，把光标放回已暂存 hunk 并再次执行该命令。
4. `<Space>tn` 打开终端，运行 `git diff --cached` 审阅将要提交的内容，再运行项目测试。
5. 使用 `git commit` 提交；提交后以 `git status` 确认工作区。

常用终端命令：

```bash
git status --short       # 工作区概览
git diff                 # 未暂存修改
git diff --cached        # 已暂存、将进入下一次提交的修改
git diff HEAD            # 全部未提交修改
git log --oneline --decorate --graph -20
git show <commit>
git restore --staged <path>  # 仅取消暂存，保留工作区修改
```

### 分支、同步与冲突

这些是仓库级操作，使用 `<Space>tn` 打开终端。先用 `git status --short` 确认没有未处理的本地修改，再执行：

```bash
git fetch --prune                 # 更新远端引用并清理已删除分支
git switch <branch>               # 切换已有分支
git switch -c <branch>            # 从当前提交创建并切换新分支
git pull --ff-only                # 仅接受快进更新，避免隐式 merge commit
git push -u origin <branch>       # 首次推送并设置上游
git push                          # 后续推送当前分支
```

将目标分支整合到当前功能分支前，先 `git fetch --prune`。团队允许保留整合提交时使用 `git merge origin/<target>`；需要线性本地提交历史且该分支尚未共享时使用 `git rebase origin/<target>`。不要对已经推送并被他人使用的分支随意 rebase，更不要用强制 push 覆盖远端历史。

发生冲突时，按以下顺序处理：

1. `git status` 列出冲突文件；用 `nvim <path>` 打开它们。
2. 搜索 `<<<<<<<`、`=======`、`>>>>>>>`，选择或重写最终内容，删除所有冲突标记后 `<Space>w` 保存。
3. `git add <path>` 标记已解决；所有文件解决后执行 `git merge --continue` 或 `git rebase --continue`。
4. 确认本次整合不应继续时使用对应的 `git merge --abort` 或 `git rebase --abort`，不要用 `git reset --hard` 作为快捷替代。

不要用 Gitsigns 代替 Git 的仓库级操作，也不要为了清理 diff 在终端随意执行 `git reset --hard`。

## 关键插件和边界

### lazy.nvim

后台插件管理器，按锁文件提供本手册所述插件。日常编辑不需要直接操作它；插件同步、升级、清理和状态诊断属于维护流程，见 [Neovim 操作](operations/neovim.md)。当前已关闭 LuaRocks 支持，因为现有插件不需要它。

### Tree-sitter

负责语法高亮和结构感知，不是 LSP，也不负责类型分析。当前已安装 Python、Markdown、Lua、Bash、JSON、Vim 等 parser；配置不启用自动折叠，文件默认保持展开。

parser 的安装、更新和编译属于维护流程，见 [Neovim 操作](operations/neovim.md)；日常编辑中无需手动执行 Tree-sitter 命令。

### fzf-lua

它是搜索界面，不是文件管理器，也不替代 LSP。全文搜索依赖系统中的 `rg`。配置提供的入口是 `<Space>ff`、`<Space>fg`、`<Space>fb` 和 `<Space>fh`；在任一选择器中输入关键词过滤，确认选择后打开目标。这些映射也会加载插件，之后才能使用 `:FzfLua git_status` 等 Git 专用选择器。

### Oil

它是文件系统编辑器，适合批量重命名、创建和删除文件；代码跳转仍使用 fzf 和 LSP。用 `<Space>o` 打开后像编辑文本一样修改文件名，保存 buffer 会先展示变更确认，确认后才应用到文件系统。常用默认操作：`Enter` 打开、`-` 返回父目录、`g.` 切换隐藏文件、`Ctrl-p` 预览、`Ctrl-s` 垂直分屏打开、`Ctrl-h` 水平分屏打开、`g?` 查看完整帮助。重命名或删除前先检查改动行和确认提示。

### gitsigns.nvim

在左侧 signcolumn 标记当前文件相对 Git 基准的新增、修改和删除。它只处理当前 buffer 的局部 hunk，不替代完整 Git 命令行工作流；diff、暂存、blame、提交历史和终端分工见上方 [Git：差异、暂存与历史](#git差异暂存与历史)。

### which-key.nvim 和 lualine.nvim

which-key 在按下 `<Space>` 后显示快捷键提示；lualine 提供底部状态栏。两者都是辅助插件，不改变代码语义。

### render-markdown.nvim

只在 Markdown buffer 中加载，把标题、列表、引用、代码块和复选框等常见 Markdown 结构直接渲染在 Neovim 窗口中，便于边写边读。它不是浏览器渲染器：复杂 HTML、CSS、Mermaid、LaTeX 或站点特定扩展的显示可能与最终网页不同。

```vim
:RenderMarkdown toggle    "切换原始文本/渲染视图
:RenderMarkdown enable    "启用渲染
:RenderMarkdown disable   "停用渲染
:RenderMarkdown preview   "打开预览窗口
```

打开 `.md` 文件后默认启用。预览只影响当前编辑器显示，不会改写文件内容。

### WakaTime

`vim-wakatime` 自动记录编辑活动，并与其他编辑器共用 `~/.wakatime.cfg` 和 `~/.wakatime/wakatime-cli`。配置仓库不保存 API key，也不复制该文件。

```vim
:WakaTimeToday
```

WakaTime 会将编辑活动发送至你的 WakaTime 账户；`ignore`、`hidefilenames` 等行为以已有的共享配置为准。

## Python 和 Markdown LSP

### Python：basedpyright

打开 Python 文件时，Neovim 会寻找包含以下标记的项目根目录：

- `pyproject.toml`
- `uv.lock`
- `setup.py` 或 `setup.cfg`
- `requirements.txt`
- `.python-version`
- `.git`

如果项目根目录下有 `.venv` 或 `venv`，配置会自动把它作为 Python 虚拟环境。

推荐项目结构：

```text
project/
├── pyproject.toml
├── uv.lock
├── .venv/
└── src/
```

检查 LSP：

```vim
:LspInfo
:checkhealth vim.lsp
```

basedpyright 负责类型、定义、引用和语义诊断；Ruff 负责格式化、import 排序和风格问题。

### Markdown：marksman

marksman 提供标题、链接、引用和结构诊断；`render-markdown.nvim` 负责编辑器内的即时显示。两者都不替代 Pandoc、Quarto 或站点构建工具。

打开 `.md` 文件后即可看到渲染效果；需要逐字编辑 Markdown 标记时执行 `:RenderMarkdown toggle` 暂时切回原始视图。

## 值得掌握的 Vim 操作

### 移动

| 操作 | 作用 |
|---|---|
| `w` / `b` | 下一个/上一个单词 |
| `e` | 当前单词末尾 |
| `0` / `^` / `$` | 行首/第一个非空字符/行尾 |
| `gg` / `G` | 文件首行/末行 |
| `{` / `}` | 上一个/下一个段落 |
| `%` | 跳到匹配的括号 |
| `f{char}` | 跳到本行下一个字符 |
| `;` / `,` | 重复/反向重复 `f` 搜索 |
| `Ctrl-d` / `Ctrl-u` | 向下/向上滚半屏 |

### 操作符和文本对象

Vim 的强大之处是“动作 + 范围”：

```text
di"     删除双引号中的内容
da(     删除一对括号及括号本身
yap     复制一个段落
dap     删除一个段落
ci[     修改方括号中的内容
```

常用操作符：`d` 删除、`c` 修改、`y` 复制、`>`/`<` 缩进。

### 重复、搜索和替换

```text
.       重复上一次修改
u       撤销
Ctrl-r  重做
>> / << 增加/减少缩进
J       合并当前行和下一行
```

```vim
/pattern        向下搜索
?pattern        向上搜索
n / N           下一个/上一个结果
* / #           搜索光标下的单词
:%s/old/new/gc  全文件交互式替换
```

`:%s/old/new/gc` 中的 `c` 会逐项确认，适合不熟悉批量替换时使用。

### 寄存器、宏和窗口

```text
yy      复制一整行
dd      删除一整行
p / P   在后/前粘贴
"ayy    复制到寄存器 a
"ap     粘贴寄存器 a
qq / q  开始/停止录制宏 q
@q      执行宏 q
@@      重复上一次宏
```

```text
Ctrl-w s       水平分屏
Ctrl-w v       垂直分屏
Ctrl-w h/j/k/l 移动到相邻窗口
Ctrl-w =       平均窗口大小
Ctrl-w o       只保留当前窗口
:bnext/:bprev  切换 buffer
:bd            关闭当前 buffer
```

按 `Ctrl-v` 进入 Visual Block，再按 `I` 或 `A` 可以对多行同时插入内容。

## 常见任务示例

### 修改一个 Python 函数

1. `<Space>ff` 打开文件。
2. `/函数名` 搜索，按 `n` 跳转。
3. `gd` 跳到定义，`K` 查看类型或文档。
4. 用 `ciw`、`ci(`、`dap` 等文本对象修改。
5. `<Space>cf` 格式化。
6. `<Space>w` 保存，查看 Ruff 诊断。

### 处理类型错误

1. 在错误位置按 `<Space>dd`。
2. 用 `K` 查看类型文档。
3. 用 `<Space>ca` 查看代码动作。
4. 用 `[d`/`]d` 浏览其他诊断。
5. 用 `<Space>rn` 做符号级重命名，而不是全局替换。

### 写 Markdown

使用 `<Space>ff` 打开文件，默认会由 render-markdown.nvim 渲染标题、列表、代码块和任务框；使用普通 Vim 搜索、段落移动和文本对象编辑，marksman 会提供链接、标题和引用相关诊断。需要检查原始语法时使用 `:RenderMarkdown toggle`，需要单独查看时使用 `:RenderMarkdown preview`。

## 故障排查

### 补全没有出现

```vim
:LspInfo
:checkhealth vim.lsp
```

确认文件类型是 `python` 或 `markdown`，然后尝试 `Ctrl-Space`。

### Minuet 没有建议

```vim
:Minuet virtualtext enable
```

确认当前 buffer 不是 Markdown、帮助页或 Oil，并确认任一凭据来源中存在 `OPENCODE_GO_API_KEY`；不要把密钥写入配置仓库。

### WakaTime 没有记录

确认 `~/.wakatime.cfg` 存在，然后在 Neovim 中运行：

```vim
:WakaTimeToday
```

需要诊断时运行 `:WakaTimeDebugEnable`，并查看 `~/.wakatime/wakatime.log`；完成后使用 `:WakaTimeDebugDisable`。

### Ruff 没有运行

终端确认：

```bash
ruff --version
```

Neovim 中检查：

```vim
:ConformInfo
:lua require("lint").try_lint()
```

### Tree-sitter 没有高亮

```vim
:checkhealth nvim-treesitter
```

如果 parser 缺失，按 [Neovim 操作](operations/neovim.md) 中经确认的维护流程安装；不要在故障排查时直接下载或编译未知 parser。

### 文件选择器没有图标或图标异常

文件图标由 `nvim-web-devicons` 提供，终端必须使用 Nerd Font 才能正确绘制图标字符。

- 文件选择器完全没有图标列：先检查 `nvim-web-devicons` 是否已由 Lazy 安装和加载。
- 图标显示为空白、方框或乱码：安装 Nerd Font，并将终端字体设为 `MesloLGS NF` 或 `JetBrainsMono Nerd Font Mono`。

在 Neovim 中检查插件：

```vim
:Lazy
```

### 插件状态异常

```vim
:checkhealth
```

不要一遇到问题就删除整个 `~/.local/share/nvim`；先查看具体插件日志和 `:checkhealth` 输出。需要同步或清理插件时，按 [Neovim 操作](operations/neovim.md) 执行。

## 当前配置的边界

这套配置已经适合日常代码编辑、跳转、补全、诊断、格式化、Git 查看和终端工作流，但刻意没有覆盖：

- CUDA/C 的语义 LSP：尚未安装 `clangd`
- 调试：尚未安装 `nvim-dap`
- 测试界面：未安装 neotest，直接使用 pytest 命令行
- AI 补全：Minuet 已启用，使用 OpenCode Go 的 `deepseek-v4-flash`；没有安装 Copilot、Codeium 或其他 AI provider
- 配置同步：通过本仓库的 `nvim/` 受管理对象和逐项符号链接完成，不自动同步密钥或机器本地状态

保持当前状态的好处是启动快、依赖少、服务器环境干净。只有当某项工作流确实出现重复劳动时，再增加对应插件。


## 面向 Agent 的部署

部署由根目录的 [AGENTS.md](../AGENTS.md) 统一约束；具体依赖、局部链接、插件同步和验收步骤在 [Neovim 操作](operations/neovim.md)。该操作文件是唯一的 agent 部署入口，避免复制一段不受版本控制的长 Prompt 到其它会话。
