require("mason").setup({
	log_level = vim.log.levels.OFF,

	max_concurrent_installers = 8,

	ui = {
		border = "solid",
		width = 0.8,
		height = 0.8,
		icons = {
			package_installed = "󰄴 ",
			package_pending = " ",
			package_uninstalled = "",
		},
	},
});

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"rust_analyzer",
		"glsl_analyzer",
		"clangd",
		"asm_lsp",
		"ts_ls",
		"pylsp",
		"lua_ls",
		"marksman",
		"jsonls",
		"yamlls",
		"html",
		"phpactor",
		"emmet_language_server",
		"cssls",
	},

	automatic_installation = true,
	automatic_enable = true,
});
