local plugin = require("utils.plugin_source")

return {
  {
    plugin.source("stevearc/conform.nvim"),
    event = { "BufWritePre" },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "" then
          return
        end
        return { lsp_fallback = true, timeout_ms = 1000 }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    plugin.source("williamboman/mason.nvim"),
    event = "VeryLazy",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
    opts = {
      max_concurrent_installers = 10,
    },
  },
  {
    plugin.source("WhoIsSethDaniel/mason-tool-installer.nvim"),
    event = "VeryLazy",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    dependencies = {
      plugin.source("williamboman/mason.nvim"),
    },
    opts = {
      ensure_installed = {
        "tree-sitter-cli",
        "lua-language-server",
        "stylua",
      },
      run_on_start = true,
      start_delay = 0,
    },
  },
  {
    plugin.source("hrsh7th/nvim-cmp"),
    event = "InsertEnter",
    dependencies = {
      plugin.source("hrsh7th/cmp-buffer"),
      plugin.source("hrsh7th/cmp-nvim-lsp"),
      plugin.source("hrsh7th/cmp-path"),
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if cmp.get_selected_entry() then
                cmp.confirm({ select = false })
              else
                cmp.select_next_item()
              end
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    plugin.source("neovim/nvim-lspconfig"),
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      plugin.source("WhoIsSethDaniel/mason-tool-installer.nvim"),
      plugin.source("williamboman/mason.nvim"),
      plugin.source("hrsh7th/cmp-nvim-lsp"),
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("vsvim-lsp", { clear = true }),
        callback = function(args)
          local buffer = args.buf
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buffer, desc = desc, silent = true })
          end

          map("K", vim.lsp.buf.hover, "Hover")
          map("gd", vim.lsp.buf.definition, "Definition")
          map("gr", vim.lsp.buf.references, "References")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
        end,
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")
    end,
  },
}
