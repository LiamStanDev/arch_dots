# Neovim Configuration Agent Guidelines

## Build/Lint/Test Commands
- **Format**: `stylua .` (uses stylua.toml: 2 spaces, 120 columns)
- **No tests**: This is LazyVim configuration, no test framework present
- **Check config**: Launch nvim to validate configuration loads properly

## Code Style
- **Language**: Lua only
- **Formatting**: 2 spaces indentation, 120 column width (stylua.toml)
- **Imports**: Use `require()` for modules, follow LazyVim plugin patterns
- **Comments**: Use `--` for single line, descriptive comments for configuration blocks
- **Naming**: snake_case for variables/functions, kebab-case for files
- **Structure**: Follow LazyVim conventions - config/ for core setup, plugins/ for plugin configs
- **Tables**: Use trailing commas, align values consistently
- **Strings**: Double quotes preferred for consistency
- **Functions**: Prefer function expressions `function()` over declarations
- **Plugin configs**: Return table from plugin files, use opts for configuration
- **Error handling**: LazyVim handles most errors, focus on proper configuration structure
- **Type annotations**: Use `---@type` comments for complex configurations
- **Icons**: Use Unicode symbols consistently (see core.lua icons table)
- **Keymaps**: Define in keymaps.lua or plugin-specific files, include descriptions
- **Options**: Use `vim.opt` for options, `vim.g` for globals