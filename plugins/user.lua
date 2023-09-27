return {
  {
     "lervag/vimtex",
    ft = { "tex", "bib" },
    config = function() vim.g.vimtex_view_method = "zathura" end,
  }

  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
}
