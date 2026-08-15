vim.loader.enable()

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1

local nvim_font = "Iosevka Code"
local nvim_font_size = 11
if vim.env.TERM == "xterm-kitty" then
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.fn.jobstart({ "kitty", "@", "set-spacing", "padding=0", }, { detach = true })
			vim.fn.jobstart({ "kitty", "@", "load-config",
				"-o", ("font_family=" .. tostring(nvim_font)),
				"-o", ("font_size=" .. tostring(nvim_font_size)),
			})
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			vim.fn.system({ "kitty", "@", "set-spacing", "padding=default", "margin=default", })
			vim.fn.system({ "kitty", "@", "load-config", "--ignore-overrides" })
		end,
	})
end

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "DiffChange", timeout = 240 })
	end,
})

require("opts")
require("keybinds")
require("diagnostics")

if not vim.pack then
	vim.cmd.colorscheme("wildcharm")
	return
end

require("register-pack-hooks")({
	["telescope-fzf-native.nvim"] = { "make" },
	["blink.cmp"] = { "cargo", "build", "--release" },
})


vim.pack.add({
	-- Color Theme
	{ src = "https://github.com/Fasamii/sobsob.nvim" },
	{ src = "https://github.com/its-wasabi/stickynote.nvim" },
	-- Icons
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- Notifications
	{ src = "https://github.com/j-hui/fidget.nvim" },
	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
	-- Styling
	{ src = "https://github.com/Fasamii/netrw-icons.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim.git" },
	-- Telescope
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	-- LSP
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/b0o/schemastore.nvim" },
	-- Completion
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/bydlw98/blink-cmp-env.git" },
	{ src = "https://github.com/archie-judd/blink-cmp-words" },
	{ src = "https://github.com/erooke/blink-cmp-latex.git" },
	-- Utilities
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/nacro90/numb.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/Fasamii/embed.nvim" },
	-- Session
	{ src = "https://github.com/folke/persistence.nvim" },
	-- Markdown
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

vim.cmd.colorscheme("sobsob")
vim.notify = require("fidget").notify

require("plugins.treesitter")
require("plugins.treesitter-context")

require("plugins.nvim-web-devicons")
require("plugins.fidget")
if not vim.g.neovide then
	require("plugins.netrw-icons")
end
require("plugins.lualine")
-- require("plugins.indent-blankline")

require("plugins.telescope")

require("plugins.gitsigns")
require("plugins.numb")
require("plugins.todo-comments")

require("plugins.persistence")

-- Markdown
require("plugins.render-markdown");

vim.lsp.log.set_level(vim.log.levels.OFF)
vim.api.nvim_create_autocmd("FileType", {
	once = true,
	callback = function()
		require("lsp");
	end,
});
