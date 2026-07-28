require("nvim_sandman").setup({
	-- TODO: check which plugins need permissions and enable sandman
	enabled = false,
	mode = "block_all",
	allow = {
		"blink.cmp",
		"golf",
	}
})
