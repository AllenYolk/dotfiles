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

  { "lewis6991/gitsigns.nvim", opts = {} },
  { "folke/which-key.nvim", event = "VeryLazy", opts = { delay = 500 } },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = { options = { theme = "auto" } } },
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
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    cmd = {
      "SupermavenStatus",
      "SupermavenToggle",
      "SupermavenUseFree",
      "SupermavenUsePro",
    },
    opts = {
      keymaps = {
        accept_suggestion = "<C-l>",
        accept_word = "<C-j>",
        clear_suggestion = "<C-]>",
      },
      ignore_filetypes = {
        help = true,
        markdown = true,
        oil = true,
      },
      log_level = "off",
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
        callback = function()
          lint.try_lint()
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
    opts = {},
  },
}
