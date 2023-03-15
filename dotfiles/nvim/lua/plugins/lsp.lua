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
      { "I",          vim.lsp.buf.signature_help,                         desc = "Signature Documentation" },
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

  -- cmdline tools and lsp servers
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
}
