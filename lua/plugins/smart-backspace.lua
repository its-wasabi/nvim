vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	once = true,
	callback = function()
		require("smart-backspace").setup()
	end
})
