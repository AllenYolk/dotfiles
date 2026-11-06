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
    "lervag/vimtex",
    ft = { "tex", "plaintex", "bib" },
    init = function()
      vim.g.vimtex_compiler_enabled = true
      vim.g.vimtex_compiler_method = "generic"
      vim.g.vimtex_compiler_generic = {
        command = "tectonic -X build",
      }
      vim.g.vimtex_view_enabled = false
      vim.g.vimtex_complete_enabled = false
    end,
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
    },
  },
}
