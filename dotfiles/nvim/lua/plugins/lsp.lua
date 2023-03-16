return {
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf",                                config = true },
      { "folke/neodev.nvim",  opts = { experimental = { pathStrict = true } } },
      { 'j-hui/fidget.nvim',  opts = {} },
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    keys = {
      { "K",          vim.lsp.buf.hover,                                  desc = "Hover" },
      { "<leader>ch", vim.lsp.buf.signature_help,                         desc = "Signature Documentation" },
      { "<leader>cd", vim.diagnostic.open_float,                          desc = "Line Diagnostics" },
      { "<leader>cl", "<cmd>LspInfo<cr>",                                 desc = "Lsp Info" },
      { "<leader>cd", "<cmd>Telescope lsp_definitions<cr>",               desc = "Find Definitions" },
      { "<leader>cD", vim.lsp.buf.declaration,                            desc = "Goto Declaration" },
      { "<leader>cr", "<cmd>Telescope lsp_references<cr>",                desc = "Find References" },
      { "<leader>ci", "<cmd>Telescope lsp_implementations<cr>",           desc = "Find Implementation" },
      { "<leader>ct", "<cmd>Telescope lsp_type_definitions<cr>",          desc = "Find Type Definition" },
      { "<leader>cr", vim.lsp.buf.rename,                                 desc = "Rename" },
      { "<leader>ca", vim.lsp.buf.code_action,                            desc = "Code Action" },
      { "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Find symbols (document)" },
      { "<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Find symbols (workspace)" },
      { "<leader>cf", vim.lsp.buf.format,                                 desc = "Format buffer with LSP" }
    }
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Open Mason" } },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  { "folke/neodev.nvim" },
  { "folke/neoconf.nvim" },

  {
    "zbirenbaum/copilot.lua",
    cmd   = "Copilot",
    event = "InsertEnter",
    build = ":Copilot auth",
    opts  = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false,
          accept_word = "<C-l>",
          accept_line = "<C-j>",
          dismiss = "<C-e>",
          next = "<C-n>",
          previous = "<C-p>",
        }
      },
      panel = {
        enabled = true,
        keymap = {
          open = "<C-p>",
        }
      },
    },
  },

  {
    'hrsh7th/nvim-cmp',
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    opts = function()
      local cmp = require("cmp")
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert(
          {
            -- remove c-p default mapping
            ["<C-p>"] = cmp.mapping(function(fallback)
              fallback()
            end, { "i", "s" }),
            -- remove c-n default mapping
            ["<C-n>"] = cmp.mapping(function(fallback)
              fallback()
            end, { "i", "s" }),
            ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
              elseif cmp.visible() then
                cmp.confirm()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<C-e>"] = cmp.mapping.abort()
          }
        ),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end
  },
}
