local dap = require("dap")
local utils = require("utils.dap")

--- Parses the JSON output from Cargo to extract the executable path.
-- @param input The JSON string output from Cargo.
-- @return The path to the executable if found, otherwise nil.
local function analyze_compiler_target(input)
	local _, json = pcall(vim.fn.json_decode, input)

	if
		type(json) == "table"
		and json.reason == "compiler-artifact"
		and json.executable ~= nil
		and (vim.tbl_contains(json.target.kind, "bin") or json.profile.test)
	then
		return json.executable
	end
	return nil
end

--- Extracts and returns compiler error messages from Cargo JSON output.
-- @param input The JSON string output from Cargo.
-- @return The rendered error message if found, otherwise nil.
local function compiler_error(input)
	local _, json = pcall(vim.fn.json_decode, input)

	if type(json) == "table" and json.reason == "compiler-message" then
		return json.message.rendered
	end

	return nil
end

--- Lists all executable targets (binaries or tests) by running Cargo build.
-- @param selection The type of targets to list ("bins" or "tests").
-- @return A list of executable paths or nil if an error occurs.
local function list_targets(selection)
	local arg = string.format("--%s", selection or "bins")

	-- Cargo build command
	local cmd = { "cargo", "build", arg, "--quiet", "--message-format", "json" }

	local out = vim.fn.systemlist(cmd)

	if vim.v.shell_error ~= 0 then
		local errors = vim.tbl_map(compiler_error, out)
		vim.notify(table.concat(errors, "\n"), vim.log.levels.ERROR)
		return nil
	end

	local function filter(e)
		return e ~= nil
	end

	return vim.tbl_filter(filter, vim.tbl_map(analyze_compiler_target, out))
end

--- Synchronously selects a target executable.
-- @param selection The type of targets to list ("bins" or "tests").
-- @return The selected target path or nil if no target is selected.
local function select_target(selection)
	local targets = list_targets(selection)

	if targets == nil then
		return nil
	end

	if #targets == 0 then
		return utils.read_target()
	end

	if #targets == 1 then
		return targets[1]
	end

	-- If multiple targets are found, show a selection menu.
	local opts = {
		prompt = "Select a target:",
		format_item = function(path)
			local parts = vim.split(path, utils.get_sep(), { trimempty = true })
			return parts[#parts]
		end,
	}

	return require("utils.picker").select_sync(targets, opts)
end

--- Extracts the test function name from the current line.
-- @return The test function name if found, otherwise nil.
local function select_test_cursor()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local current_line = vim.api.nvim_get_current_line()

	-- current line should have 'fn (...)'
	local test_match = string.match(current_line, "fn%s+([%w_]+)")

	if test_match then
		-- check previous line for #[test] attribute (if not the first line)
		if row > 1 then
			local prev_line = vim.api.nvim_buf_get_lines(0, row - 2, row - 1, false)[1] -- Lua's indices are 1-based, nvim_buf_get_lines uses 0-based for start
			if string.match(prev_line:match("^%s*(.*)$"), "#%[test%]") then
				return test_match
			end
		end
		-- check current line for #[test] attribute
		if string.match(current_line, "#%[test%]") then
			return test_match
		end
	end

	return nil
end

-- Rust GDB
-- dap.configurations.rust = {
-- 	{
-- 		name = "Debug",
-- 		type = "rust-gdb",
-- 		request = "launch",
-- 		program = function()
-- 			return select_target("bins")
-- 		end,
-- 		cwd = "${workspaceFolder}",
-- 		stopAtBeginningOfMainSubprogram = false,
-- 	},
--
-- 	{
-- 		name = "Debug (+args)",
-- 		type = "rust-gdb",
-- 		request = "launch",
-- 		program = function()
-- 			return select_target("bins")
-- 		end,
-- 		args = utils.read_args,
-- 		cwd = "${workspaceFolder}",
-- 		stopAtBeginningOfMainSubprogram = false,
-- 	},
--
-- 	{
-- 		name = "Debug tests",
-- 		type = "rust-gdb",
-- 		request = "launch",
-- 		program = function()
-- 			return select_target("tests")
-- 		end,
-- 		args = { "--test-threads=1" },
-- 		cwd = "${workspaceFolder}",
-- 	},
--
-- 	{
-- 		name = "Debug tests (+args)",
-- 		type = "rust-gdb",
-- 		request = "launch",
-- 		program = function()
-- 			return select_target("tests")
-- 		end,
-- 		args = function()
-- 			return vim.list_extend(utils.read_args(), { "--test-threads=1" })
-- 		end,
-- 		cwd = "${workspaceFolder}",
-- 	},
--
-- 	{
-- 		name = "Debug tests (cursor)",
-- 		type = "rust-gdb",
-- 		request = "launch",
-- 		program = function()
-- 			return select_test_cursor()
-- 		end,
-- 		args = function()
-- 			local test = select_test_cursor()
-- 			local args = test and { "--exact", test } or {}
-- 			return vim.list_extend(args, { "--test-threads=1" })
-- 		end,
-- 		cwd = "${workspaceFolder}",
-- 	},
--
-- 	{
-- 		name = "Attach",
-- 		type = "rust-gdb",
-- 		request = "attach",
-- 		program = function()
-- 			return select_target("bins")
-- 		end,
-- 		args = function()
-- 			local test = select_test_cursor()
-- 			local args = test and { "--exact", test } or {}
-- 			return vim.list_extend(args, { "--test-threads=1" })
-- 		end,
-- 		pid = function()
-- 			local name = vim.fn.input("Executable name (filter): ")
-- 			return require("dap.utils").pick_process({ filter = name })
-- 		end,
-- 		cwd = "${workspaceFolder}",
-- 	},
--
-- 	{
-- 		name = "Attach to gdb server:1234",
-- 		type = "rust-gdb",
-- 		request = "attach",
-- 		target = "localhost:1234",
-- 		cwd = "${workspaceFolder}",
-- 	},
-- }

-- Codelldb
local function initCommandsLLDB()
	-- Get the commands from the Rust installation.
	local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
	if rustc_sysroot == "" then
		vim.notify("Failed to retrieve Rust sysroot", vim.log.levels.ERROR)
		return {}
	end
	-- Script provides custom logic to interpret and display Rust types and data structures correctly.
	local script_path = rustc_sysroot .. "/lib/rustlib/etc/lldb_lookup.py"
	-- Contains a set of predefined LLDB commands.
	local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

	local cmds = { 'command script import "' .. script_path .. '"' }
	local file = io.open(commands_file, "r")
	if file then
		for line in file:lines() do
			table.insert(cmds, line)
		end
		file:close()
	end

	return cmds
end

dap.configurations.rust = {
	{
		name = "Debug",
		type = "codelldb",
		request = "launch",
		program = function()
			return select_target("bins")
		end,
		cwd = "${workspaceFolder}",
		initCommands = initCommandsLLDB,
		stopOnEntry = false,
	},

	{
		name = "Debug (+args)",
		type = "codelldb",
		request = "launch",
		program = function()
			return select_target("bins")
		end,
		args = utils.read_args,
		cwd = "${workspaceFolder}",
		initCommands = initCommandsLLDB,
		stopOnEntry = false,
	},

	{
		name = "Debug tests",
		type = "codelldb",
		request = "launch",
		program = function()
			return select_target("tests")
		end,
		args = { "--test-threads=1" },
		cwd = "${workspaceFolder}",
		initCommands = initCommandsLLDB,
	},

	{
		name = "Debug tests (+args)",
		type = "codelldb",
		request = "launch",
		program = function()
			return select_target("tests")
		end,
		args = function()
			return vim.list_extend(utils.read_args(), { "--test-threads=1" })
		end,
		cwd = "${workspaceFolder}",
		initCommands = initCommandsLLDB,
	},

	{
		name = "Debug tests (cursor)",
		type = "codelldb",
		request = "launch",
		program = function()
			return select_test_cursor()
		end,
		args = function()
			local test = select_test_cursor()
			local args = test and { "--exact", test } or {}
			return vim.list_extend(args, { "--test-threads=1" })
		end,
		cwd = "${workspaceFolder}",
		initCommands = initCommandsLLDB,
	},

	{
		name = "Attach",
		type = "codelldb",
		request = "attach",
		program = function()
			return select_target("bins")
		end,
		args = function()
			local test = select_test_cursor()
			local args = test and { "--exact", test } or {}
			return vim.list_extend(args, { "--test-threads=1" })
		end,
		pid = function()
			local name = vim.fn.input("Executable name (filter): ")
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = "${workspaceFolder}",
		initCommands = initCommandsLLDB,
	},
}
