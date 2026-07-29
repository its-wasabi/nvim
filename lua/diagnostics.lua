vim.opt.updatetime = 50

vim.diagnostic.config({
	signs = false,
	severity_sort = true,

	virtual_text = {
		severity = { max = vim.diagnostic.severity.WARN },
		source = "if_many",
		spacing = 4,
		prefix = "",
		suffix = "",
	},

	virtual_lines = {
		severity = { min = vim.diagnostic.severity.ERROR },
	},

	underline = true,

	update_in_insert = false,

	float = {
		focusable = true,
		style = "minimal",
		border = "solid",
		source = true,
		header = "",
		prefix = "",
		suffix = "",
		close_events = {
			"CursorMoved",
			"TextChanged",
			"BufHidden",
			"LspDetach",
		}
	},
});
