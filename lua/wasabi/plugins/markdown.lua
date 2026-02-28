local md_wrap = vim.api.nvim_create_augroup("MarkdownAutoWrap", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = md_wrap,
	pattern = "markdown",
	callback = function()
		vim.opt_local.textwidth = 100
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.formatoptions:append("t")
	end,
})

require("render-markdown").setup({
	enabled = true,
	-- Vim modes that will show a rendered view of the markdown file, :h mode(), for all enabled
	-- components. Individual components can be enabled for other modes. Remaining modes will be
	-- unaffected by this plugin.
	render_modes = { 'n', 'c', 't' },
	-- Maximum file size (in MB) that this plugin will attempt to render.
	-- Any file larger than this will effectively be ignored.
	max_file_size = 10.0,
	-- Milliseconds that must pass before updating marks, updates occur.
	-- within the context of the visible window, not the entire buffer.
	debounce = 100, -- TODO: consider making smaller
	-- | obsidian | mimic Obsidian UI                                          |
	-- | lazy     | will attempt to stay up to date with LazyVim configuration |
	-- | none     | does nothing                                               |
	preset = 'obsidian',
	-- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'.
	-- Only intended to be used for plugin development / debugging.
	log_level = 'error',
	-- Print runtime of main update method.
	-- Only intended to be used for plugin development / debugging.
	log_runtime = false,
	-- Filetypes this plugin will run on.
	file_types = { 'markdown', "vimwiki" },
	-- Takes buffer as input, if it returns true this plugin will not attach to the buffer
	-- ignore = function()
	-- 	return false
	-- end,
	-- Additional events that will trigger this plugin's render loop.
	change_events = {},
	-- TODO: check what is that
	-- injections = {
	-- 	-- Out of the box language injections for known filetypes that allow markdown to be interpreted
	-- 	-- in specified locations, see :h treesitter-language-injections.
	-- 	-- Set enabled to false in order to disable.
	--
	-- 	gitcommit = {
	-- 		enabled = true,
	-- 		query = [[
	--               ((message) @injection.content
	--                   (#set! injection.combined)
	--                   (#set! injection.include-children)
	--                   (#set! injection.language "markdown"))
	--           ]],
	-- 	},
	-- },
	patterns = {
		-- -- Highlight patterns to disable for filetypes, i.e. lines concealed around code blocks
		--
		-- markdown = {
		-- 	disable = true,
		-- 	directives = {
		-- 		{ id = 17, name = 'conceal_lines' },
		-- 		{ id = 18, name = 'conceal_lines' },
		-- 	},
		-- },
	},
	anti_conceal = {
		-- TODO: check what is that
		-- -- This enables hiding any added text on the line the cursor is on.
		-- enabled = true,
		-- -- Modes to disable anti conceal feature.
		-- disabled_modes = false,
		-- -- Number of lines above cursor to show.
		-- above = 0,
		-- -- Number of lines below cursor to show.
		-- below = 0,
		-- -- Which elements to always show, ignoring anti conceal behavior. Values can either be
		-- -- booleans to fix the behavior or string lists representing modes where anti conceal
		-- -- behavior will be ignored. Valid values are:
		-- --   head_icon, head_background, head_border, code_language, code_background, code_border,
		-- --   dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
		-- ignore = {
		-- 	code_background = true,
		-- 	sign = true,
		-- },
	},
	padding = {
		-- Highlight to use when adding whitespace, should match background.
		highlight = 'Normal',
	},
	latex = {
		-- Turn on / off latex rendering.
		enabled = true,
		-- Additional modes to render latex.
		render_modes = true,
		-- Executable used to convert latex formula to rendered unicode.
		converter = "ssmtuc",
		-- Highlight for latex blocks.
		highlight = 'RenderMarkdownMath',
		-- Determines where latex formula is rendered relative to block.
		-- | above | above latex block |
		-- | below | below latex block |
		position = 'below',
		-- Number of empty lines above latex blocks.
		top_pad = 0,
		-- Number of empty lines below latex blocks.
		bottom_pad = 0,
	},
	on = {
		-- -- Called when plugin initially attaches to a buffer.
		-- attach = function() end,
		-- -- Called before adding marks to the buffer for the first time.
		-- initial = function() end,
		-- -- Called after plugin renders a buffer.
		-- render = function() end,
		-- -- Called after plugin clears a buffer.
		-- clear = function() end,
	},
	completions = {
		-- Settings for blink.cmp completions source
		blink = { enabled = true },
		-- Settings for in-process language server completions
		lsp = { enabled = true },
	},

	heading = {
		enabled = true,
		render_modes = true, -- render while in insert mode
		atx = true,
		setext = true,
		sign = false,
		-- signs = { "󰫍 " },
		icons = { "1# ", "2# ", "3# ", "4# ", "5# ", "6# " },
		-- | right   | '#'s are concealed and icon is appended to right side                          |
		-- | inline  | '#'s are concealed and icon is inlined on left side                            |
		-- | overlay | icon is left padded with spaces and inserted on left hiding any additional '#' |
		position = "overlay",
		width = "full",
		left_margin = 0,
		left_pad = { 1, 2, 3, 8, 12, 16 },
		right_pad = 0,
		min_width = 0,
		border = false,
		border_virtual = true,
		border_prefix = false,
		above = '▄',
		below = '▀',
		backgrounds = {
			'RenderMarkdownH1Bg',
			'RenderMarkdownH2Bg',
			'RenderMarkdownH3Bg',
			'RenderMarkdownH4Bg',
			'RenderMarkdownH5Bg',
			'RenderMarkdownH6Bg',
		},
		foregrounds = {
			'RenderMarkdownH1',
			'RenderMarkdownH2',
			'RenderMarkdownH3',
			'RenderMarkdownH4',
			'RenderMarkdownH5',
			'RenderMarkdownH6',
		},
		custom = {},
	},
	paragraph = {
		enabled = false,
		render_modes = true,
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		-- Output is evaluated depending on the type.
		-- | function | `value(context)` |
		-- | number   | `value`          |
		left_margin = 0,
		-- Output is evaluated using the same logic as 'left_margin'.
		indent = vim.opt.tabstop:get(), -- TODO: consider changing this to smaller value or Turing paragraph off
		min_width = 0,
	},
	code = {
		enabled = true,
		render_modes = true,
		sign = false,
		-- Determines how code blocks & inline code are rendered.
		-- | none     | disables all rendering                                                    |
		-- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
		-- | language | language icon to sign column if enabled and icon + name above code blocks |
		-- | full     | normal + language                                                         |
		style = "full",
		position = "left",
		language_pad = 1,
		language_icon = true,
		language_name = true,
		-- A list of language names for which background highlighting will be disabled.
		-- Likely because that language has background highlights itself.
		-- Use a boolean to make behavior apply to all languages.
		-- Borders above & below blocks will continue to be rendered.
		disable_background = { "diff" },
		width = "full",
		left_margin = 0,
		left_pad = 1,
		right_pad = 0,
		min_width = 0,
		-- TODO: configure better border
		-- Determines how the top / bottom of code block are rendered.
		-- | none  | do not render a border                               |
		-- | thick | use the same highlight as the code body              |
		-- | thin  | when lines are empty overlay the above & below icons |
		-- | hide  | conceal lines unless language name or icon is added  |
		border = "hide",
		above = '▄',
		below = '▀',
		inline_left = '',
		inline_right = '',
		-- TODO: figure out that inline_pad
		-- Padding to add to the left & right of inline code.
		inline_pad = 0,
		highlight = 'RenderMarkdownCode',
		highlight_language = nil,
		highlight_border = 'RenderMarkdownCodeBorder',
		highlight_fallback = 'RenderMarkdownCodeFallback',
		highlight_inline = 'RenderMarkdownCodeInline',
	},
	dash = { -- TODO: configure dash and figure out what it is
		enabled = true,
		render_modes = true,
		-- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'.
		-- The icon gets repeated across the window's width.
		icon = '─',
		-- Width of the generated line.
		-- | <number> | a hard coded width value |
		-- | full     | full width of the window |
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		width = 'full',
		-- Amount of margin to add to the left of dash.
		-- If a float < 1 is provided it is treated as a percentage of available window space.
		left_margin = 0,
		-- Highlight for the whole line generated from the icon.
		highlight = 'RenderMarkdownDash',
	},
	bullet = {
		-- Useful context to have when evaluating values.
		-- | level | how deeply nested the list is, 1-indexed          |
		-- | index | how far down the item is at that level, 1-indexed |
		-- | value | text value of the marker node                     |

		enabled = true,
		render_modes = true,
		-- Replaces '-'|'+'|'*' of 'list_item'.
		-- If the item is a 'checkbox' a conceal is used to hide the bullet instead.
		-- Output is evaluated depending on the type.
		-- | function   | `value(context)`                                    |
		-- | string     | `value`                                             |
		-- | string[]   | `cycle(value, context.level)`                       |
		-- | string[][] | `clamp(cycle(value, context.level), context.index)` |
		icons = { "▶ ", "▷", "▶▶ ", "▷▷ " },
		-- Replaces 'n.'|'n)' of 'list_item'.
		-- Output is evaluated using the same logic as 'icons'.
		ordered_icons = function(ctx) -- TODO: check what this code does
			local value = vim.trim(ctx.value)
			local index = tonumber(value:sub(1, #value - 1))
			return ('%d.'):format(index > 1 and index or ctx.index)
		end,
		-- Padding to add to the left of bullet point.
		-- Output is evaluated depending on the type.
		-- | function | `value(context)` |
		-- | integer  | `value`          |
		left_pad = 0,
		-- Padding to add to the right of bullet point.
		-- Output is evaluated using the same logic as 'left_pad'.
		right_pad = 0,
		-- Highlight for the bullet icon.
		-- Output is evaluated using the same logic as 'icons'.
		highlight = 'RenderMarkdownBullet',
		-- Highlight for item associated with the bullet point.
		-- Output is evaluated using the same logic as 'icons'.
		scope_highlight = {},
	},
	checkbox = {
		-- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'.
		-- There are two special states for unchecked & checked defined in the markdown grammar.

		enabled = true,
		render_modes = true,
		-- Render the bullet point before the checkbox.
		bullet = true,
		-- Padding to add to the right of checkboxes.
		right_pad = 1,
		unchecked = {
			-- Replaces '[ ]' of 'task_list_marker_unchecked'.
			-- icon = "󰈜 ",
			-- Highlight for the unchecked icon.
			highlight = 'RenderMarkdownUnchecked',
			-- Highlight for item associated with unchecked checkbox.
			scope_highlight = nil,
		},
		checked = {
			-- Replaces '[x]' of 'task_list_marker_checked'.
			-- icon = " ",
			-- Highlight for the checked icon.
			highlight = 'RenderMarkdownChecked',
			-- Highlight for item associated with checked checkbox.
			scope_highlight = nil,
		},
		-- Define custom checkbox states, more involved, not part of the markdown grammar.
		-- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks.
		-- The key is for healthcheck and to allow users to change its values, value type below.
		-- | raw             | matched against the raw text of a 'shortcut_link'           |
		-- | rendered        | replaces the 'raw' value when rendering                     |
		-- | highlight       | highlight for the 'rendered' icon                           |
		-- | scope_highlight | optional highlight for item associated with custom checkbox |
		-- stylua: ignore
		custom = {
			todo = { raw = '[-]', rendered = " ", highlight = 'RenderMarkdownTodo', scope_highlight = nil },
			consider = { raw = '[?]', rendered = "󰞋 ", highlight = 'RenderMarkdownConsider', scope_highlight = nil },
		},
	},
	quote = {
		enabled = true,
		render_modes = true,
		icon = "▋",
		-- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text
		-- if incorrectly configured with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'.
		-- A combination of these that is likely to work follows.
		-- | showbreak      | '  ' (2 spaces)   |
		-- | breakindent    | true              |
		-- | breakindentopt | '' (empty string) |
		-- These are not validated by this plugin. If you want to avoid adding these to your main
		-- configuration then set them in win_options for this plugin.
		repeat_linebreak = false,
		highlight = {
			'RenderMarkdownQuote1',
			'RenderMarkdownQuote2',
			'RenderMarkdownQuote3',
			'RenderMarkdownQuote4',
			'RenderMarkdownQuote5',
			'RenderMarkdownQuote6',
		},
	},
	pipe_table = {
		enabled = true,
		render_modes = true,
		-- Pre configured settings largely for setting table border easier.
		-- | heavy  | use thicker border characters     |
		-- | double | use double line border characters |
		-- | round  | use round border corners          |
		-- | none   | does nothing                      |
		preset = 'none',
		-- Determines how the table as a whole is rendered.
		-- | none   | disables all rendering                                                  |
		-- | normal | applies the 'cell' style rendering to each row of the table             |
		-- | full   | normal + a top & bottom line that fill out the table when lengths match |
		style = 'full',
		-- Determines how individual cells of a table are rendered.
		-- | overlay | writes completely over the table, removing conceal behavior and highlights |
		-- | raw     | replaces only the '|' characters in each row, leaving the cells unmodified |
		-- | padded  | raw + cells are padded to maximum visual width for each column             |
		-- | trimmed | padded except empty space is subtracted from visual width calculation      |
		cell = 'padded',
		-- Amount of space to put between cell contents and border.
		padding = 1,
		-- Minimum column width to use for padded or trimmed cell.
		min_width = 0,
		-- Characters used to replace table border.
		-- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal.
		-- stylua: ignore
		border = {
			'┌', '┬', '┐',
			'├', '┼', '┤',
			'└', '┴', '┘',
			'│', '─',
		},
		-- Always use virtual lines for table borders instead of attempting to use empty lines.
		-- Will be automatically enabled if indentation module is enabled.
		border_virtual = false,
		-- Gets placed in delimiter row for each column, position is based on alignment.
		alignment_indicator = '━',
		-- Highlight for table heading, delimiter, and the line above.
		head = 'RenderMarkdownTableHead',
		-- Highlight for everything else, main table rows and the line below.
		row = 'RenderMarkdownTableRow',
		-- Highlight for inline padding used to add back concealed space.
		filler = 'RenderMarkdownTableFill',
	},
	callout = { -- TODO: configure callout's
		-- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
		-- The key is for healthcheck and to allow users to change its values, value type below.
		-- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
		-- | rendered   | replaces the 'raw' value when rendering                             |
		-- | highlight  | highlight for the 'rendered' text and quote markers                 |
		-- | quote_icon | optional override for quote.icon value for individual callout       |
		-- | category   | optional metadata useful for filtering                              |

		note      = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo', category = 'github' },
		tip       = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess', category = 'github' },
		important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint', category = 'github' },
		warning   = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn', category = 'github' },
		caution   = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError', category = 'github' },
		-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
		abstract  = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
		summary   = { raw = '[!SUMMARY]', rendered = '󰨸 Summary', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
		tldr      = { raw = '[!TLDR]', rendered = '󰨸 Tldr', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
		info      = { raw = '[!INFO]', rendered = '󰬐 Info', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
		todo      = { raw = '[!TODO]', rendered = ' Todo', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
		hint      = { raw = '[!HINT]', rendered = '󰌶 Hint', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
		success   = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
		check     = { raw = '[!CHECK]', rendered = '󰄬 Check', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
		done      = { raw = '[!DONE]', rendered = '󰄬 Done', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
		question  = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
		help      = { raw = '[!HELP]', rendered = '󰘥 Help', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
		faq       = { raw = '[!FAQ]', rendered = '󰘥 Faq', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
		attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
		failure   = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError', category = 'obsidian' },
		fail      = { raw = '[!FAIL]', rendered = '󰅖 Fail', highlight = 'RenderMarkdownError', category = 'obsidian' },
		missing   = { raw = '[!MISSING]', rendered = '󰅖 Missing', highlight = 'RenderMarkdownError', category = 'obsidian' },
		danger    = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError', category = 'obsidian' },
		error     = { raw = '[!ERROR]', rendered = '󱐌 Error', highlight = 'RenderMarkdownError', category = 'obsidian' },
		bug       = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError', category = 'obsidian' },
		example   = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint', category = 'obsidian' },
		quote     = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
		cite      = { raw = '[!CITE]', rendered = '󱆨 Cite', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
	},
	link = {
		enabled = true,
		render_modes = true,
		-- How to handle footnote links, start with a '^'.
		footnote = {
			-- Turn on / off footnote rendering.
			enabled = true,
			-- Replace value with superscript equivalent.
			superscript = true,
			-- Added before link content.
			prefix = '',
			-- Added after link content.
			suffix = '',
		},
		-- Inlined with 'image' elements.
		image = '󰥶 ',
		-- Inlined with 'email_autolink' elements.
		email = '󰀓 ',
		-- Fallback icon for 'inline_link' and 'uri_autolink' elements.
		hyperlink = '󰌹 ',
		-- Applies to the inlined icon as a fallback.
		highlight = 'RenderMarkdownLink',
		-- Applies to WikiLink elements.
		wiki = {
			icon = '󱗖 ',
			body = function()
				return nil
			end,
			highlight = 'RenderMarkdownWikiLink',
		},
		-- Define custom destination patterns so icons can quickly inform you of what a link
		-- contains. Applies to 'inline_link', 'uri_autolink', and wikilink nodes. When multiple
		-- patterns match a link the one with the longer pattern is used.
		-- The key is for healthcheck and to allow users to change its values, value type below.
		-- | pattern   | matched against the destination text                            |
		-- | icon      | gets inlined before the link text                               |
		-- | kind      | optional determines how pattern is checked                      |
		-- |           | pattern | @see :h lua-patterns, is the default if not set       |
		-- |           | suffix  | @see :h vim.endswith()                                |
		-- | priority  | optional used when multiple match, uses pattern length if empty |
		-- | highlight | optional highlight for 'icon', uses fallback highlight if empty |
		custom = {
			web = { pattern = '^http', icon = "󰾔 " },
			discord = { pattern = 'discord%.com', icon = '󰙯 ' },
			github = { pattern = 'github%.com', icon = ' ' },
			gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
			google = { pattern = 'google%.com', icon = ' ' },
			neovim = { pattern = 'neovim%.io', icon = ' ' },
			reddit = { pattern = 'reddit%.com', icon = ' ' },
			stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
			wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
			youtube = { pattern = 'youtube%.com', icon = ' ' },
			-- TODO: Test if these patterns work
			facebook = { pattern = "facebook%.com", icon = " " },
			twitter = { pattern = "twitter%.com", icon = " " },
			x = { pattern = "x%.com", icon = " " },
			linkedin = { pattern = "linkedin%.com", icon = " " },
			steam = { pattern = "steam%.com", icon = " " },
		},
	},
	sign = {
		enabled = true,
		-- Applies to background of sign text.
		highlight = 'RenderMarkdownSign',
	},
	-- TODO: read docs for that and configure it better
	indent = {
		-- Mimic org-indent-mode behavior by indenting everything under a heading based on the
		-- level of the heading. Indenting starts from level 2 headings onward by default.

		-- Turn on / off org-indent-mode.
		enabled = false,
		-- Additional modes to render indents.
		render_modes = true,
		-- Amount of additional padding added for each heading level.
		per_level = 2,
		-- Heading levels <= this value will not be indented.
		-- Use 0 to begin indenting from the very first level.
		skip_level = 1,
		-- Do not indent heading titles, only the body.
		skip_heading = false,
		-- Prefix added when indenting, one per level.
		icon = '▎',
		-- Applied to icon.
		highlight = 'RenderMarkdownIndent',
	}
});

local md_wrap = vim.api.nvim_create_augroup("MarkdownAutoWrap", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = md_wrap,
	pattern = "markdown",
	callback = function()
		vim.opt_local.textwidth = 100    -- hard wrap at col 100
		vim.opt_local.wrap      = true   -- visual wrap
		vim.opt_local.linebreak = true   -- break at word boundaries
		vim.opt_local.formatoptions:append "t" -- auto-wrap as you type
	end,
});
