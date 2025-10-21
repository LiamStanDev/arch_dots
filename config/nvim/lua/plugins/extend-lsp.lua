return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      return {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          float = { border = "single" }, -- Floating window style
          -- virtual_text = {
          --   spacing = 4,
          --   source = "if_many",
          --   prefix = "●",
          -- },
          virtual_text = false, -- Disable virtual text
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- Enable this to enable the builtin LSP folding on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the folds.
        folds = {
          enabled = true,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean}
        ---@type table<string, lazyvim.lsp.Config|boolean>
        servers = {
          rust_analyzer = {
            settings = {
              -- ref: https://rust-analyzer.github.io/book/configuration.html
              ["rust-analyzer"] = {
                inlayHints = {
                  maxLength = nil,
                  lifetimeElisionHints = {
                    enable = "skip_trivial",
                    useParameterNames = true,
                  },
                  closureReturnTypeHints = {
                    enable = "always",
                  },
                },
                check = {
                  enabled = true,
                  command = "clippy", -- Use Clippy for linting.
                  features = "all",
                  -- extraArgs = { "--no-deps" }, -- Only check/analyze your project's own code
                },
                checkOnSave = true,
                cargo = {
                  allTargets = false, -- Do not check all targets by default.
                  features = "all", -- Enable all features.
                  buildScripts = {
                    enable = true, -- Enable build script support.
                  },
                },
                procMacro = {
                  enable = true, -- Enable procedural macros.
                  ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                  },
                  attributes = {
                    enable = { "*" },
                  },
                },
                imports = {
                  granularity = {
                    group = "module", -- Group imports by module.
                  },
                  prefix = "self", -- Use `self` as the import prefix.
                },
                files = {
                  excludeDirs = {
                    ".direnv",
                    ".git",
                    ".github",
                    ".gitlab",
                    "bin",
                    "node_modules",
                    "target",
                    "venv",
                    ".venv",
                  },
                },
              },
            },
          },
          basedpyright = {
            analysis = {
              autoSearchPath = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
              typeCheckingMode = "basic",
              diagnosticMode = "workspace",
              inlayHints = {
                callArgumentNames = true,
                functionReturnTypes = true,
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
    end,
  },
}
