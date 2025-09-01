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
			Fix = {
				prompt = [[Identify problems in the selected code (bugs, anti-patterns, runtime risks). 
Rewrite with fixes and explain why your version is safer and better.]],
				system_prompt = "You are a bug fixer who always explains the root cause and solution.",
			},
			Review = {
				prompt = [[Perform a professional code review. 
Check for correctness, readability, maintainability, performance, 
and security issues. Suggest concrete improvements.]],
				system_prompt = "You are a strict code reviewer. Be concise but thorough, focusing on engineering best practices.",
			},
			Optimize = {
				prompt = [[Optimize the code for readability, performance, and maintainability. 
Prefer idiomatic usage of the language. Explain your reasoning.]],
				system_prompt = "You are an expert in performance and clean code.",
			},
			Docs = {
				prompt = [[Add documentation comments using the language’s standard style. 
Cover parameters, return values, side effects, and usage.]],
				system_prompt = "You are a technical writer for engineers.",
			},
			Tests = {
				prompt = [[Generate unit tests for the code. 
Cover normal, edge, and error cases. Use common testing framework.]],
				system_prompt = "You are a QA engineer writing tests.",
			},
			Logging = {
				prompt = [[Add meaningful logging. 
Log key steps, errors, and edge cases. Avoid excessive noise.]],
				system_prompt = "You are a backend engineer adding production-ready logging.",
			},
			ErrorHandling = {
				prompt = [[Improve error handling. 
Add safe fallbacks, meaningful messages, and ensure proper propagation.]],
				system_prompt = "You are a reliability engineer focused on robust error handling.",
			},
			Commit = {
				prompt = [[Write a commit message for staged changes 
following Conventional Commits. Keep title <50 chars, imperative. 
Wrap body at 72 chars. Explain motivation + effect. 
Output as ```gitcommit``` block.]],
				context = "git:staged",
				system_prompt = "You are an experienced software engineer writing clear commit messages.",
			},
			Polish = {
				prompt = [[Rewrite the English text to be clear, professional, 
and concise. Keep the technical meaning intact.]],
				system_prompt = "You are an English editor for software documentation.",
			},
			Refactor = {
				prompt = [[Refactor the code to reduce duplication, 
improve structure, and follow clean code principles. 
Preserve behavior, but make it more maintainable.]],
				system_prompt = "You are a clean code expert and refactoring coach.",
			},
			Explain = {
				prompt = [[Explain the selected code clearly and in detail. 
Cover purpose, logic, and key algorithms. 
Use structured paragraphs for engineers.]],
				system_prompt = "You are a senior software engineer explaining code to peers.",
			},
			Security = {
				prompt = [[Review code for security risks: 
injection, unsafe data handling, overflows, insecure API usage. 
Suggest safer alternatives.]],
				system_prompt = "You are a security auditor. Prioritize safety and real-world risks.",
			},
			Typing = {
				prompt = [[Add type annotations or hints to the code. 
Follow the language’s standard typing practices. Explain unclear cases.]],
				system_prompt = "You are a type system specialist.",
			},
			Architecture = {
				prompt = [[Suggest architectural improvements: 
design patterns, separation of concerns, testability, long-term maintainability.]],
				system_prompt = "You are a software architect. Focus on scalability and clarity.",
			},
			Style = {
				prompt = [[Rewrite code to conform to the official style guide 
(e.g., PEP8, Rustfmt, Google Java Style). Preserve functionality.]],
				system_prompt = "You are a style guide enforcer.",
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
