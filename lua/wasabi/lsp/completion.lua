local ts_ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils");

require("blink.cmp").setup({
	enabled = function()
		return not vim.tbl_contains({ "glsl" }, vim.bo.filetype)
	end,
	-- TODO: Find a way to put that in keymaps.lua file
	keymap = {
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-e>"] = { "hide" },
		["<S-Tab>"] = { "select_and_accept" },
		["<C-Space>"] = { "show" },

		["<C-k>"] = { "scroll_documentation_up", "fallback" },
		["<C-j>"] = { "scroll_documentation_down", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},

	sources = {
		default = { "lsp", "path", "buffer", "env", "datword", "latex", "git", "cmdline" },
		providers = {
			lsp = {
				name = "LSP",
				module = "blink.cmp.sources.lsp",
				score_offset = 90,
			},

			path = {
				name = "Path",
				module = "blink.cmp.sources.path",
				score_offset = 50,
			},

			buffer = {
				score_offset = 25,
				opts = {
					get_bufnrs = function()
						return vim.tbl_filter(function(bufnr)
							return vim.bo[bufnr].buftype == ""
						end, vim.api.nvim_list_bufs())
					end,
				},
			},

			env = {
				name = "env",
				module = "blink-cmp-env",
				score_offset = 10,
				opts = {
					item_kind = require("blink.cmp.types").CompletionItemKind.Variable, -- TODO: Check if Value isn't more suitable
					show_braces = false,
					show_documentation_window = true,
				}
			},

			datword = {
				name = "Word",
				module = "blink-cmp-dat-word",
				-- TODO: Check if you really need that
				score_offset = function()
					if ts_ok then
						local node = ts_utils.get_node_at_cursor();
						while node do
							if node:type() == "comment" then
								return 80;
							end
							node = node:parent();
						end
					end
					return 5;
				end,
				opts = {
					spellsuggest = true,
					paths = {
						"~/.config/nvim/spelldir/spellfile.utf-8.add",
						"~/.config/nvim/google-10000-english/google-10000-english-usa.txt",
					},
				},
			},

			latex = {
				name = "Latex",
				module = "blink-cmp-latex",
				score_offset = 85,
				opts = {
					-- set to true to insert the latex command instead of the symbol
					insert_command = true,
				},
			},

			git = {
				module = "blink-cmp-git",
				name = "Git",
				enabled = function()
					return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
				end,
				opts = {
					commit = {
						-- You may want to customize when it should be enabled
						-- The default will enable this when `git` is found and `cwd` is in a git repository
						-- enable = function() end
						-- You may want to change the triggers
						-- triggers = { ':' },
					},
					git_centers = {
						github = {
							-- Those below have the same fields with `commit`
							-- Those features will be enabled when `git` and `gh` (or `curl`) are found and
							-- remote contains `github.com`
							-- issue = {
							--     get_token = function() return '' end,
							-- },
							-- pull_request = {
							--     get_token = function() return '' end,
							-- },
							-- mention = {
							--     get_token = function() return '' end,
							--     get_documentation = function(item)
							--         local default = require('blink-cmp-git.default.github')
							--             .mention.get_documentation(item)
							--         default.get_token = function() return '' end
							--         return default
							--     end
							-- }
						},
						gitlab = {
							-- Those below have the same fields with `commit`
							-- Those features will be enabled when `git` and `glab` (or `curl`) are found and
							-- remote contains `gitlab.com`
							-- issue = {
							--     get_token = function() return '' end,
							-- },
							-- NOTE:
							-- Even for `gitlab`, you should use `pull_request` rather than`merge_request`
							-- pull_request = {
							--     get_token = function() return '' end,
							-- },
							-- mention = {
							--     get_token = function() return '' end,
							--     get_documentation = function(item)
							--         local default = require('blink-cmp-git.default.gitlab')
							--            .mention.get_documentation(item)
							--         default.get_token = function() return '' end
							--         return default
							--     end
							-- }
						}
					}
				},
			},
		},
	},

	cmdline = {
		sources = function()
			local type = vim.fn.getcmdtype();
			if type == "/" or type == "?" then
				return { "buffer" }
			end
			if type == ":" then
				return { "cmdline", "path" }
			end
			return {};
		end
	},

	completion = {
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
			show_on_accept_on_trigger_character = true,
		},

		ghost_text = {
			enabled = true,
		},

		accept = {
			auto_brackets = {
				enabled = true
			}
		},

		list = {
			selection = {
				preselect = true,
				auto_insert = false,
			}
		},

		menu = {
			enabled = true,
			auto_show = true,
			min_width = 10,
			max_height = 18,
			border = "padded",
			direction_priority = { "s", "n" },
			draw = {
				gap = 1,
				padding = { 1, 1 },
				columns = {
					{ "kind_icon" },
					{ "label" },
				},

				components = {
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then icon = dev_icon end
							end
							return icon
						end,
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then hl = dev_hl end
							end
							return hl
						end,
					},

					label = {
						width = { fill = false, max = 40 },
						text = function(ctx) return ctx.label end,
					},
				},
			},
		},

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 50,
			treesitter_highlighting = true,
			window = {
				border = "solid"
			}
		},

		keyword = {
			range = "prefix"
		},
	},

	signature = {
		enabled = true,
		-- TODO: Check that
		window = {
			border = "solid",
		}
	},
});
