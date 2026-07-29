return function(client, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
	require("keybinds").lsp_attach(bufnr);

	if client.name == "rust_analyzer" then
		if vim.fn.isdirectory("/usr/lib/rustlib/src/rust/library") == 0 then
			require("wasabi.util").notify(
				"rust-src not found! - Install it with: sudo pacman -S rust-src\nWithout it, rust-analyzer has no stdlib completions or deep lints.",
				vim.log.levels.WARN,
				{ title = "rust-analyzer" }
			);
		end
	end

	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	if client.server_capabilities.codeLensProvider then
		vim.lsp.codelens.enable(false);
	end

	if client.server_capabilities.documentHighlightProvider then
		local group_name = "LspDocumentHighlight_" .. bufnr
		local highlight_group = vim.api.nvim_create_augroup(group_name, { clear = true })

		vim.api.nvim_create_autocmd("CursorHold", {
			group = highlight_group,
			buffer = bufnr,
			callback = function() vim.lsp.buf.document_highlight() end,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
			group = highlight_group,
			buffer = bufnr,
			callback = function() vim.lsp.buf.clear_references() end,
		})
	end
end
