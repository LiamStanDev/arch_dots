local util = require("utils.lsp")
return {
	cmd = {
		vim.fn.executable("OmniSharp") == 1 and "OmniSharp" or "omnisharp",
		"-z", -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
		"--hostPID",
		tostring(vim.fn.getpid()),
		"DotNet:enablePackageRestore=true",
		"--encoding",
		"utf-8",
		"--languageserver",
	},
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(
			util.root_pattern("*.sln")(fname)
				or util.root_pattern("*.csproj")(fname)
				or util.root_pattern("omnisharp.json")(fname)
				or util.root_pattern("function.json")(fname)
		)
	end,
	filetypes = { "cs", "vb" },
	settings = {
		RoslynExtensionsOptions = {
			-- Enables support for roslyn analyzers, code fixes and rulesets.
			EnableAnalyzersSupport = nil,
			-- Enables support for showing unimported types and unimported extension
			-- methods in completion lists. When committed, the appropriate using
			-- directive will be added at the top of the current file. This option can
			-- have a negative impact on initial completion responsiveness,
			-- particularly for the first few completion sessions after opening a
			-- solution.
			EnableImportCompletion = true,
			-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
			-- true
			AnalyzeOpenDocumentsOnly = nil,
			-- Enables the possibility to see the code in external nuget dependencies
			EnableDecompilationSupport = true,
		},
	},
}
