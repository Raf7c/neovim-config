return {
	{
		"nvimdev/dashboard-nvim",
		lazy = false, -- dashboard-nvim should not be lazily loaded to properly handle stdin
		opts = function()
			-- Load and select a random logo
			local logos = require("extra.logo")
			local keys = vim.tbl_keys(logos)
			local logo = logos[keys[math.random(#keys)]]
			logo = string.rep("\n", 8) .. logo .. "\n\n"

			local config = {
				header = vim.split(logo, "\n"),
				-- stylua: ignore
				center = {
					{ action = 'Telescope find_files', desc = " Find File", icon = " ", key = "f" },
					{ action = 'SessionLoad', desc = " Restore Session", icon = " ", key = "s" },
					{ action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "z" },
					{ action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit", icon = " ", key = "q" },
				},
				footer = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
				end,
			}

			-- Adjust button alignment
			for _, button in ipairs(config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			-- Show dashboard after closing lazy
			if vim.o.filetype == "lazy" then
				vim.api.nvim_create_autocmd("WinClosed", {
					pattern = tostring(vim.api.nvim_get_current_win()),
					once = true,
					callback = function()
						vim.schedule(function()
							vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
						end)
					end,
				})
			end

			return {
				theme = "doom",
				hide = { statusline = false },
				config = config,
			}
		end,
	},
}
