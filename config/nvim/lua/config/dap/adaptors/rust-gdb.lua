local dap = require("dap")

dap.adapters["rust-gdb"] = {
	type = "executable",
	command = "rust-gdb",
	args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
}
