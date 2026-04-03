if vim.fn.executable("tree-sitter") ~= 1 then
	require("wasabi.util").notify(
		"Tree-sitter CLI not found!\nInstall 'tree-sitter-cli' to enable parser compilation.",
		vim.log.levels.ERROR,
		{ title = "Tree-sitter" }
	);

	return;
end

local parsers = {
	"vim",
	"vimdoc",
	"sql",
	"query",
	"regex",

	"html",
	"css",
	"jsx",
	"tsx",

	"bash",
	"zsh",
	"lua",
	"luadoc",
	"python",
	"javascript",
	"typescript",

	"asm",
	"c",
	"cpp",
	"rust",
	"go",

	"nix",
	"json",
	"yaml",
	"toml",

	"markdown",
	"markdown_inline",

	"glsl",
};

local ts_ok, ts = pcall(require, "nvim-treesitter")
if ts_ok then
	local ts_path = vim.fn.stdpath("data") .. "/site";
	ts.setup({ install_dir = ts_path });
	ts.install(parsers, { summary = false });
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
		if lang then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
});

local tsto_ok, tsto = pcall(require, "nvim-treesitter-textobjects");
if tsto_ok then
	tsto.setup({
		select = {
			enable = true,
			lookahead = true,
			selection_modes = {
				['@parameter.outer'] = 'v',
				['@function.outer'] = 'V',
				['@class.outer'] = 'V',
			},
			include_surrounding_whitespace = false,
		},
	});

	require("wasabi.keymaps").treesitter(
		require("nvim-treesitter-textobjects.select")
	);
end
