local cmp = require("blink.cmp");
cmp.build():wait(60000)
cmp.setup({
	enabled = function()
		-- NOTE: Disable completion for shader buffers
		return not vim.tbl_contains({ "glsl" }, vim.bo.filetype)
	end,

	keymap = require("keybinds").blink,

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
		sorts = {
			"score",
			"sort_text",
			"label",
		}
	},

	completion = {
		trigger = {
			show_on_keyword                      = true,
			show_on_trigger_character            = true,
			show_on_accept_on_trigger_character  = true,
			show_on_backspace_after_insert_enter = true,
		},

		ghost_text = { enabled = true },

		accept = {
			auto_brackets = { enabled = true },
		},

		list = {
			selection = {
				preselect   = true,
				auto_insert = false,
			},
		},

		menu = {
			enabled            = true, -- Ghost mode only on false
			auto_show          = true,
			min_width          = 10,
			max_height         = 18,
			border             = "padded",
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
			-- Give LSP time to respond before the doc window appears;
			-- avoids a blank-then-filled re-render jank
			auto_show_delay_ms      = 200,
			-- Treesitter highlighting in docs is pretty but re-parses on every
			-- item change — disable if docs still feel sluggish
			treesitter_highlighting = true,
			window                  = { border = "solid" },
		},

		keyword = { range = "prefix" },
	},

	signature = {
		enabled = true,
		window  = { border = "padded" },
	},


	sources = {
		default = { "lsp", "path", "buffer", "env", "calc", "dictionary", "thesaurus" },

		providers = {
			lsp = {
				name = "LSP",
				module = "blink.cmp.sources.lsp",
				score_offset = 90,
				min_keyword_length = 0,
				max_items = 40,

				transform_items = function(_, items)
					local kinds = vim.lsp.protocol.CompletionItemKind

					for _, item in ipairs(items) do
						local offset = item.score_offset or 0

						if item.kind == kinds.Keyword then
							item.score_offset = offset + 3;
						elseif item.kind == kinds.Method then
							item.score_offset = offset + 4;
						elseif item.kind == kinds.Variable then
							item.score_offset = offset + 4;
						elseif item.kind == kinds.Function then
							item.score_offset = offset + 2;
						elseif item.kind == kinds.Module then
							item.score_offset = offset + 1;
						end
					end

					return items;
				end,
			},

			calc = {
				name = "calc",
				module = "blink.compat.source",
				score_offset = 100,
				transform_items = function(_, items)
					for _, item in ipairs(items) do
						item.kind_icon = "󰪚"
						item.kind_hl   = "Info"
					end
					return items
				end,
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
						local bufs = vim.tbl_filter(function(b)
							return vim.bo[b].buftype == ""
								and vim.api.nvim_buf_is_loaded(b)
						end, vim.api.nvim_list_bufs())

						-- Limit to the 10 most recently used buffers
						if #bufs > 10 then
							table.sort(bufs, function(a, b) return a > b end)
							bufs = vim.list_slice(bufs, 1, 10)
						end

						return bufs
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
				min_keyword_length = 2,
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
