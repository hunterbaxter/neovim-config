local utils = require "astronvim.utils"
return {
  {
    "lervag/vimtex",
    ft = { "tex", "bib" },
    config = function() vim.g.vimtex_view_method = "zathura" end,
  },

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

  -----------------------------------------------------------------------------
  -- Rust Config: This was me trying to get a more powerful plugin
  -- NOTE: this plugin is miserable to configure
  -- {
  --   "mrcjkb/rustaceanvim",
  --   version = "^4", -- Recommended
  --   ft = { "rust" },
  --   init = function()
  --     -- vim.g.rustaceanvim = {
  --     --   -- server.on_attach(),
  --     -- }
  --     local bufnr = vim.api.nvim_get_current_buf()
  --     vim.keymap.set("n", "<leader>la", function()
  --       vim.cmd.RustLsp "codeAction" -- supports rust-analyzer's grouping
  --       -- or vim.lsp.buf.codeAction() if you don't want grouping.
  --     end, { silent = true, buffer = bufnr })
  --     -- return {
  --     --   mappings = {
  --     --     ["<leader>la"] = {
  --     --       function() vim.cmd.RustLsp "codeAction" end,
  --     --       desc = "Find workplace symbols",
  --     --     },
  --     --     ["K"] = {
  --     --       function() vim.cmd.RustLsp "codeAction" end,
  --     --       desc = "Find workplace symbols",
  --     --     },
  --     --   },
  --     -- }
  --   end,
  -- },
  -- Rust Config: I took this out of rust pack to modify
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "rust")
      end
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    init = function() astronvim.lsp.skip_setup = utils.list_insert_unique(astronvim.lsp.skip_setup, "rust_analyzer") end,
    opts = function()
      local adapter
      local success, package = pcall(function() return require("mason-registry").get_package "codelldb" end)
      if success then
        local package_path = package:get_install_path()
        local codelldb_path = package_path .. "/codelldb"
        local liblldb_path = package_path .. "/extension/lldb/lib/liblldb"
        local this_os = vim.loop.os_uname().sysname

        -- The path in windows is different
        if this_os:find "Windows" then
          codelldb_path = package_path .. "\\extension\\adapter\\codelldb.exe"
          liblldb_path = package_path .. "\\extension\\lldb\\bin\\liblldb.dll"
        else
          -- The liblldb extension is .so for linux and .dylib for macOS
          liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
        end
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
      else
        adapter = require("rust-tools.dap").get_codelldb_adapter()
      end

      return { server = require("astronvim.utils.lsp").config "rust_analyzer", dap = { adapter = adapter } }
    end,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "codelldb") end,
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts) opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, "rust_analyzer") end,
  },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    init = function()
      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          require("cmp").setup.buffer { sources = { { name = "crates" } } }
          require "crates"
        end,
      })
    end,
    opts = {
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    },
  },
}
