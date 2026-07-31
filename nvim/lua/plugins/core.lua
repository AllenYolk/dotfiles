return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Find buffers" },
      { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Help tags" },
      { "<leader>gg", function() require("fzf-lua").git_status() end, desc = "Git status" },
      { "<leader>gc", function() require("fzf-lua").git_commits() end, desc = "Git commits" },
      { "<leader>gC", function() require("fzf-lua").git_bcommits() end, desc = "Git buffer commits" },
      { "<leader>gb", function() require("fzf-lua").git_branches() end, desc = "Git branches" },
    },
    opts = {},
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Oil file manager" },
    },
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(buffer)
        local gitsigns = require("gitsigns")
        local map = function(mode, keys, action, description)
          vim.keymap.set(mode, keys, action, { buffer = buffer, desc = description })
        end

        map("n", "<leader>gn", function() gitsigns.nav_hunk("next") end, "Next Git hunk")
        map("n", "<leader>gN", function() gitsigns.nav_hunk("prev") end, "Previous Git hunk")
        map("n", "<leader>gs", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")
        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")
        map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")
        map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")
        map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>gl", function() gitsigns.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gd", gitsigns.diffthis, "Diff against index")
        map("n", "<leader>gD", function() gitsigns.diffthis("HEAD") end, "Diff against HEAD")
      end,
    },
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = { delay = 200 } },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = { options = { theme = "auto", globalstatus = true } } },
  { "wakatime/vim-wakatime", lazy = false },

  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
      sources = { default = { "lsp", "path", "buffer" } },
      snippets = { preset = "default" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },

  {
    "milanglacier/minuet-ai.nvim",
    lazy = false,
    opts = {
      provider = "openai_compatible",
      request_timeout = 2.5,
      throttle = 1500,
      debounce = 600,
      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = { "help", "markdown", "oil" },
        keymap = {
          accept = "<C-l>",
          accept_line = "<C-j>",
          dismiss = "<C-]>",
        },
        show_on_completion_menu = false,
      },
      provider_options = {
        openai_compatible = {
          api_key = require("config.credentials").minimax_api_key,
          end_point = "https://api.minimaxi.com/v1/chat/completions",
          model = "MiniMax-M3",
          name = "MiniMax",
          optional = {
            max_completion_tokens = 56,
            thinking = { type = "disabled" },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ lsp_format = "never" })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        python = { "ruff_format", "ruff_organize_imports" },
      },
      format_on_save = false,
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = { python = { "ruff" } }

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("RuffLint", { clear = true }),
        pattern = "*.py",
        callback = function(args)
          if vim.bo[args.buf].filetype == "python" then
            lint.try_lint()
          end
        end,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {
      file_types = { "markdown" },
      completions = { lsp = { enabled = true } },
    },
  },
}
