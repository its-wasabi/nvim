require("todo-comments").setup({
	signs = false,
	sign_priority = 8,

	keywords = {
		INFO = {
			signs = false,
			color = "info",
			alt = { "READ", "CHECK", "NOTE" },
		},

		WARN = {
			signs = false,
			color = "warn",
			alt = { "TODO", "WARNING", "XXX" }
		},

		ERROR = {
			signs = false,
			color = "error",
			alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "ERR", "FIX" },
		},

		PERF = {
			signs = false,
			color = "hint",
			alt = { "PERFORMANCE" }
		},

		TEST = {
			signs = false,
			color = "ok",
			alt = { "TESTING", "PASSED", "FAILED" },
		},
	},

	gui_style = {
		fg = "BOLD", -- The gui style to use for the fg highlight group.
		bg = "BOLD", -- The gui style to use for the bg highlight group.
	},

	merge_keywords = false, -- when true, custom keywords will be merged with the defaults
	-- highlighting of the line containing the todo comment
	-- * before: highlights before the keyword (typically comment characters)
	-- * keyword: highlights of the keyword
	-- * after: highlights after the keyword (todo text)

	highlight = {
		multiline = true,          -- enable multine todo comments
		multiline_pattern = "^.",  -- lua pattern to match the next multiline from the start of the matched keyword
		multiline_context = 10,    -- extra lines that will be re-evaluated when changing a line
		before = "",               -- "fg" or "bg" or empty
		keyword = "wide_fg",       -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
		after = "fg",              -- "fg" or "bg" or empty
		pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
		comments_only = true,      -- uses treesitter to match keywords in comments only
		max_line_len = 400,        -- ignore lines longer than this
		exclude = {},              -- list of file types to exclude highlighting
	},

	colors = {
		ok    = { "Ok", "#00ff00" },
		info  = { "Info", "#4444ff" },
		hint  = { "Hint", "#cc44aa" },
		warn  = { "Warn", "#ffff00" },
		error = { "Error", "#ff0000" },
	},

	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},
		-- regex that will be used to match keywords.
		-- don't replace the (KEYWORDS) placeholder
		pattern = [[\b(KEYWORDS):]], -- ripgrep regex
	},
});

require("keybinds").todo_comments();
