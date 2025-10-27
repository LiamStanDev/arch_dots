-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymaps = {
  -- Clear highlights
  { mode = "n", key = "<Esc>", action = "<CMD>nohlsearch<CR>", desc = "Clear highlights" },

  -- No copy paste and delete
  { mode = { "n", "v", "x" }, key = "x", action = '"_x', desc = "Disable copy when delete" },
  { mode = { "n", "v", "x" }, key = "X", action = '"_X', desc = "Disable copy when delete" },

  { mode = { "n" }, key = "<C-h>", action = "<CMD>TmuxNavigateLeft<cr>", desc = "Navigate left" },
  { mode = { "n" }, key = "<C-l>", action = "<CMD>TmuxNavigateRight<cr>", desc = "Navigate right" },
  { mode = { "n" }, key = "<C-j>", action = "<CMD>TmuxNavigateDown<cr>", desc = "Navigate Down" },
  { mode = { "n" }, key = "<C-k>", action = "<CMD>TmuxNavigateUp<cr>", desc = "NavigateUp" },

  -- Resize with arrows
  { mode = { "n", "v", "t" }, key = "<M-->", action = "<CMD>resize -5<CR>", desc = "Increase Hight" },
  { mode = { "n", "v", "t" }, key = "<M-=>", action = "<CMD>resize +5<CR>", desc = "Decrease Hight" },
  { mode = { "n", "v", "t" }, key = "<M-,>", action = "<CMD>vertical resize -10<CR>", desc = "Increase Width" },
  { mode = { "n", "v", "t" }, key = "<M-.>", action = "<CMD>vertical resize +10<CR>", desc = "Decrease Width" },

  -- Better Scroll
  {
    mode = { "n", "i", "v", "x" },
    key = "<C-d>",
    action = "<C-d>zz",
    desc = "Center cursor after moving down half-page",
  },
  {
    mode = { "n", "i", "v", "x" },
    key = "<C-u>",
    action = "<C-u>zz",
    desc = "Center cursor after moving up half-page",
  },
}

-- Register all key mappings
for _, map in ipairs(keymaps) do
  vim.keymap.set(map.mode, map.key, map.action, vim.tbl_extend("force", { desc = map.desc }, map.opts or {}))
end
