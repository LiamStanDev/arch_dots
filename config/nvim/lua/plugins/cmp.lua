return {
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "xzbdmw/colorful-menu.nvim",
        config = true,
      },
      "kristijanhusak/vim-dadbod-completion",
      "fang2hou/blink-copilot",
      "saghen/blink.cmp",
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      completion = {
        keyword = { range = "full" },
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = true, auto_insert = true } },
        menu = {
          auto_show = true,
          border = "single",
          draw = {
            columns = { { "kind_icon" }, { "label", "source_id", gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
            treesitter = { "lsp" },
          },
        },
        documentation = {
          window = {
            border = "single",
          },
          auto_show = true,
          auto_show_delay_ms = 100,
        },
        ghost_text = { enabled = false }, -- conflict with menu auto show },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "inherit",
          ["<Tab>"] = { "show", "accept" },
        },
        completion = { menu = { auto_show = true } },
      },
      keymap = {
        preset = "none",

        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        -- ["<C-n>"] = { "show_signature", "hide_signature", "fallback" },

        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
    },
  },
}
