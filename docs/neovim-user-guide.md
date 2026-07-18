# Neovim 使用手册

这是一套面向 Python、Markdown 和终端工作的 minimal Neovim 配置，配置源位于本仓库的 `nvim/`。它可部署到 macOS 和 Linux；插件版本由 `nvim/lazy-lock.json` 固定。

## 配置迁移

在新机器上克隆本仓库后，从仓库根目录运行：

```bash
./createsymlink.sh
nvim --headless '+Lazy! sync' '+qa!'
```

脚本会把 `nvim/init.lua`、`nvim/lazy-lock.json` 和 `nvim/lua/` 分别链接到 `~/.config/nvim/`；目录本身保留为本机目录，因此 `.env` 等机器私有文件不会进入仓库。已有同名非链接对象会跳过并提示，不会覆盖。完整的依赖安装与验收要求见文末 Agent Prompt。

## 基本约定

本文中的 `<leader>` 是空格键。例如 `<leader>ff` 就是连续按空格、f、f。

最重要的原则是：先回到 Normal 模式，再执行快捷键。

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

## 关键插件和边界

### lazy.nvim

后台插件管理器。偶尔使用：

```vim
:Lazy
:Lazy sync
:Lazy clean
```

当前已关闭 LuaRocks 支持，因为现有插件不需要它。

### Tree-sitter

负责语法高亮和结构感知，不是 LSP，也不负责类型分析。当前已安装 Python、Markdown、Lua、Bash、JSON、Vim 等 parser；配置不启用自动折叠，文件默认保持展开。

```vim
:checkhealth nvim-treesitter
:TSInstall python
:TSUpdate
:TSInstall cuda
```

最后一条只在以后确实需要 CUDA 语法时执行。

### fzf-lua

它是搜索界面，不是文件管理器，也不替代 LSP。全文搜索依赖系统中的 `rg`。

### Oil

它是文件系统编辑器，适合批量重命名、创建和删除文件；代码跳转仍使用 fzf 和 LSP。打开后像编辑文本一样修改文件名，保存 buffer 即应用变更。

### gitsigns.nvim

在左侧 signcolumn 标记当前文件相对 Git 的新增、修改和删除。常用命令：

```vim
:Gitsigns preview_hunk
:Gitsigns blame_line
:Gitsigns diffthis
:Gitsigns stage_hunk
:Gitsigns reset_hunk
```

它只处理局部 hunk，不替代完整 Git 命令行工作流。

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
:TSInstall python
```

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
:Lazy
:Lazy sync
:checkhealth
```

不要一遇到问题就删除整个 `~/.local/share/nvim`；先查看具体插件日志和 `:checkhealth` 输出。

## 当前配置的边界

这套配置已经适合日常代码编辑、跳转、补全、诊断、格式化、Git 查看和终端工作流，但刻意没有覆盖：

- CUDA/C 的语义 LSP：尚未安装 `clangd`
- 调试：尚未安装 `nvim-dap`
- 测试界面：未安装 neotest，直接使用 pytest 命令行
- AI 补全：Minuet 已启用，使用 OpenCode Go 的 `deepseek-v4-flash`；没有安装 Copilot、Codeium 或其他 AI provider
- 配置同步：通过本仓库的 `nvim/` 受管理对象和逐项符号链接完成，不自动同步密钥或机器本地状态

保持当前状态的好处是启动快、依赖少、服务器环境干净。只有当某项工作流确实出现重复劳动时，再增加对应插件。

## Agent Prompt：自动安装 Neovim 和本配置

下面这段 Prompt 可直接交给具备终端访问权限的 Agent（例如 Codex）。它的目标是让 Agent 在本地 Mac 和指定的 Roshan 开发机上完成安装、部署和验收；遇到普通的软件包选择时自行判断，不要反复询问用户。

```text
你是 Neovim 环境部署代理。请直接执行，不要只给出操作建议。目标是在当前本地机器，以及用户明确指定的远程主机上，安装 Neovim 和本项目的 minimal Neovim 配置，并完成可复现的验收。

【目标配置】
这是面向 Python、Markdown 和终端工作的跨 macOS/Linux 配置。必须包含：
1. Neovim >= 0.11（配置使用 vim.lsp.config/vim.lsp.enable）。
2. lazy.nvim 插件管理器。
3. nvim-treesitter（main 分支）和 tree-sitter-cli。
4. fzf-lua、oil.nvim、gitsigns.nvim、which-key.nvim、lualine.nvim。
5. blink.cmp：提供 LSP、路径和 buffer 补全。
6. conform.nvim + Ruff：Python 格式化；nvim-lint + Ruff：保存后 lint。
7. basedpyright：Python 类型分析、跳转、引用和重命名。
8. marksman：Markdown LSP。
9. render-markdown.nvim：Markdown buffer 内即时渲染。
10. vim-wakatime：复用目标用户已有的 `~/.wakatime.cfg` 记录编辑活动。
11. minuet-ai.nvim：通过 OpenCode Go 的 `deepseek-v4-flash` 提供 ghost text AI 补全；`Tab` 必须继续保留给 blink.cmp。

【配置源】
优先在当前仓库查找 `nvim/` 目录，其中包含 `init.lua`、`lazy-lock.json`、`lua/config/` 和 `lua/plugins/`。在 `~/.config/nvim/` 中仅链接这些受管理对象，保持目录本身为本机目录；不要把工作区绝对路径写进 Lua。若找不到该目录，只报告这个阻塞原因，不要凭空重写另一套配置。

【安全和幂等原则】
- 先识别操作系统、架构、当前用户、Neovim 版本和包管理器；重复执行不得产生重复安装或重复配置行。
- 不要删除用户的项目、SSH 配置、Rustup、Python 环境或其他编辑器。
- 若 ~/.config/nvim 是指向本配置源的旧目录软链接，先只解除该软链接并创建本机目录；不要删除其源目录。若已有同名受管理对象且不是本配置软链接，跳过并报告，不覆盖机器本地文件。
- 只在确实需要且有 sudo 权限时使用 sudo。若 apt 中的 Neovim 版本低于 0.11，不要继续保留这个无用旧版本：改用官方新版本（优先用户目录/AppImage/tarball），验证成功后仅卸载旧的 apt Neovim 包，不要清理无关依赖。
- 不安装 Mason、clangd、nvim-dap、neotest、LuaRocks、Node/Perl/Ruby provider，也不安装 Copilot、Codeium 或其他额外 AI provider。
- 不要读取、复制、打印或提交 `~/.wakatime.cfg`、`~/.config/nvim/.env`、`~/.hermes/.env` 或其他凭据。WakaTime 仅复用目标用户已有的共享配置。
- 只有在 SSH 不可用、需要密码/二次认证或配置源缺失时才请求用户介入；不要猜测凭据。

【本地依赖安装】
- macOS：使用 Homebrew 安装缺失的 neovim、git、ripgrep、fd、fzf、tree-sitter-cli；使用 uv 安装缺失的 ruff 和 basedpyright；使用包管理器或官方发布二进制安装缺失的 marksman。
- Debian/Ubuntu：先 apt-get update；安装缺失的 git、ripgrep、fd-find、fzf、curl、ca-certificates 和编译/解压所需的最小工具。Neovim 必须达到 >=0.11，否则使用官方发布版本。Ruff 和 basedpyright 优先用 uv tool install，marksman 使用发行版包或官方发布二进制，tree-sitter-cli 使用发行版包或官方发布版本。
- 用户级可执行文件统一放在 ~/.local/bin，并确保当前 shell 和后续登录 shell 的 PATH 包含 ~/.local/bin；fd-find 若只提供 fdfind，提供用户级 fd 兼容命令。
- 安装后检查：nvim、git、rg、fd、fzf、tree-sitter、ruff、basedpyright-langserver、marksman 都能在 PATH 中找到。

【部署配置】
- 创建 ~/.config/nvim 本机目录，并逐项链接 `init.lua`、`lazy-lock.json` 和 `lua/`；不要复制完整目录或把工作区的绝对路径写进 Lua。保留该目录中的本地 `.env` 等非受管理文件。
- 确认 leader/localleader 都是空格，远程 SSH 会话中 Neovim 使用 OSC52 剪贴板。
- 若目标机使用 tmux，幂等地确保 ~/.tmux.conf 含有：set -s set-clipboard on；不要重复添加。必要时重新加载 tmux 配置。
- 启动 Neovim，让 init.lua 自动安装 lazy.nvim，然后执行 Lazy sync/安装缺失插件。不要启用 LuaRocks。
- 配置 Minuet 使用 OpenCode Go 的 OpenAI-compatible Chat Completions endpoint 和 `deepseek-v4-flash`，保持 `Tab` 只用于 blink.cmp。密钥仅从目标机器已导出的 `OPENCODE_GO_API_KEY`、`OPENCODE_GO_API_KEY_FILE` 指向的私有文件、`~/.config/nvim/.env` 或 `~/.hermes/.env` 读取，绝不写入仓库或复制到远程主机。
- 对 Python 项目识别 .venv 或 venv；不要创建或修改用户的虚拟环境。

【远程主机】
- 若用户要求部署 roshan4-gpu 和 roshan4-cpu，使用系统 OpenSSH 的 ssh 命令和用户已有的 Host 别名（例如 ssh roshan4-gpu），不要依赖 GUI 编辑器的 SSH 解析器。
- 需要 TTY 时使用 ssh -tt。传输配置优先用 ssh 管道（tar/stdin 或 base64 写入），不要假定 scp 能正确处理跳板机、多层 ProxyJump 或复杂 SSH config。
- 在每台远程机上独立执行依赖安装、配置部署、插件同步和验收；不要把 macOS 二进制复制到 Linux。

【验收】
每个目标都必须完成以下检查，并记录实际版本和路径：
1. nvim --version >= 0.11，且 `nvim --headless -u ~/.config/nvim/init.lua +'qa!'` 无启动错误。
2. Lazy、Tree-sitter、blink.cmp、Conform、nvim-lint、LSP、WakaTime 和 Minuet 配置均能加载。
3. 创建临时 .md 文件，用 headless Neovim 验证 `require('render-markdown')` 成功、`:RenderMarkdown` 命令存在且默认启用；随后删除临时文件。
4. 打开临时 Python 文件，确认 basedpyright 可启动；确认 Ruff 可执行。
5. Markdown 文件的 marksman 可启动；远程机确认 SSH_CONNECTION 时使用 OSC52，tmux 设置已生效。
6. 检查 `:messages`、`:checkhealth` 和 Lazy 状态，修复由本次部署引入的错误。
7. 验证 `:WakaTimeToday`、`:Minuet virtualtext toggle` 和 Minuet 的 `Ctrl-l`、`Ctrl-j`、`Ctrl-]` 映射存在；不要发送或打印任何 API key。

最后用简洁表格报告：每台机器的 Neovim 版本、配置路径、已安装工具、插件同步结果、验收结果、备份路径，以及任何必须由用户手动处理的事项。若某一步失败，先尝试安全的替代安装路径，再报告具体错误和下一步，不要留下半配置状态。
```
