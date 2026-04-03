return {
	rust_analyzer = {
		handlers = {
			["textDocument/diagnostic"] = function() end,
		},
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					enable = true,
					command = "clippy",
					extraArgs = {
						"--",
						"-W", "clippy::all",
						"-W", "clippy::pedantic",
						"-W", "clippy::nursery",
						"-W", "clippy::unwrap_used",
						"-W", "clippy::expect_used",
						"-W", "clippy::panic",
						"-W", "clippy::todo",
						"-W", "clippy::unimplemented",
					},
				},
				cargo = {
					allFeatures = true,
					buildScripts = { enable = true },
				},
				procMacro = {
					enable = true,
					ignored = {
						["async-trait"] = { "async_trait" },
						["napi-derive"] = { "napi" },
					},
				},
				inlayHints = {
					bindingModeHints = { enable = false },
					chainingHints = { enable = true },
					closingBraceHints = { enable = true, minLines = 25 },
					parameterHints = { enable = true },
					typeHints = { enable = true },
				},
				diagnostics = {
					enable = true,
					experimental = {
						enable = true,
					}
				}
			}
		},
	},

	glsl_analyzer = {
		cmd = { "glsl_analyzer" },
		filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
		root_markers = { ".git", ".jj" },
	},

	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
		},
		init_options = {
			usePlaceholders = true,
			completeUnimported = true,
			clangdFileStatus = true,
		},
	},

	ts_server = {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
				}
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
				}
			}
		}
	},

	pyright = {
		settings = {
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				}
			}
		}
	},

	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
				hint = {
					enable = true,
					paramType = true,
					setType = false,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
			}
		}
	},

	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			}
		}
	},

	yamlls = {
		settings = {
			yaml = {
				schemas = require("schemastore").yaml.schemas(),
				schemaStore = {
					enable = false,
					url = "",
				},
			}
		}
	},

	html = {
		filetypes = {
			"html",
			"htmx",
			"htmldjango",
			"php",
		}
	}
}
