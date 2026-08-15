local mode_match = {
	["INSERT"]      = "I",
	["NORMAL"]      = "N",
	["VISUAL"]      = "V",
	["V-LINE"]      = "Vl",
	["V-BLOCK"]     = "Vb",
	["REPLACE"]     = "R",
	["REPLACE (V)"] = "Rv",
	["SELECT"]      = "S",
	["S-LINE"]      = "Sl",
	["S-BLOCK"]     = "Sb",
	["COMMAND"]     = "C",
	["EX"]          = "X",
	["OP-PENDING"]  = "O",
	["TERMINAL"]    = "T",
}

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",

		component_separators = { left = "", right = "" },
		section_separators = { left = "┃", right = "┃" },
		disable_filetypes = {
			statusline = {
				"alpha",
				"dashboard",
				"ministarter",
				"snacks_dashboard",
				"NvimTree",
			},
			winbar = {}
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, --  60
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			}
		}
	},

	sections = {
		lualine_a = {
			{
				"mode",
				draw_empty = true,
				icons_enabled = false,
				padding = 1,
				fmt = function(str) return mode_match[str] or string.sub(str, 1, 1); end,
				on_click = function(_, _, _)
					print("Hiiii :3");
				end,
			},
		},

		lualine_b = {
			{
				"searchcount",
				maxcount = 999,
				timeout = 1,
			},

			{
				"filename",
				path = 3,
				newfile_status = true,
				file_status = true,


				symbols = {
					modified = "%#LualineFilenameSym# %#lualine_b_normal#",
					readonly = "%#LualineFilenameSym# %#lualine_b_normal#",
				},

				fmt = function(str)
					local special_fg = vim.api.nvim_get_hl(0, { name = "Special", link = false }).fg
					local bg = vim.api.nvim_get_hl(0, { name = "lualine_b_normal", link = false }).bg
					vim.api.nvim_set_hl(0, "LualineFilenameSym", { fg = special_fg, bg = bg })
					return str
				end,
			},
		},

		lualine_c = {
			{
				"lsp_status",
				icon = '',
				symbols = {
					spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
					done = '',
					separator = ',',
				},
				ignore_lsp = { "null-ls" },
				show_name = true,
				fmt = function(str)
					local max_len = 10
					local result = {}

					for i, name in ipairs(vim.split(str, ',', { plain = true })) do
						if #name > max_len then
							name = name:sub(1, max_len - 1) .. "⏵"
						end

						result[i] = name
					end

					return table.concat(result, ",")
				end

			},
			{
				"diagnostics",
				update_in_insert = false,
				colored = true,
				always_visible = false,
				symbols = {
					info = 'I-',
					hint = 'H-',
					warn = 'W-',
					error = 'E-',
				},
			},
		},

		lualine_x = {
			{
				"diff",
				colored = true,
				symbols = {
					added = "+",
					modified = "~",
					removed = "-",
					source = false,
				},
			},
			{
				"branch",
				icon = "",
				fmt = function(str)
					local max_len = 20;
					if #str > max_len then
						str = ("%s⏵"):format(str:sub(1, max_len - 1))
					end

					return str;
				end
			},
		},
		lualine_y = {
			{
				"encoding",
				show_bomb = false,
			},
			function()
				local d = vim.diagnostic.is_enabled({ bufnr = 0 });
				local h = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 });
				local l = vim.lsp.codelens.is_enabled({ bufnr = 0 });

				local bg = vim.api.nvim_get_hl(0, { name = "lualine_b_normal", link = false }).bg;

				local d_fg = vim.api.nvim_get_hl(0, { name = d and "True" or "False", link = false }).fg;
				local h_fg = vim.api.nvim_get_hl(0, { name = h and "True" or "False", link = false }).fg;
				local l_fg = vim.api.nvim_get_hl(0, { name = l and "True" or "False", link = false }).fg;

				vim.api.nvim_set_hl(0, "StatusD", { fg = d_fg, bg = bg });
				vim.api.nvim_set_hl(0, "StatusH", { fg = h_fg, bg = bg });
				vim.api.nvim_set_hl(0, "StatusL", { fg = l_fg, bg = bg });

				return "[%#StatusD#D%#lualine_b_normal#|%#StatusH#H%#lualine_b_normal#|%#StatusL#L%#lualine_b_normal#]"
			end,
		},
		lualine_z = {
			{
				"progress",
				padding = { left = 1, right = 1 },
			},
		},
	},

	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
});
