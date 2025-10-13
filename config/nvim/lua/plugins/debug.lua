return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
		},

    -- stylua: ignore
		keys = {
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
			{ "<leader>dr", function() require("dap").continue() end, desc = "Run", },
			{ "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
			{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
			{ "<leader>dp", function() require("dap").pause() end, desc = "Pause", },
			{ "<leader>dq", function() require("dap").terminate() require("dapui").close() end, desc = "Terminate", },
			{ "<leader>dS", function() require("dap").session() end, desc = "Session", },
			{ "<Down>", function() require("dap").step_over() end, desc = "Step Over" },
			{ "<Right>", function() require("dap").step_into() end, desc = "Step Into" },
			{ "<Left>", function() require("dap").step_out() end, desc = "Step Out" },
			{ "<Up>", function() require("dap").restart_frame() end, desc = "Restar Frame"},
		},
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
		config = function()
			require("config.dap").setup()
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
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
	},
}
