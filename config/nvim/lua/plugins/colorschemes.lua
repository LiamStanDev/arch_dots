return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "macchiato", -- latte, frappe, macchiato, mocha
			transparent_background = true,
			float = {
				transparent = true, -- enable transparent floating windows
				solid = false, -- use solid styling for floating windows, see |winborder|
			},

			no_italic = false,
			no_bold = false,
			no_underline = false,

			custom_highlights = {
				-- ref: https://www.reddit.com/r/neovim/comments/11l5p32/how_can_i_change_the_color_of_the_column_that/
				LineNr = { fg = "#9399b2", bg = "NONE", bold = false },
				CursorLineNr = { fg = "#f0f6fc", bg = "NONE", bold = true },
			},

			-- let catppuccin automatically detect installed plugins when you using lazy.nvim
			auto_integrations = true,
		},
	},
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		opts = {
			transparent_mode = true,
		},
	},
}
