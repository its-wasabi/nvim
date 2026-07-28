-- TODO: Read usage for gitsigns
require("gitsigns").setup({
	signs                        = {
		add          = { text = "" },
		change       = { text = "" },
		delete       = { text = "" },
		topdelete    = { text = "" },
		changedelete = { text = "" },
		untracked    = { text = "" },
	},
	signs_staged_enable          = true, -- FIX: make it work (for some reason plugin ignores completely hi groups for staged signs)
	signs_staged                 = {
		add          = { text = "" },
		change       = { text = "" },
		delete       = { text = "" },
		topdelete    = { text = "" },
		changedelete = { text = "" },
		untracked    = { text = "" },
	},
	numhl                        = true, -- Needed for LineNr bg highlight
	linehl                       = false,
	signcolumn                   = true,
	word_diff                    = false,
	watch_gitdir                 = { follow_files = true },
	auto_attach                  = true,
	attach_to_untracked          = true,
	current_line_blame           = true,
	current_line_blame_opts      = {
		virt_text = true,
		virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
		delay = 400,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
	current_line_blame_formatter = "  󰊢 <author>, <author_time:%R> - <summary>",
	sign_priority                = 6,
	update_debounce              = 400,
	status_formatter             = nil, -- Use default
	max_file_length              = 40000, -- Disable if file is longer than this (in lines)
	preview_config               = {
		-- Options passed to nvim_open_win
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1
	},
});
