return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Diagnostics
      diagnostics = {
        underline = true,
        update_in_insert = false,
        -- virtual_text = {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = "●",
        -- },
        virtual_text = false,
        severity_sort = true,
        float = { border = "single" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },

      -- Features
      inlay_hints = { enabled = true, exclude = { "vue" } },
      codelens = { enabled = false },

      -- Server configurations
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              cargo = { features = "all", allTarget = false },
              procMacro = { enable = true },
              inlayHints = {
                enable = true,

                -- 類型提示 (Type Hints)
                typeHints = {
                  hideClosureInitialization = true, -- 隱藏閉包初始化的類型
                  hideNamedConstructor = true, -- 隱藏具名構造函數的類型
                },

                -- 隱式 Drop 和生命週期提示
                implicitDrops = true,
                lifetimeElisionHints = {
                  enable = "always", -- 顯示省略的生命週期標註
                },

                -- 通常保持關閉或 off
                closingBraceHints = { enable = "never" },
                bindingModeHints = { enable = false },
              },

              -- 程式碼整理和導入
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
              },
            },
          },
        },
      },
    },
  },
}
