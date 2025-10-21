return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      vim.fn.sign_define("DapBreakpoint", {
        text = "", --"",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    opts = {
      icons = { expanded = "", collapsed = "", circular = "" },
      layouts = {
        {
          elements = {
            { id = "repl", size = 0.3 },
            { id = "breapoints", size = 0.2 },
            { id = "stacks", size = 0.3 },
            { id = "console", size = 0.2 },
          },
          position = "right",
          size = 50,
        },
        {
          elements = {
            { id = "scopes", size = 0.5 },
            { id = "watches", size = 0.5 },
          },
          position = "bottom",
          size = 20,
        },
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
  },
}
