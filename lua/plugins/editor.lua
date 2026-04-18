local plugin = require("utils.plugin_source")

return {
  {
    plugin.source("nvim-treesitter/nvim-treesitter"),
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "TSInstall",
      "TSInstallFromGrammar",
      "TSUpdate",
      "TSUninstall",
    },
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup()

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("vsvim-treesitter", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang then
            return
          end

          pcall(vim.treesitter.start, args.buf, lang)
          if vim.treesitter.language.add then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
