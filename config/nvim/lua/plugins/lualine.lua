return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local palette = require("catppuccin.palettes").get_palette("macchiato")
      local utils = require("utils.lualine")
      local components = utils.components

      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = LazyVim.config.icons

      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function()
                return ""
              end,
              separator = { left = "", right = "" },
              padding = {
                left = 1,
                right = 1,
              },
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "",
              separator = { left = "", right = "" },
              padding = {
                left = 2,
                right = 1,
              },
              color = { bg = palette.mantle, fg = palette.rosewater },
            },
          },
          lualine_c = {
            {
              -- python env
              function()
                if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "python" then
                  local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
                  if venv then
                    return string.format("(%s)", utils.env_cleanup(venv))
                  end
                end
                return ""
              end,
              separator = { left = "", right = "" },
              color = { fg = palette.yellow, bg = palette.mantle },
              padding = { left = 0, right = 1 },
            },

            {
              "diff",
              colored = true,
              symbols = { added = " ", modified = " ", removed = " " },
              separator = { left = "", right = "" },
              color = { bg = palette.mantle },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "hint" },
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              colored = true,
              separator = { left = "", right = "" },
              color = { bg = palette.mantle },
            },
            {
              LazyVim.lualine.pretty_path(),
            },
          },

          lualine_x = {
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = { fg = palette.subtext0 },
              padding = { left = 1, right = 2 },
              separator = { right = "" },
            },
            {
              -- copilot
              utils.copilot_status_icon,
              padding = { left = 0, right = 2 },
              separator = { right = "" },
              color = { fg = palette.flamingo },
            },
            components.mcphub,
            {
              -- lsp
              function()
                local default_msg = "No LSP"

                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if next(clients) == nil then
                  return default_msg
                end

                local client_names = {}
                for _, client in ipairs(clients) do
                  if client.name ~= "copilot" then
                    table.insert(client_names, client.name)
                  end
                end

                local text_client = table.concat(client_names, ", ")
                if text_client == "" then
                  return default_msg
                end
                return text_client
              end,
              icon = " ",
              color = { fg = palette.yellow },
              padding = { left = 0, right = 2 },
            },
            {
              "encoding",
              color = { fg = palette.pink },
              padding = { left = 0, right = 2 },
            },
            {
              "fileformat",
              color = { fg = palette.blue },
              padding = { left = 0, right = 2 },
            },
            {
              function()
                return "󱞩 "
              end,
              separator = {
                left = "",
              },
              color = { bg = palette.teal, fg = palette.base },
              padding = 0.3,
            },
            {
              function()
                return "" .. vim.bo.shiftwidth
              end,
              padding = { left = 1, right = 0.5 },
              separator = {
                right = "",
              },
              color = { bg = palette.mantle, fg = palette.text },
            },
            components.spaces,
            {
              function()
                return " "
              end,
              separator = {
                left = "",
              },
              color = { bg = palette.yellow, fg = palette.base },
              padding = 0.3,
            },
            {
              "filetype",
              icon_only = false,
              colored = true,
              padding = { left = 1, right = 0.5 },
              separator = {
                right = "",
              },
              color = { bg = palette.mantle, fg = palette.text },
            },
            components.spaces,
            {
              function()
                return " "
              end,
              separator = {
                left = "",
              },
              color = { bg = palette.blue, fg = palette.base },
              padding = 0.3,
            },
            {
              "progress",
              separator = {
                right = "",
              },
              color = { bg = palette.mantle, fg = palette.text },
              padding = { left = 1, right = 0.5 },
            },
          },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy", "fzf" },
      }

      -- do not add trouble symbols if aerial is enabled
      -- And allow it to be overriden for some buffer types (see autocmds)
      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        local trouble = require("trouble")
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "{kind_icon}{symbol.name:Normal}",
          hl_group = "lualine_c_normal",
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end

      return opts
    end,
  },
}
