vim.loader.enable()

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1

vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_matchit = 1

local nvim_font_size = 10
local nvim_font = "Iosevka Code"
-- local nvim_font = "Monocraft"

if vim.env.TERM == "xterm-kitty" then
	local kitty_group = vim.api.nvim_create_augroup("KittyIPC", { clear = true })

	vim.api.nvim_create_autocmd("VimEnter", {
		group = kitty_group,
		callback = function()
			vim.system({ "kitty", "@", "set-spacing", "padding=0" }, { detach = true })
			vim.system({
				"kitty", "@", "load-config",
				"-o", "font_family=" .. nvim_font,
				"-o", "font_size=" .. tostring(nvim_font_size),
			}, { detach = true })
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = kitty_group,
		callback = function()
			vim.system({ "kitty", "@", "set-spacing", "padding=default", "margin=default" }, { detach = true })
			vim.system({ "kitty", "@", "load-config", "--ignore-overrides" }, { detach = true })
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
	{ src = "https://github.com/nyoom-engineering/oxocarbon.nvim" },
	{ src = "https://github.com/maxmx03/fluoromachine.nvim" },
	{ src = "https://github.com/ramojus/mellifluous.nvim" },
	-- Icons
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- Notifications
	{ src = "https://github.com/j-hui/fidget.nvim" },
	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
	-- Utilities
	{ src = "https://github.com/Fasamii/embed.nvim" },
	-- UI
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	-- Styling
	{ src = "https://github.com/nacro90/numb.nvim" },
	{ src = "https://github.com/Fasamii/netrw-icons.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
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
	-- Session
	{ src = "https://github.com/folke/persistence.nvim" },
	-- Markdown
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

vim.cmd.colorscheme("sobsob")

require("plugins.treesitter")
require("plugins.treesitter-context")

require("plugins.nvim-web-devicons")
require("plugins.fidget")
require("plugins.netrw-icons")
require("plugins.lualine")

require("plugins.telescope")

require("plugins.gitsigns")
require("plugins.numb")
require("plugins.todo-comments")

require("plugins.persistence")

-- Markdown
require("plugins.render-markdown");

vim.lsp.log.set_level(vim.log.levels.OFF)
require("lsp")
