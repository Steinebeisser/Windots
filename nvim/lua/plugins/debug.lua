return {
	"https://github.com/mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		dap.adapters.cppdbg = {
			id = "cppdbg",
			type = "executable",
			command = "OpenDebugAD7.exe",
			options = {
				detached = false,
			},
		}
	end,
}

-- 	config = function()
-- 		local dap, dapui = require("dap"), require("dapui")
--
-- 		dap.adapters.codelldb = {
-- 			type = "executable",
-- 			command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
--
-- 			-- On windows you may have to uncomment this:
-- 			detached = false,
-- 		}
--
-- 		dap.configurations.cpp = {
-- 			{
-- 				name = "Launch file",
-- 				type = "codelldb",
-- 				request = "launch",
-- 				program = function()
-- 					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
-- 				end,
-- 				cwd = "${workspaceFolder}",
-- 				stopOnEntry = false,
--
-- 				runInTerminal = false,
-- 				externalConsole = true,
-- 			},
-- 		}
--
-- 		dap.configurations.c = dap.configurations.cpp
-- 		dap.configurations.rust = dap.configurations.cpp
--
-- 		-- dap.listeners.before.attach.dapui_config = function()
-- 		-- 	dapui.open()
-- 		-- end
-- 		-- dap.listeners.before.launch.dapui_config = function()
-- 		-- 	dapui.open()
-- 		-- end
-- 		-- dap.listeners.before.event_terminated.dapui_config = function()
-- 		-- 	dapui.close()
-- 		-- end
-- 		-- dap.listeners.before.event_exited.dapui_config = function()
-- 		-- 	dapui.close()
-- 		-- end
-- 		-- 	vim.keymap.set("n", "<Leader>br", dap.toggle_breakpoint, {})
-- 		-- 	vim.keymap.set("n", "<Leader>bc", dap.continue, {})
-- 	end,
-- }
