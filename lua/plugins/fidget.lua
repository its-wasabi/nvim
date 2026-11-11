require("fidget").setup({
	progress = {
		suppress_on_insert = true,
		display = {
			done_ttl = 1,
			done_icon = "OK",
			progress_icon = { "dots" },
		},
	},
	notification = {
		override_vim_notify = true,
		window = {
			normal_hl = "Comment",
			winblend = 0,
			border = "none",
			x_padding = 1,
			y_padding = 1,
		},
	},
})
