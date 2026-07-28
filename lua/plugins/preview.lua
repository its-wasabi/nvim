local rndr = require("rndr")

rndr.setup({
	preview = {
		auto_open = true,
		events = { "BufReadPost" },
		render_on_resize = true,
	},
	window = {
		termguicolors = true,
		size = {
			width_offset = 0,
			height_offset = 0,
			min_width = 1,
			min_height = 1,
		},

		options = {
			number = false,
			relativenumber = false,
			wrap = false,
			signcolumn = "no",
		},
	}
});

require("telescope").setup({
	defaults = {
		buffer_previewer_maker = rndr.telescope_buffer_previewer_maker,
	}

})
