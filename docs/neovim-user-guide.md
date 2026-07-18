# Neovim User Guide

This is a focused Neovim configuration for Python, Markdown, and terminal work. Its source is `nvim/`; plugin versions are pinned in `nvim/lazy-lock.json`.

This page explains daily use. Dependencies, links, plugin synchronization, and recovery are in [Neovim Operations](operations/neovim.md). Do not put credentials, WakaTime configuration, or local `.env` files in this repository.

## Conventions

`<leader>` is Space. For example, `<leader>ff` means Space, then `f`, then `f`. Return to Normal mode with `Esc` before using a mapping.

| Mode | Enter | Return to Normal | Use |
| --- | --- | --- | --- |
| Normal | `Esc` | Already normal | Move, edit, search, and invoke mappings |
| Insert | `i`, `a`, or `o` | `Esc` | Type text |
| Visual | `v`, `V`, or `Ctrl-v` | `Esc` | Select characters, lines, or a block |
| Command-line | `:` | `Esc` | Run commands such as `:Gitsigns ...` |

For example, select with `v` and press `d` to delete or `y` to copy. Use `V` to select whole lines, then `>` to indent them. If a mapping does not work, press `Esc` once and try again.

## Quick Start

```bash
nvim .
```

| Goal | Entry point |
| --- | --- |
| Find a file or search the project | `<Space>ff` / `<Space>fg` |
| Read or edit Python | `gd`, `K`, `<Space>ca`, `<Space>cf` |
| Work with Markdown | `:RenderMarkdown toggle`, `:RenderMarkdown preview` |
| Inspect a file's Git changes | `<Space>gp`, `<Space>gd` |
| Stage a selected change | `<Space>gs`, then `git diff --cached` |
| Search Git objects | `<Space>gg`, `<Space>gc`, or `<Space>gb` |
| Run full Git commands | `<Space>tn` |

For remote work:

```bash
ssh <host>
tmux new -As work
nvim .
```

Over SSH, Neovim selects OSC52 clipboard support. In Visual mode, use `"+y` to copy the selection to the local clipboard; in Normal mode, use `"+yy` to copy the current line. Do not copy passwords, keys, or other sensitive text through an untrusted terminal.

## Keymap Reference

### Files, Windows, and Terminal

| Mapping | Action |
| --- | --- |
| `<Space>w` / `<Space>q` | Save file / quit current window |
| `<Space>e` | Open built-in file explorer |
| `<Space>o` | Open Oil file manager |
| `<Space>h/j/k/l` | Move to left/down/up/right window |
| `<Space>tn` | Open a terminal below the editor |
| `<Esc><Esc>` | Leave terminal mode |
| `<Space>cd` | Set working directory to current file's directory |
| `<Space>xx` | Open quickfix list |
| `<Esc>` | Clear search highlighting |

### Search

| Mapping | Action |
| --- | --- |
| `<Space>ff` | Find files |
| `<Space>fg` | Live project grep; requires `rg` |
| `<Space>fb` | Search open buffers |
| `<Space>fh` | Search Neovim help tags |

which-key displays available leader mappings after Space is pressed briefly.

### LSP and Diagnostics

| Mapping | Action |
| --- | --- |
| `gd` / `gD` / `gr` | Definition / declaration / references |
| `K` | Hover documentation |
| `<Space>rn` / `<Space>ca` | Rename symbol / code action |
| `<Space>D` | Type definition |
| `[d` / `]d` | Previous / next diagnostic |
| `<Space>dd` | Current diagnostic details |

### Completion and AI

`blink.cmp` supplies LSP, path, and buffer completion. Minuet supplies separate ghost text, so its suggestions do not share the completion menu.

| Mapping | Action |
| --- | --- |
| `Ctrl-Space` | Open completion manually |
| `Ctrl-n` / `Ctrl-p` | Next / previous completion item |
| `Tab` / `Shift-Tab` | Accept item or move forward / back through snippet placeholders |
| `Ctrl-e` | Close completion |
| `Ctrl-b` / `Ctrl-f` | Scroll completion documentation |
| `Ctrl-l` / `Ctrl-j` / `Ctrl-]` | Accept Minuet suggestion / accept one line / dismiss it |

Minuet uses OpenCode Go with `deepseek-v4-flash`. It reads `OPENCODE_GO_API_KEY` from the environment, an `OPENCODE_GO_API_KEY_FILE`, `~/.config/nvim/.env`, or `~/.hermes/.env`, in that order. Keep the key private. Minuet sends editing context to its provider and does not auto-trigger in Markdown, help, or Oil buffers.

### Python Formatting and Linting

| Action | Result |
| --- | --- |
| `<Space>cf` | Format current Python buffer with Ruff and organize imports |
| Save a Python file | Run Ruff lint |
| `<Space>dd` | Inspect Ruff or LSP diagnostics |

Formatting is not automatic on save.

## Git: Diff, Staging, and History

`gitsigns.nvim` operates on hunks in the current buffer. fzf-lua locates Git objects. Use the terminal for repository-wide operations such as commits, merges, rebases, pushes, pulls, and conflict resolution. Start Neovim inside a Git worktree; untracked files have no Git hunks.

### Current-File Diff

The sign column marks added, changed, and deleted hunks. Place the cursor in a hunk and use:

| Command | Action |
| --- | --- |
| `:Gitsigns nav_hunk next` / `prev` | Jump to the next or previous hunk |
| `:Gitsigns preview_hunk` | Show the hunk patch in a floating window |
| `:Gitsigns preview_hunk_inline` | Expand the patch inline |
| `:Gitsigns diffthis` | Diff current file against the index, like its unstaged diff |
| `:Gitsigns diffthis HEAD` | Diff current file against `HEAD`, including staged and unstaged changes |
| `:Gitsigns diffthis HEAD~1` | Compare current file with the previous commit |
| `:Gitsigns change_base HEAD~1` | Temporarily use a previous commit as the sign-column base |
| `:Gitsigns change_base` | Restore the default base |

Use `:diffoff!` to leave diff mode; use `:only` if you also want to close the extra windows. Changing the Gitsigns base only changes its display, never Git history or the worktree.

### Git Keymaps

The Gitsigns mappings below are buffer-local: they exist only for files attached to Gitsigns in a Git worktree. The fzf-lua picker mappings are global and can run from any normal buffer.

| Mapping | Action |
| --- | --- |
| `<Space>gn` / `<Space>gN` | Next / previous hunk |
| `<Space>gp` / `<Space>gi` | Preview current hunk in a popup / inline |
| `<Space>gd` / `<Space>gD` | Diff current file against index / `HEAD` |
| `<Space>gs` / `<Space>gr` | Stage or reset current hunk; in Visual mode, stage or reset the selection |
| `<Space>gS` / `<Space>gR` | Stage or reset every hunk in the current file |
| `<Space>gl` | Full blame for the current line |
| `<Space>gg` | Open fzf-lua Git status |
| `<Space>gc` / `<Space>gC` | Open project / current-buffer commit history |
| `<Space>gb` | Open the branch picker |

### Hunk Staging and Reset

| Command | Action and boundary |
| --- | --- |
| `:Gitsigns stage_hunk` | Stage the current hunk. On a staged hunk, run it again to unstage. In Visual mode it can stage a selected part of a hunk. |
| `:Gitsigns reset_hunk` | Restore the current hunk from the index; discards its unstaged changes. |
| `:Gitsigns stage_buffer` | Stage all changes in the current file. Review the diff first. |
| `:Gitsigns reset_buffer` | Restore all hunks in the current file from the index; discards unstaged changes. |

The commands remain useful for advanced cases. `reset_hunk` and `reset_buffer`, including `<Space>gr` and `<Space>gR`, are destructive worktree operations, so preview first.

### Blame, Revisions, and Pickers

| Command | Action |
| --- | --- |
| `:Gitsigns blame_line` | Show the current line's last commit in a popup |
| `:Gitsigns blame` | Open blame for the current file |
| `:Gitsigns show` | Open the index version of the file. It is writable; saving it directly changes the staging area. |
| `:Gitsigns show HEAD~1` | Inspect a historical version. Do not save changes in a revision buffer. |
| `:FzfLua git_status` | Browse worktree status and open a file |
| `:FzfLua git_commits` / `git_bcommits` | Search project history / current-file history |
| `:FzfLua git_branches` | Browse branches and use the picker actions |
| `:FzfLua git_files` | Search tracked files only |

The Git picker mappings lazy-load fzf-lua automatically, so `<Space>gg`, `<Space>gc`, `<Space>gC`, and `<Space>gb` work in a fresh session. In the branch picker, `Enter` switches branches, `Ctrl-a` creates a branch, and `Ctrl-x` deletes a branch. Check `git status --short` first and use the destructive branch action only deliberately. The `:FzfLua` commands remain available after the plugin has loaded.

### Commit Review Loop

1. Run `<Space>gg` or `git status --short`.
2. Review each file with `<Space>gp` or `<Space>gd`.
3. Run `<Space>gs` only for reviewed changes. Run it again on a staged hunk to unstage it.
4. Open a terminal with `<Space>tn`, inspect `git diff --cached`, and run project tests.
5. Run `git commit`, then confirm the result with `git status`.

```bash
git status --short
git diff
git diff --cached
git diff HEAD
git log --oneline --decorate --graph -20
git show <commit>
git restore --staged <path>
```

### Branches, Sync, and Conflicts

First confirm local changes with `git status --short`, then use the terminal:

```bash
git fetch --prune
git switch <branch>
git switch -c <branch>
git pull --ff-only
git push -u origin <branch>
git push
```

Before integrating a target branch, run `git fetch --prune`. Use `git merge origin/<target>` when the team wants an integration commit. Use `git rebase origin/<target>` only for an unshared branch when a linear local history is wanted. Do not casually rebase a branch other people use, and never force-push over remote history.

For a conflict:

1. Run `git status`, then open each conflicted file with `nvim <path>`.
2. Resolve `<<<<<<<`, `=======`, and `>>>>>>>` markers, remove every marker, and save with `<Space>w`.
3. Run `git add <path>`, then `git merge --continue` or `git rebase --continue`.
4. To stop, use `git merge --abort` or `git rebase --abort`. Do not use `git reset --hard` as a shortcut.

## Plugin Use

### lazy.nvim and Tree-sitter

lazy.nvim provides the pinned plugins used here. Plugin synchronization, upgrades, cleanup, parser installation, and parser compilation are maintenance tasks; follow [Neovim Operations](operations/neovim.md). Tree-sitter supplies syntax highlighting and structural indentation; it is not an LSP or type checker.

### fzf-lua

fzf-lua is the search interface, not a file manager or LSP replacement. Use the four configured leader mappings, type to filter results, and confirm a choice to open it. It requires `rg` for live grep.

### Oil

Use `<Space>o` to edit a directory like a buffer. `Enter` opens, `-` goes to the parent directory, `g.` toggles hidden files, `Ctrl-p` previews, `Ctrl-s` opens vertically, `Ctrl-h` opens horizontally, and `g?` shows help. Saving displays a change confirmation; accepting it applies filesystem changes.

### which-key, lualine, and icons

which-key shows leader mappings. lualine provides the status line. `nvim-web-devicons` provides icons; use a Nerd Font when icons appear as boxes or empty characters.

### render-markdown

Markdown buffers render headings, lists, quotes, code blocks, and checkboxes in-place. It is not a browser renderer; complex HTML, CSS, Mermaid, LaTex, and site-specific extensions can differ from final output.

```vim
:RenderMarkdown toggle
:RenderMarkdown enable
:RenderMarkdown disable
:RenderMarkdown preview
```

### WakaTime

`vim-wakatime` uses the machine-local `~/.wakatime.cfg` and WakaTime CLI. It sends editing activity to the configured account.

```vim
:WakaTimeToday
```

## Python and Markdown

### Python: basedpyright and Ruff

Python project roots are detected from `pyproject.toml`, `uv.lock`, `setup.py`, `setup.cfg`, `requirements.txt`, `.python-version`, or `.git`. When a project contains `.venv` or `venv`, the configuration uses its Python interpreter.

```text
project/
├── pyproject.toml
├── uv.lock
├── .venv/
└── src/
```

Use `:LspInfo` and `:checkhealth vim.lsp` for LSP status. basedpyright provides types, definitions, references, and semantic diagnostics. Ruff provides formatting, import organization, and style diagnostics.

### Markdown: marksman and render-markdown

marksman provides headings, links, references, and structural diagnostics. render-markdown supplies the in-editor display. Use `:RenderMarkdown toggle` when you need to edit raw Markdown syntax.

## Essential Vim Editing

| Motion | Action |
| --- | --- |
| `w` / `b` / `e` | Next word / previous word / end of word |
| `0` / `^` / `$` | Line start / first non-blank / line end |
| `gg` / `G` | File start / file end |
| `{` / `}` / `%` | Previous paragraph / next paragraph / matching delimiter |
| `f{char}`, `;`, `,` | Find a character, repeat, reverse repeat |
| `Ctrl-d` / `Ctrl-u` | Half-page down / up |

Combine an operator with a motion or text object:

```text
di"     delete inside quotes
da(     delete parentheses and contents
yap     copy a paragraph
dap     delete a paragraph
ci[     change inside brackets
```

Useful editing and search commands:

```text
.       repeat last change
u       undo
Ctrl-r  redo
>> / << indent / unindent
J       join lines
```

```vim
/pattern
?pattern
n / N
* / #
:%s/old/new/gc
```

Registers, macros, and windows:

```text
yy, dd, p, P        copy, delete, paste
"ayy, "ap           copy to and paste from register a
qq / q, @q, @@       record, run, repeat macro q
Ctrl-w s / v         horizontal / vertical split
Ctrl-w h/j/k/l       move between windows
Ctrl-w = / o         equalize / keep only current window
:bnext, :bprev, :bd  switch or close buffers
```

## Common Tasks

### Modify a Python Function

1. Open a file with `<Space>ff` and search with `/name`.
2. Use `gd` for the definition and `K` for documentation.
3. Edit with text objects such as `ciw`, `ci(`, or `dap`.
4. Run `<Space>cf`, save with `<Space>w`, and inspect diagnostics.

### Resolve a Type Error

1. Use `<Space>dd` at the diagnostic.
2. Read documentation with `K` and use `<Space>ca` for code actions.
3. Visit other diagnostics with `[d` and `]d`.
4. Use `<Space>rn` for a symbol-aware rename.

### Write Markdown

Open the file with `<Space>ff`. Use normal motions and text objects to edit, marksman for structural diagnostics, and `:RenderMarkdown toggle` or `:RenderMarkdown preview` to change the reading view.

## Troubleshooting

| Problem | Checks |
| --- | --- |
| Completion missing | `:LspInfo`, `:checkhealth vim.lsp`, then `Ctrl-Space` |
| Minuet has no suggestion | `:Minuet virtualtext enable`; confirm the buffer is not Markdown, help, or Oil and a private key source exists |
| WakaTime is not recording | `:WakaTimeToday`; use `:WakaTimeDebugEnable` and inspect `~/.wakatime/wakatime.log` |
| Ruff is not running | `ruff --version`, `:ConformInfo`, `:lua require("lint").try_lint()` |
| Tree-sitter has no highlighting | `:checkhealth nvim-treesitter`; follow [Neovim Operations](operations/neovim.md) for confirmed parser maintenance |
| Icons are missing | Confirm nvim-web-devicons is installed and use a Nerd Font such as MesloLGS NF |
| Plugin state is unhealthy | `:checkhealth`; follow [Neovim Operations](operations/neovim.md) for synchronization or cleanup |

Do not delete `~/.local/share/nvim` merely to address a plugin error. Inspect the specific plugin output and `:checkhealth` first.

## Deliberate Limits

This configuration does not include CUDA/C semantic LSP (`clangd`), nvim-dap, neotest, Copilot, Codeium, or another AI provider. Add a tool only when a repeated workflow requires it.

## Agent Deployment

Deployment is governed by the repository [AGENTS.md](../AGENTS.md). Dependencies, granular linking, plugin synchronization, and validation are in [Neovim Operations](operations/neovim.md).
