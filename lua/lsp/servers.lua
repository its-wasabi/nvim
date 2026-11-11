require("mason").setup({
	log_level = vim.log.levels.OFF,

	max_concurrent_installers = 8,

	ui = {
		border = "solid",
		width = 0.8,
		height = 0.8,
		icons = {
			package_installed = "󰄴 ",
			package_pending = " ",
			package_uninstalled = " ",
		},
	},
});

require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(require("lsp.configs")),
	automatic_installation = true,
	automatic_enable = true,
});
