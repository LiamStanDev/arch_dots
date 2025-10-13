local dap = require("dap")
local utils = require("utils.dap")

-- rust/c/c++: codelldb configs
-- 1.7.0
-- dap.adapters.codelldb = {
-- 	type = "server",
-- 	port = "${port}",
-- 	executable = {
-- 		command = utils.get_mason_adaptor_path() .. "codelldb",
-- 		args = { "--port", "${port}" },
-- 	},
-- }

dap.adapters.codelldb = {
	type = "executable",
	command = utils.get_mason_adaptor_path() .. "codelldb",
}
