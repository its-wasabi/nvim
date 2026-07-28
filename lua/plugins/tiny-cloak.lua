require("tiny-cloak").setup({
	cloak_character = "*",
	file_patterns = {
		".env*",
		"*.json",
		"*.yaml",
		"*.yml",
	},

	key_patterns = {
		"KEY",
		"API_KEY",
		"SECRET",
		"PASSWORD",
		"TOKEN",
		"CREDENTIAL",
		"AUTH"
	}
});
