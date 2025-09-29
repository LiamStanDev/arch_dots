return {
	-- add any opts here
	-- this file can contain specific instructions for your project
	instructions_file = "avante.md",
	-- for example
	provider = "copilot",

	rules = {
		project_dir = ".avante/rules", -- relative to project root, can also be an absolute path
		global_dir = "~/.config/avante/rules", -- absolute path
	},

	workspace = {
		enabled = true, -- Default: true
		look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" },
		reload_on_dir_changed = true, -- Auto-switch on directory change
		port_range = { min = 40000, max = 41000 }, -- Port range for workspace hubs
		get_port = nil, -- Optional function for custom port assignment
	},

	shortcuts = {
		{
			name = "refactor",
			description = "Refactor code with best practices",
			details = "Automatically refactor code to improve readability, maintainability, and follow best practices while preserving functionality",
			prompt = "Please refactor this code following best practices, improving readability and maintainability while preserving functionality.",
		},
		{
			name = "test",
			description = "Generate unit tests",
			details = "Create comprehensive unit tests covering edge cases, error scenarios, and various input conditions",
			prompt = "Please generate comprehensive unit tests for this code, covering edge cases and error scenarios.",
		},
		{
			name = "fix",
			description = "Identify and fix problems in the code",
			details = "Identify bugs, anti-patterns, runtime risks, and rewrite the code with fixes while explaining the changes.",
			prompt = "Identify problems in the selected code (bugs, anti-patterns, runtime risks). Rewrite with fixes and explain why your version is safer and better.",
		},
		{
			name = "review",
			description = "Perform a professional code review",
			details = "Check for correctness, readability, maintainability, performance, and security issues. Suggest improvements.",
			prompt = "Perform a professional code review. Check for correctness, readability, maintainability, performance, and security issues. Suggest concrete improvements.",
		},
		{
			name = "optimize",
			description = "Optimize code for performance and readability",
			details = "Improve performance, readability, and maintainability of the code. Use idiomatic language constructs.",
			prompt = "Optimize the code for readability, performance, and maintainability. Prefer idiomatic usage of the language. Explain your reasoning.",
		},
		{
			name = "docs",
			description = "Add documentation comments",
			details = "Write documentation comments covering parameters, return values, side effects, and usage.",
			prompt = "Add documentation comments using the language’s standard style. Cover parameters, return values, side effects, and usage.",
		},
		{
			name = "typing",
			description = "Add type annotations to the code",
			details = "Add type annotations or hints following the language's standard typing practices. Explain unclear cases.",
			prompt = "Add type annotations or hints to the code. Follow the language’s standard typing practices. Explain unclear cases.",
		},
	},

	-- system_prompt as function ensures LLM always has latest MCP server state
	-- This is evaluated for every message, even in existing chats
	system_prompt = function()
		local hub = require("mcphub").get_hub_instance()
		return hub and hub:get_active_servers_prompt() or ""
	end,
	-- Using function prevents requiring mcphub before it's loaded
	custom_tools = function()
		return {
			require("mcphub.extensions.avante").mcp_tool(),
		}
	end,
}
