-- TODO: Remove when blink-cmp-latex finally starts supporting blink v2
package.loaded["blink.cmp.lib.async"] = (function()
	local task = require("blink.lib.task")
	task.empty = task.resolve
	task.on_completion = task.on_resolve
	task.on_failure = task.on_reject
	task.task = task
	return task
end)()


local cmp = require("blink.cmp");
local border = "none";

cmp.build():wait(60000)
cmp.setup({
	keymap = require("keybinds").blink,

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	fuzzy = { implementation = "prefer_rust_with_warning" },

	snippets = { preset = "default" },

	signature = {
		enabled = true,
		window  = { border = border },
	},

	completion = {
		trigger = {
			show_on_keyword                      = true,
			show_on_trigger_character            = true,
			show_on_accept_on_trigger_character  = true,
			show_on_backspace_after_insert_enter = true,
		},

		accept = { auto_brackets = { enabled = true } },

		list = {
			selection = { preselect = true, auto_insert = false },
			cycle = { from_bottom = false },
		},

		ghost_text = { enabled = true },
		menu = {
			enabled            = true,
			auto_show          = true,
			min_width          = 10,
			max_height         = 18,
			border             = border,
			direction_priority = { "s", "n" },
			draw               = {
				gap     = 1,
				padding = 1,
				columns = {
					{ "kind_icon" },
					{ "label" },
				},
			},
		},

		documentation = {
			auto_show               = true,
			auto_show_delay_ms      = 200,
			treesitter_highlighting = true,
			window                  = { border = border },
		},

		keyword = { range = "prefix" },
	},


	sources = {
		default = { "lsp", "path", "buffer", "env", "dictionary", "thesaurus", "latex" },

		providers = {
			lsp = {
				name = "LSP",
				module = "blink.cmp.sources.lsp",
				score_offset = 90,
				min_keyword_length = 0,
				max_items = 40,
			},

			path = {
				name = "Path",
				module = "blink.cmp.sources.path",
				score_offset = 50,
			},

			buffer = {
				score_offset = 25,
				min_keyword_length = 3,
				max_items = 20,
				opts = {
					get_bufnrs = function()
						local bufs = vim.fn.getbufinfo({ buflisted = 1 })
						table.sort(bufs, function(a, b)
							return a.lastused > b.lastused
						end)

						local result = {}
						for i, buf in ipairs(bufs) do
							if i > 10 then break end
							table.insert(result, buf.bufnr)
						end

						return result
					end,
				},
			},

			env = {
				name = "env",
				module = "blink-cmp-env",
				score_offset = 30,
				min_keyword_length = 1,
				opts = {
					item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
					show_braces = false,
					show_documentation_window = true,
				},
			},

			latex = {
				name = "Latex",
				module = "blink-cmp-latex",
				score_offset = 85,
				opts = {
					insert_command = true,
				},
			},

			thesaurus = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.thesaurus",
				min_keyword_length = 4,
				max_items = 15,
				opts = {
					score_offset = 0,
					definition_pointers = { "!", "&", "^" },
				},
			},

			dictionary = {
				name = "blink-cmp-words",
				module = "blink-cmp-words.dictionary",
				min_keyword_length = 4,
				max_items = 15,
				opts = {
					score_offset = 0,
					definition_pointers = { "!", "&", "^" },
				},
			},
		},
	},
})
