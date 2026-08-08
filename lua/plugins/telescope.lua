local telescope = require("telescope")
telescope.setup({
	path_display = { "smart" },
	defaults = {
		border = true,
		color_devicons = true,
		borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
		prompt_prefix = " ",
		layout_strategy = "flex",
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
			width = 0.85,
			height = 0.92,
			preview_cutoff = 120,
		},
		file_ignore_patterns = {
			"^%.git/",
			"^%.git$",
			"node_modules",
			".cache",
			"build",
			"target",
		},
		vimgrep_arguments = {
			"rg",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
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
