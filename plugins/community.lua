return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  { import = "astrocommunity.colorscheme.github-nvim-theme" },
  -- { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  { import = "astrocommunity.editing-support.multicursors-nvim" },
  { import = "astrocommunity.git.octo-nvim" },
  -- FIXME: this plugin does not work particularly well
  -- { import = "astrocommunity.project.nvim-spectre" },
}
