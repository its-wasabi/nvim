-- Removes kitty padding if using kitty
if vim.env.TERM == "xterm-kitty" then
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.fn.system({ "kitty", "@", "load-config", "-o", "font_family=FiraCode" });
			vim.fn.system({ "kitty", "@", "set-spacing", "padding=0", });
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			vim.fn.system({ "kitty", "@", "set-spacing", "padding=default", "margin=default", });
			vim.fn.system({ "kitty", "@", "load-config", "--ignore-overrides" });
		end,
	})
end

---@param module string
local function safe_require(module)
	local ok, error = pcall(require, module);
	if not ok then
		vim.schedule(function()
			local msg = ("ERROR LOADING MODULE: `%s` : `%s`"):format(module, tostring(error));
			vim.notify(msg, vim.log.levels.ERROR);
		end);
	end
end

vim.pack.add({
	-- Colorscheme
	{ src = "https://github.com/Fasamii/sobsob.nvim" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git" },
	-- Injections
	{ src = "https://github.com/Fasamii/embed.nvim" },

	-- Icons dependency for: [ "Telescope", "Lualine", "Netrw-icons" ]
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- Peak lines
	{ src = "https://github.com/nacro90/numb.nvim" },
	-- Netrw icons
	{ src = "https://github.com/Fasamii/netrw-icons.nvim" },
	-- Lualine
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	-- Indentation lines
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim.git" },

	-- Plenary dependency for: [ "Telescope" ]
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- Telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },

	-- Git
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	-- Todo
	{ src = "https://github.com/folke/todo-comments.nvim" },

	-- Session
	{ src = "https://github.com/rmagatti/auto-session" },

	-- Markdown
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/Thiago4532/mdmath.nvim" },

	-- LSP
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/b0o/schemastore.nvim" },
	-- Completion

	{ src = "https://github.com/bydlw98/blink-cmp-env.git" },
	{ src = "https://github.com/erooke/blink-cmp-latex.git" },
	{ src = "https://github.com/Kaiser-Yang/blink-cmp-git.git" },
	{ src = "https://github.com/xieyonn/blink-cmp-dat-word.git" },
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.8.0")
	},

	-- Debuggin
	{ src = "https://github.com/michaelb/sniprun.git" },

	-- Startup time measuring
	-- (n)vim --startuptime logfile
	{ src = "https://github.com/dstein64/vim-startuptime.git" },

	-- Fucking tetris lol
	{ src = "https://github.com/alec-gibson/nvim-tetris.git" },
})

vim.cmd.colorscheme("sobsob");

safe_require("wasabi.opts");
safe_require("wasabi.keymaps");
safe_require("wasabi.autocmds");
safe_require("wasabi.folds");

safe_require("wasabi.plugins.treesitter");
safe_require("wasabi.plugins.nvim-web-devicons");
safe_require("wasabi.plugins.numb");

-- ERROR: For some reason virt text is rendered incorrectly while using netrw with neovide
if not vim.g.neovide then
	safe_require("wasabi.plugins.netrw-icons");
end

safe_require("wasabi.plugins.lualine");
safe_require("wasabi.plugins.telescope");
safe_require("wasabi.plugins.gitsigns");
safe_require("wasabi.plugins.todo-comments");
safe_require("wasabi.plugins.auto-session");
safe_require("wasabi.plugins.markdown");
safe_require("wasabi.plugins.mdmath");
safe_require("wasabi.lsp");
safe_require("wasabi.plugins.indent-blankline");
safe_require("wasabi.plugins.sniprun");
