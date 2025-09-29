vim.lsp.config("rust_analyzer", {
	settings = {
		-- ref: https://rust-analyzer.github.io/book/configuration.html
		["rust-analyzer"] = {
			check = {
				enabled = true,
				command = "clippy", -- Use Clippy for linting.
				features = "all",
				-- extraArgs = { "--no-deps" }, -- Only check/analyze your project's own code
			},
			checkOnSave = true,
			cargo = {
				allTargets = false, -- Do not check all targets by default.
				features = "all", -- Enable all features.
				buildScripts = {
					enable = true, -- Enable build script support.
				},
			},
			procMacro = {
				enable = true, -- Enable procedural macros.
				ignored = {
					["async-trait"] = { "async_trait" },
					["napi-derive"] = { "napi" },
					["async-recursion"] = { "async_recursion" },
				},
				attributes = {
					enable = { "*" },
				},
			},
			imports = {
				granularity = {
					group = "module", -- Group imports by module.
				},
				prefix = "self", -- Use `self` as the import prefix.
			},
			files = {
				excludeDirs = {
					".direnv",
					".git",
					".github",
					".gitlab",
					"bin",
					"node_modules",
					"target",
					"venv",
					".venv",
				},
			},
		},
	},
})

vim.lsp.config("pyright", {
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				typeCheckingMode = "strict",
				diagnosticMode = "workspace",
				inlayHints = {
					variableTypes = true,
					functionReturnTypes = true,
				},
				autoImportCompletions = true,
				useLibraryCodeForTypes = true,
				diagnosticSeverityOverrides = {
					reportOptionalMemberAccess = false,
				},
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim", "MiniFiles", "Snacks" },
			},
			completion = {
				callSnippet = "Replace",
			},
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				-- Let lsp knows nvim runtime so it can provide completion
				library = { vim.env.VIMRUNTIME },
				checkThirdParty = false,
			},
			hint = { enable = true },
		},
	},
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index", -- make background index for quick jump into definition
		"--clang-tidy", -- linter
		"--cross-file-rename",
		"--completion-style=detailed", -- more info when completion popup
		"--header-insertion=iwyu", -- header only insert `include whay you use`
		"--header-insertion-decorators", -- show header insert in completion
		"--function-arg-placeholders",
		"--fallback-style=Google",
		"--offset-encoding=utf-16",
	},
	init_options = {
		fallbackFlags = { "--std=c++2b" },
	},
	offsetEncoding = { "utf-8", "utf-16" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		".git",
	},
	filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda" },
})
