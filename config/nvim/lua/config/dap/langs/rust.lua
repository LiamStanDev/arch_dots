local dap = require("dap")
local utils = require("utils.dap") -- Assumed to be available
local picker = require("utils.picker") -- Assumed to be available

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

	-- NOTE: Requires a working utils.picker module (e.g., built on top of nvim-floatwin/telescope)
	return picker.select_sync(targets, opts)
end

-- Codelldb initialization commands
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
		name = "Attach",
		type = "codelldb",
		request = "attach",
		program = function()
			return select_target("bins")
		end,
		pid = function()
			local name = vim.fn.input("Executable name (filter): ")
			return require("dap.utils").pick_process({ filter = name })
		end,
		cwd = "${workspaceFolder}",
		initCommands = initCommandsLLDB,
	},
}
