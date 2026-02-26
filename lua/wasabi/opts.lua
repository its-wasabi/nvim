-- Global leader key used as a prefix for custom keybindings
-- Must be set before defining any <leader> mappings
vim.g.mapleader = " ";
-- Local leader key, used mainly for filetype-specific mappings
vim.g.maplocalleader = "~";
-- Timeout (in milliseconds) for mapped key sequences
-- Affects how long nvim waits after pressing <leader>
vim.opt.timeoutlen = 300;

-- Enables full 24-bit RGB color
vim.opt.termguicolors = true;
-- Enables mouse support in specified modes
-- Values:
--	"" - disabled
--	"a" - all
--	combination of "nvi" - selective
vim.opt.mouse = "nv";
-- Highlights the screen line the cursor is currently on
vim.opt.cursorline = true;

-- Show absolute line number on the current line
vim.opt.number = true;
-- Show relative line numbers on all other lines
vim.opt.relativenumber = true;
-- Column used to display signs (diagnostics, git, breakpoints)
-- Where to render diagnostic/git/breakpoint signs:
--   "number"  - overlap with the line number column (saves space)
--   "yes"     - always show a dedicated sign column
--   "no"      - never show signs
--   "auto"    - show only when there are active signs
vim.opt.signcolumn = "number";
-- Height of the command line
vim.opt.cmdheight = 0;
-- Statusline behavior with multiple buffers
-- Values:
--	0 - never
--	1 - only with splits
--	2 - per window
--	3 - global (neovim only)
vim.opt.laststatus = 3;

-- Visually wrap long lines instead of horizontal scrolling
vim.opt.wrap = true;
-- Wrap lines at word boundaries instead of breaking words
-- Only has effect when "wrap" is enabled
vim.opt.linebreak = true;
-- Indents wrapped lines to match the indentation of the original line
-- Improves readability of wrapped code and comments
vim.opt.breakindent = true;
-- Minimum number of context lines kept above and below the cursor
vim.opt.scrolloff = 999;
-- Minimum number of context lines kept to the left and right of cursor
vim.opt.sidescrolloff = 8;
-- Allows cursor movement into "virtual" space
-- Values:
--	"block" - only in Visual Block mode (safest useful option)
--	"onemore" - one char past EOL
--  "all" - anywhere (can break assumptions)
vim.opt.virtualedit = "block";

local tab_size = 4; -- TODO: Make some global table wit settings like that
-- Use literal tab characters (\t) instead of spaces
-- false = tabs, true = spaces
vim.opt.expandtab = false;
-- Visual width of a tab character
vim.opt.tabstop = tab_size;
-- Number of spaces inserted/removed when pressing <Tab>/<BS>
vim.opt.softtabstop = tab_size;
-- Number of spaces used for autoindent and << / >> shifts
vim.opt.shiftwidth = tab_size;
-- Copies indentation from the previous line
vim.opt.autoindent = true;
-- Adds simple syntax-aware indentation (mainly C-like languages)
-- Often superseded by LSP or tree-sitter indentation
vim.opt.smartindent = true;

-- Live preview of :substitute commands
-- "split" shows results in a temporary split window
vim.opt.inccommand = "split";
-- New horizontal splits open below the current window
vim.opt.splitbelow = true;
-- New vertical splits open to the right of the current window
vim.opt.splitright = true;
-- Keep screen position on split
vim.opt.splitkeep = "screen";

local backup_dir = os.getenv("HOME") .. "/.local/share/nvim/backup";
vim.fn.mkdir(backup_dir .. "/undo", "p");
vim.fn.mkdir(backup_dir .. "/backup", "p");
vim.fn.mkdir(backup_dir .. "/swap", "p");

-- Directory for persistent undo files
vim.opt.undodir = backup_dir .. "/undo";
-- Enables persistent undo across sessions
vim.opt.undofile = true;
-- Directory for backup files (~).
vim.opt.backupdir = backup_dir .. "/backup";
-- Skip backup creation for
vim.opt.backupskip = { "/tmp/*", "/private/tmp/*" };
-- Enables backup file creation before overwriting
vim.opt.backup = true;
-- Directory for swap files
vim.opt.directory = backup_dir .. "/swap";
-- Enables swap files for crash recovery and file-lock detection
vim.opt.swapfile = true;

-- Directory for spell files
local spell_dir = vim.fn.stdpath("config") .. "/spelldir";
vim.fn.mkdir(spell_dir, "p");
vim.opt.spellfile = spell_dir .. "/spellfile.utf-8.add";
-- Spell checking
vim.opt.spell = true;
-- Spell checking language
vim.opt.spelllang = "en_us";

-- Case insensitive seach
vim.opt.ignorecase = true;
-- Case sensitive search when uppercase letters are used
vim.opt.smartcase = true;
-- Show search results while typing
vim.opt.incsearch = true;
-- Enables persistent search highlighting
vim.opt.hlsearch = true;

-- Use the system clipboard for all yank/paste operations
-- Scheduled to defer the clipboard provider check and reduce startup time
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus";
end)

-- Draws a vertical guideline
-- Accepts comma-separated list: "80,100"
vim.opt.colorcolumn = "100,120";
-- Enables .editorconfig support
-- Editorconfig can override tab/indent options per project
vim.g.editorconfig = true;

-- Disable the netrw banner
vim.g.netrw_banner = 0;
-- Directory listing style
-- 0 = simple, 1 = detailed, 2 = wide, 3 = tree view
vim.g.netrw_liststyle = 3;
-- netrw window size as a percentage of the screen width
vim.g.netrw_winsize = 8;
-- Shell command used to copy directories
vim.g.netrw_localcopydircmd = "cp -r";
-- Shell command used to remove directories
vim.g.netrw_localrmdir = "rm -ri";
-- Directory browsing cache behavior
-- 0 = no cache, 1 = moderate caching, 2 = aggressive caching
vim.g.netrw_fastbrowse = 1;
-- Open vertical splits to the right when pressing 'v' in netrw (mirrors split right)
vim.g.netrw_altv = 1;

-- Completion menu behavior:
--   "menu"     - show a popup menu even for a single match
--   "menuone"  - show the menu even when there's only one option
--   "noselect" - don't auto-select the first item (lets your completion plugin drive)
vim.opt.completeopt = { "menu", "menuone", "noselect" };

-- Time in milliseconds before CursorHold events and diagnostics update
vim.opt.updatetime = 20;


-- LSP diagnostics config
vim.diagnostic.config({
	severity_sort = true,
	-- Inline virtual text diagnostics
	virtual_text = {
		severity = { max = vim.diagnostic.severity.WARN },
		source = "if_many",
		spacing = 2,
		format = function(diag)
			return (diag.message:gsub("%.$", "")); -- remove trailing `.` from lua_ls
		end,
		prefix = "",
		suffix = function(diag)
			if not diag then return "" end
			local codeOrSource = (tostring(diag.code or diag.source or ""))
			if codeOrSource == "" then return "" end
			return (" [%s]"):format(codeOrSource:gsub("%.$", ""))
		end,
	},
	-- Full-width virtual lines
	virtual_lines = {

		severity = { min = vim.diagnostic.severity.ERROR },
	},
	-- Diagnostic underlines
	underline = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
	-- Update diagnostics while typing
	update_in_insert = false,
	-- Floating diagnostic window appearance
	float = {
		focusable = true,
		style = "minimal",
		border = "solid",
		source = true,
		header = "",
		prefix = "",
		suffix = "",
		close_events = {
			"CursorMoved",
			"TextChanged", -- leave out "TextChangedI" to continue showing diagnostics while typing
			"BufHidden", -- fix window persisting on buffer switch (not `BufLeave` so float can be entered)
			"LspDetach", -- fix window persisting when restarting LSP
		}
	},
	signs = false,
});

-- signs = {
-- 	text = {
-- 		[vim.diagnostic.severity.ERROR] = "E",
-- 		[vim.diagnostic.severity.WARN] = "W",
-- 		[vim.diagnostic.severity.INFO] = "i",
-- 		[vim.diagnostic.severity.HINT] = "H",
-- 	},
-- },
-- Gutter signs

if vim.g.neovide then
	vim.g.neovide_confirm_quit = false;
	vim.g.neovide_detach_on_quit = 'always_quit';

	vim.o.guifont = "Monocraft:h8";
	vim.opt.linespace = 0;

	vim.g.neovide_text_gamma = 0.0;
	vim.g.neovide_text_contrast = 0.5;

	vim.g.neovide_cursor_animation_length = 0.06;
	vim.g.neovide_cursor_animate_in_insert_mode = false;
	vim.g.neovide_cursor_short_animation_length = 0.03;
	vim.g.neovide_cursor_trail_size = 1.0;
	vim.g.neovide_cursor_antialiasing = true;
	vim.g.neovide_cursor_animate_command_line = false;
	vim.g.neovide_cursor_smooth_blink = false;

	-- vim.g.neovide_cursor_vfx_mode = "railgun";
	vim.g.neovide_cursor_vfx_mode = "";
	vim.g.neovide_cursor_vfx_particle_phase = 10.0;
	vim.g.neovide_cursor_vfx_particle_curl = 1.0;
	vim.g.neovide_cursor_vfx_opacity = 200.0;
	vim.g.neovide_cursor_vfx_particle_lifetime = 0.5;
	vim.g.neovide_cursor_vfx_particle_highlight_lifetime = 0.2;
	vim.g.neovide_cursor_vfx_particle_density = 0.8;
	vim.g.neovide_cursor_vfx_particle_speed = 20.0;

	vim.g.neovide_padding_top = 0;
	vim.g.neovide_padding_bottom = 0;
	vim.g.neovide_padding_right = 0;
	vim.g.neovide_padding_left = 0;

	vim.g.neovide_opacity = 1.0;
	vim.g.neovide_normal_opacity = 1.0;
	vim.g.neovide_show_border = false;

	vim.g.neovide_position_animation_length = 0;
	vim.g.neovide_scroll_animation_length = 0.1;
	vim.g.neovide_scroll_animation_far_lines = 0;

	-- TODO: Check what is that progress bar
	vim.g.neovide_progress_bar_enabled = true;
	vim.g.neovide_progress_bar_height = 5.0;
	vim.g.neovide_progress_bar_animation_speed = 200.0;
	vim.g.neovide_progress_bar_hide_delay = 0.2;

	vim.g.neovide_hide_mouse_when_typing = true;

	vim.g.neovide_refresh_rate = 60;
	vim.g.neovide_no_idle = false;
	vim.g.neovide_refresh_rate_idle = 5;

	vim.g.neovide_fullscreen = false;
	vim.g.neovide_macos_simple_fullscreen = true;

	vim.g.neovide_remember_window_size = false;
	vim.g.neovide_profiler = false;

	vim.g.neovide_input_ime = false;
end

-- vim.opt.smoothscroll = true;


-- ShaDa (Shared Data) file — persists history across sessions.
-- Format: 'N = remember N marks per file, <N = save up to N lines per register,
--          sN = skip registers larger than N KB, :N = save N lines of cmdline history,
--          /N = save N lines of search history, @N = save N lines of input history,
--          h  = don't restore hlsearch state on startup
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h";

-- Remove the legacy features
vim.g.loaded_python3_provider = 0;
vim.g.loaded_perl_provider = 0;
vim.g.loaded_ruby_provider = 0;
vim.g.loaded_node_provider = 0;

-- auto-session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
