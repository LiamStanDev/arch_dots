return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			local flavour = "macchiato"
			local palette = require("catppuccin.palettes").get_palette(flavour)
			require("catppuccin").setup({
				flavour = flavour, -- latte, frappe, macchiato, mocha
				transparent_background = true,
				float = {
					transparent = true, -- enable transparent floating windows
					solid = false, -- use solid styling for floating windows, see |winborder|
				},

				no_italic = true,
				no_bold = false,
				no_underline = false,

				custom_highlights = {
					-- ref: https://www.reddit.com/r/neovim/comments/11l5p32/how_can_i_change_the_color_of_the_column_that/
					LineNr = { fg = "#9399b2", bg = "NONE", bold = false },
					CursorLineNr = { fg = "#f0f6fc", bg = "NONE", bold = true },

					-- avate.nvim
					AvanteTitle = { bg = palette.lavender, fg = palette.base },
					AvanteReversedTitle = { bg = palette.none, fg = palette.lavender },
					AvanteSubtitle = { bg = palette.peach, fg = palette.base },
					AvanteReversedSubtitle = { bg = palette.none, fg = palette.peach },
					AvanteThirdTitle = { bg = palette.blue, fg = palette.base },
					AvanteReversedThirdTitle = { bg = palette.none, fg = palette.blue },
					AvanteInlineHint = { fg = palette.overlay0 },
					AvantePopupHint = { fg = palette.overlay0 },
					AvanteAnnotation = { fg = palette.overlay0 },
					AvanteSuggestion = { fg = palette.overlay0 },
					AvanteConflictCurrent = {
						bg = palette.mantle,
						fg = palette.green,
					},
					AvanteConflictCurrentLabel = {
						bg = palette.mantle,
						fg = palette.green,
					},
					AvanteConflictIncoming = {
						bg = palette.mantle,
						fg = palette.blue,
					},
					AvanteConflictIncomingLabel = {
						bg = palette.mantle,
						fg = palette.blue,
					},
					AvanteConflictAncestor = {
						bg = palette.mantle,
						fg = palette.teal,
					},
					AvanteConflictAncestorLabel = {
						bg = palette.mantle,
						fg = palette.teal,
					},
					AvanteToBeDeleted = {
						bg = palette.mantle,
						fg = palette.red,
					},
					AvanteSidebarWinSeparator = {
						link = "WinSeparator",
					},
					AvantePromptInput = {
						link = "FloatNormal",
					},
					AvantePromptInputBorder = {
						link = "FloatBorder",
					},
				},

				-- let catppuccin automatically detect installed plugins when you using lazy.nvim
				auto_integrations = true,
			})
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			transparent_mode = true,
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
}
