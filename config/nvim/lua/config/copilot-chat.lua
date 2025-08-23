return function()
	local user = vim.env.USER or "User"
	user = user:sub(1, 1):upper() .. user:sub(2)

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "copilot-chat",
		callback = function()
			vim.opt_local.relativenumber = false
			vim.opt_local.number = false
		end,
	})

	-- avoid conflict with copilot.vim plugins
	vim.g.copilot_no_tab_map = true
	vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

	require("CopilotChat").setup({

		model = "gpt-4.1", -- stable
		temperature = 0.1,

		-- see: https://github.com/CopilotC-Nvim/CopilotChat.nvim?tab=readme-ov-file#contexts
		sticky = {
			"#buffer", -- current buffer content
		},

		window = {
			layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
			width = 0.35, -- fractional width of parent, or absolute width in columns when > 1
			height = 0.3, -- fractional height of parent, or absolute height in rows when > 1
			title = "🤖 AI Assistant",
		},

		headers = {
			user = "👤 You: ",
			assistant = "🤖 Copilot: ",
			tool = "🔧 Tool: ",
		},
		separator = "━━",
		show_folds = false, -- Disable folding for cleaner look

		show_help = false,
		auto_insert_mode = false,
		highlight_selection = true,

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-*",
			callback = function()
				vim.opt_local.relativenumber = false
				vim.opt_local.number = false
				vim.opt_local.conceallevel = 0
			end,
		}),

		vim.api.nvim_set_hl(0, "CopilotChatHeader", { fg = "#7C3AED", bold = true }),
		vim.api.nvim_set_hl(0, "CopilotChatSeparator", { fg = "#374151" }),
		vim.api.nvim_set_hl(0, "CopilotChatKeyword", { fg = "#10B981", italic = true }),

		selection = function(source)
			return require("CopilotChat.select").visual(source) or require("CopilotChat.select").line(source)
		end,

		prompts = {
			Explain = {
				prompt = [[Explain the selected code in detail. 
Write it as clear paragraphs for software engineers, 
covering its purpose, how it works, and any key algorithms or logic used.]],
				system_prompt = "COPILOT_EXPLAIN",
			},
			Review = {
				prompt = [[Perform a code review of the selected code. 
Check for correctness, readability, maintainability, performance, 
security concerns, and coding best practices. 
Provide constructive feedback and concrete suggestions.]],
				system_prompt = "COPILOT_REVIEW",
			},
			Fix = {
				prompt = [[The selected code contains problems. 
Identify the issues (bugs, anti-patterns, or potential runtime errors). 
Rewrite the code with fixes and explain: 
1. What was wrong, 
2. How your changes address the problems, 
3. Why the new version is safer or better.]],
			},
			Optimize = {
				prompt = [[Optimize the selected code to improve clarity, 
performance, and maintainability. 
Explain your optimization strategy and the benefits. 
Prefer readability and idiomatic usage of the language.]],
			},
			Docs = {
				prompt = [[Add documentation comments to the selected code. 
Use the language’s standard documentation style (e.g., Javadoc, 
docstrings, XML comments). Cover parameters, return values, 
side effects, and usage notes.]],
			},
			Tests = {
				prompt = [[Generate tests for the selected code. 
Include typical cases, edge cases, and error handling. 
Use the common testing framework for this language.]],
			},
			Commit = {
				prompt = [[Write a commit message for the staged changes 
following the Conventional Commits specification. 
- Keep the title under 50 characters, imperative mood. 
- Wrap the body at 72 characters. 
- Explain the motivation and effect of the change. 
Output as a ```gitcommit``` block.]],
				context = "git:staged",
			},
			Polish = {
				prompt = [[Rewrite the selected English phrase 
to be more clear, professional, and grammatically correct, 
while keeping it concise for programmers.]],
			},
			Refactor = {
				prompt = [[Refactor the selected code to improve structure, 
reduce duplication, and follow clean code principles. 
Preserve functionality but enhance readability and maintainability.]],
			},
			Security = {
				prompt = [[Review the selected code for security issues. 
Look for vulnerabilities such as injection, unsafe data handling, 
buffer overflows, or insecure API usage. Suggest safer alternatives.]],
			},
			Typing = {
				prompt = [[Add type annotations or type hints to the selected code. 
Follow the language's standard type system and explain unclear cases.]],
			},
			Architecture = {
				prompt = [[Suggest architectural improvements for this code snippet. 
Consider design patterns, separation of concerns, 
testability, and long-term maintainability.]],
			},
			Logging = {
				prompt = [[Add logging to the selected code. 
Log key steps, errors, and edge cases using idiomatic logging practices 
of this language/framework. Avoid excessive noise.]],
			},
			ErrorHandling = {
				prompt = [[Improve error handling in the selected code. 
Add meaningful error messages, safe fallbacks, 
and ensure errors propagate correctly.]],
			},
			Style = {
				prompt = [[Rewrite the selected code to conform to the official 
style guide of the language (e.g., PEP8 for Python, 
Google Java Style, Rustfmt). Keep functionality identical.]],
			},
		},
	})

	local picker = require("utils.picker")
	-- copilot chat
	local map = vim.keymap.set
	map({ "n", "i", "v", "t" }, "<A-/>", "<CMD>CopilotChatToggle<CR>", { desc = "Toggle Chat" })
	map({ "n", "v" }, "<leader>aa", "<CMD>CopilotChatToggle<CR>", { desc = "Toggle Chat" }) -- NOTE: dont remap to term mode, it will cause term space key lagging
	map({ "n", "v" }, "<leader>ax", function()
		return require("CopilotChat").reset()
	end, { desc = "Clear" })
	map({ "n", "v" }, "<leader>aq", function()
		vim.ui.input({
			prompt = "Quick Chat: ",
		}, function(input)
			if input ~= "" then
				require("CopilotChat").ask(input)
			end
		end)
	end, { desc = "Quick Chet" })

	map({ "n", "v" }, "<leader>ap", "<CMD>CopilotChatPrompts<CR>", { desc = "Prompt Actions" })
	map({ "n", "v" }, "<leader>as", "<CMD>CopilotChatStop<CR>", { desc = "Stop Current Chat" })
	map({ "n", "v" }, "<leader>aS", function()
		vim.cmd("CopilotChatSave " .. vim.fn.strftime("%Y-%m-%d-%H:%M:%S"))
	end, { desc = "Save Chat" })
	map({ "n", "v" }, "<leader>aL", function()
		picker.load_saved_chat()
	end, { desc = "Load Chat" })

	map({ "n", "v" }, "<leader>am", "<CMD>CopilotChatModels<CR>", { desc = "Choose Models" })

	map({ "n", "v" }, "<leader>ae", "<CMD>Copilot enable<CR>", { desc = "Copilot Enable" })
	map({ "n", "v" }, "<leader>ad", "<CMD>Copilot disable<CR>", { desc = "Copilot Disable" })
end
