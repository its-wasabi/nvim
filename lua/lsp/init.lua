local capabilities = vim.lsp.protocol.make_client_capabilities();
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities);

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
capabilities.textDocument.hover = {
	contentFormat = { "markdown", "plaintext" },
	dynamicRegistration = false,
}

capabilities.textDocument.semanticTokens = vim.tbl_deep_extend("force", capabilities.textDocument.semanticTokens or {}, {
	dynamicRegistration = false,
	requests = {
		full = { delta = true },
		range = true,
	},
	multilineTokenSupport = true,
	overlappingTokenSupport = true,
});

capabilities.workspace = vim.tbl_deep_extend("force", capabilities.workspace or {}, {
	didChangeWatchedFiles = {
		dynamicRegistration = true,
		relativePatternSupport = true,
	},
	fileOperations = {
		didCreate = true,
		didRename = true,
		didDelete = true,
		willCreate = true,
		willRename = true,
		willDelete = true,
	},
	symbol = {
		resolveSupport = {
			properties = { "location", "documentation", "range" }
		}
	}
});

local on_attach = require("lsp.on-attach");
local configs = require("lsp.configs");
for server_name, config in pairs(configs) do
	config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {});
	config.on_attach = on_attach;
	vim.lsp.config(server_name, config);
end

require("lsp.servers");
require("lsp.completion")

local format_on_save_group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_on_save_group,
	pattern = { "*.rs", "*.c", "*.cpp", "*.h", "*.lua", "*.py", "*.js", "*.ts" },
	callback = function(args)
		vim.lsp.buf.format({
			bufnr = args.buf,
			timeout_ms = 2000,
			async = true,
		})
	end,
})
