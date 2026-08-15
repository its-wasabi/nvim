local md_wrap = vim.api.nvim_create_augroup("MarkdownAutoWrap", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = md_wrap,
	pattern = "markdown",
	callback = function()
		vim.opt_local.textwidth = 100
		vim.opt_local.wrap      = true
		vim.opt_local.linebreak = true
		vim.opt_local.formatoptions:append("t")
	end,
});

require("render-markdown").setup({
	enabled = true,
	render_modes = { "n", "c", "t", "i" },
	max_file_size = 10.0,
	debounce = 100,
	preset = "obsidian",
	log_level = "error",
	log_runtime = false,
	file_types = { "markdown", "vimwiki" },
	change_events = {},
	patterns = {},
	on = {},
	padding = { highlight = "Normal" },
	completions = {
		blink = { enabled = true },
		lsp = { enabled = true },
	},

	latex = {
		enabled = true,
		render_modes = true,
		converter = "utftex",
		position = "below",
		top_pad = 0,
		bottom_pad = 0,
	},

	heading = {
		enabled = true,
		render_modes = true,
		atx = true,
		setext = true,
		sign = false,
		icons = {
			"# ",
			"2# ",
			"3# ",
			"4# ",
			"5# ",
			"6# "
		},
		position = "overlay",
		width = "full",
		left_margin = 0,
		left_pad = { 1, 4, 7, 10, 13, 16 },
		right_pad = 0,
		min_width = 0,
		border = false,
		border_virtual = true,
		border_prefix = false,
		above = "▄",
		below = "▀",
		custom = {},
	},

	paragraph = {
		enabled = false,
		render_modes = true,
		left_margin = 0,
		indent = vim.opt.tabstop:get(),
		min_width = 0,
	},

	code = {
		enabled = true,
		render_modes = true,
		sign = false,
		style = "full",
		position = "left",
		language_pad = 0,
		language_icon = true,
		language_name = true,
		disable_background = { "diff" },
		width = "full",
		left_margin = 0,
		left_pad = 0,
		right_pad = 0,
		min_width = 0,
		inline_pad = 0,
		highlight_language = nil,
	},

	dash = {
		enabled = true,
		render_modes = true,
		icon = "─",
		width = "full",
		left_margin = 0,
	},

	bullet = {
		enabled = true,
		render_modes = true,
		icons = { "▶ ", "▷", "▶▶ ", "▷▷ " },
		ordered_icons = function(ctx)
			local value = vim.trim(ctx.value)
			local index = tonumber(value:sub(1, #value - 1))
			return ("%d."):format(index > 1 and index or ctx.index)
		end,
		left_pad = 0,
		right_pad = 0,
		scope_highlight = {},
	},

	checkbox = {
		enabled = true,
		render_modes = true,
		bullet = true,
		right_pad = 1,
		unchecked = {
			scope_highlight = nil,
		},
		checked = {
			scope_highlight = nil,
		},

		custom = {
			todo = { raw = '[-]', rendered = '󰿦 ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
		},
	},

	quote = {
		enabled = true,
		render_modes = true,
		icon = "▋",
		repeat_linebreak = false,
	},

	pipe_table = {
		enabled = true,
		render_modes = true,
		preset = "none",
		style = "full",
		cell = "padded",
		padding = 1,
		min_width = 0,
		border = {
			"┌", "┬", "┐",
			"├", "┼", "┤",
			"└", "┴", "┘",
			"│", "─",
		},
		border_virtual = true,
		alignment_indicator = "━",
	},




	-- TODO: Change the icons and colors
	callout = {
		note      = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo', category = 'github' },
		tip       = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess', category = 'github' },
		important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint', category = 'github' },
		warning   = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn', category = 'github' },
		caution   = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError', category = 'github' },
		abstract  = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo", category = "obsidian" },
		summary   = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo", category = "obsidian" },
		tldr      = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo", category = "obsidian" },
		info      = { raw = "[!INFO]", rendered = "󰬐 Info", highlight = "RenderMarkdownInfo", category = "obsidian" },
		todo      = { raw = "[!TODO]", rendered = " Todo", highlight = "RenderMarkdownInfo", category = "obsidian" },
		hint      = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess", category = "obsidian" },
		success   = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess", category = "obsidian" },
		check     = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess", category = "obsidian" },
		done      = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess", category = "obsidian" },
		question  = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn", category = "obsidian" },
		help      = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn", category = "obsidian" },
		faq       = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn", category = "obsidian" },
		attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn", category = "obsidian" },
		failure   = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError", category = "obsidian" },
		fail      = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError", category = "obsidian" },
		missing   = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError", category = "obsidian" },
		danger    = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError", category = "obsidian" },
		error     = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError", category = "obsidian" },
		bug       = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError", category = "obsidian" },
		example   = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint", category = "obsidian" },
		quote     = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote", category = "obsidian" },
		cite      = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote", category = "obsidian" },
	},

	link = {
		enabled = true,
		render_modes = true,
		footnote = {
			enabled = true,
			superscript = true,
			prefix = "",
			suffix = "",
		},

		image = "󰥶 ",
		image_custom = true,
		email = "󰀓 ",
		hyperlink = "󰌹 ",
		wiki = {
			enabled = true,
			icon = "󱗖 ",
			conceal_destination = true,
		},

		custom = {
			web = { pattern = "^http", icon = "󰾔 " },
			discord = { pattern = "discord%.com", icon = "󰙯 " },
			github = { pattern = "github%.com", icon = " " },
			gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
			google = { pattern = "google%.com", icon = " " },
			neovim = { pattern = "neovim%.io", icon = " " },
			reddit = { pattern = "reddit%.com", icon = " " },
			stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
			wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
			youtube = { pattern = "youtube%.com", icon = " " },
			facebook = { pattern = "facebook%.com", icon = " " },
			twitter = { pattern = "twitter%.com", icon = " " },
			x = { pattern = "x%.com", icon = " " },
			linkedin = { pattern = "linkedin%.com", icon = " " },
			steam = { pattern = "steam%.com", icon = " " },
		},
	},
});
