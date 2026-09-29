local telescope = require("telescope")
telescope.setup({
	path_display = { "smart" },

	defaults = {
		border = true,
		color_devicons = true,
		borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
		prompt_prefix = " ",
		layout_strategy = "flex",

		results_title = false,
		preview_title = false,

		layout_config = {
			flex = { flip_columns = 100 },
			horizontal = {
				mirror = false,
				prompt_position = "bottom",
				preview_width = 0.55,
			},
			vertical = {
				mirror = false,
			},

			width = function(_, max_columns)
				return max_columns
			end,
			height = function(_, _, max_lines)
				return max_lines
			end,

			preview_cutoff = 120,
		},

		vimgrep_arguments = {
			"rg",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},

		file_ignore_patterns = {
			"^%.git/",
			"^%.git$",
			".cache",
			".lock",
			"node_modules",
			"build",
			"target",
		},
	},

	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	}
});

telescope.load_extension("fzf");

require("keybinds").telescope(require("telescope.builtin"))
