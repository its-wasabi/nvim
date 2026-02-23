local M = {};

local set = require("wasabi.util").set;
local notify = require("wasabi.util").notify;

-- MISC IMPORTANT

set({ "n", "v" }, "<Space>", "<Nop>", "Remove any action <Space> had", { silent = true });
set("n", "<Enter>", "i<Enter><Esc>^", "Enter behaviour from insert in normal mode");

-- GENERAL EDITING

set("n", "dr", "0D", "delete line without removing line");

set("v", "K", ":m '<-2<CR>gv-gv", "moves lines down in visual mode");
set("v", "J", ":m '>+1<CR>gv-gv", "moves lines down in visual mode");

set("v", "<", "<gv", "indent right without removing highlight");
set("v", ">", ">gv", "indent right without removing highlight");
set("n", "co", "o<Esc>Vcx<Esc><cmd>normal gcc<cr>fxa<bs>", "add comment below");
set("n", "cO", "O<Esc>Vcx<Esc><cmd>normal gcc<cr>fxa<bs>", "add comment above");

set("v", "o", "\"_dP", "Override");

-- BUFFER OPERATIONS

set("n", "<leader>fv", function()
	vim.cmd("normal! ggVG");
end, "Select entire buffer");

set("n", "<leader>rb", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	"Replace word under cursor for this buffer");

-- SPLITS

set("n", "<leader>sv", "<C-w>s", "split vertically");
set("n", "<leader>sp", "<C-w>v", "split horizontally");
set("n", "<leader>sd", "<cmd>close<CR>", "close current split");
set("n", "<leader>sh", "<C-w>h", "focus left split");
set("n", "<leader>sj", "<C-w>j", "focus bottom split");
set("n", "<leader>sk", "<C-w>k", "focus upper split");
set("n", "<leader>sl", "<C-w>l", "focus right split");
set("n", "<leader>srh", "<C-w>>", "resize split window (left)");
set("n", "<leader>srl", "<C-w><", "resize split window (right)");
set("n", "<leader>srk", "<C-w>+", "resize split window (up)");
set("n", "<leader>srj", "<C-w>-", "resize split window (down)");
set("n", "<leader>sr=", "<C-w>=", "resize split window (left)");

-- TABS

set("n", "<leader>wn", "<cmd>tabnew<CR>", "create new tab");
set("n", "<leader>wd", "<cmd>tabclose<CR>", "close current tab");
set("n", "<leader>wh", "<cmd>tabp<CR>", "focus previous tab");
set("n", "<leader>wl", "<cmd>tabn<CR>", "focus next tab");

-- FILE EXPLORER

set("n", "<leader>fe", vim.cmd.Ex, "open NetRw");

-- SPELL

set("n", "zz", function()
	vim.opt.spell = not vim.opt.spell:get()
end, "toggle spell checking");
set("n", "zn", "]s", "focus next spelling error");
set("n", "zp", "[s", "focus previous spelling error");
set("n", "zg", "zg", "mark word as correct");
set("n", "zw", "zw", "mark word as incorrect");
set("n", "zr", function()
	vim.cmd("normal! zuw");
	vim.cmd("normal! zug");
end, "Remove word from dictionary");

-- CWD

set("n", "<leader>cd", function()
	local current_file = vim.fn.expand("%:p:h");
	if current_file ~= '' then
		require("wasabi.util").set_pwd(current_file);
	else
		notify("failed to set pwd", vim.log.levels.ERROR)
	end
end, "set pwd to current file directory", { silent = false });
set("n", "<leader>cD", function()
	local current_dir = vim.fn.getcwd();
	local pwd_path = vim.fn.input("Change cwd to: ", current_dir, "dir");
	if pwd_path then
		require("wasabi.util").set_pwd(pwd_path);
	end
end, "prompt to change pwd", { silent = false });
set("n", "<leader>cr", function()
	local current_file = vim.fn.expand("%:p:h");
	local git_root = require("wasabi.util").find_git_root(current_file);
	if git_root then
		require("wasabi.util").set_pwd(git_root);
	else
		notify("failed to set pwd", vim.log.levels.ERROR)
	end
end, "set pwd to git root", { silent = false });

if vim.g.neovide then
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end

	set("n", "<C-0>", function()
		vim.g.neovide_scale_factor = 1.0;
	end, "reset scale factor (neovide)");
	set("n", "<C-=>", function()
		change_scale_factor(1.25)
	end, "increase scale factor (neovide)");
	set("n", "<C-->", function()
		change_scale_factor(1 / 1.25)
	end, "decrease scale factor (neovide)");
end

function M.treesitter(select)
	set({ "x", "o" }, "af", function()
		select.select_textobject("@function.outer", "textobjects")
	end, "Select outer function")
	set({ "x", "o" }, "if", function()
		select.select_textobject("@function.inner", "textobjects")
	end, "Select inner function")

	set({ "x", "o" }, "ac", function()
		select.select_textobject("@class.outer", "textobjects")
	end, "Select outer class")
	set({ "x", "o" }, "ic", function()
		select.select_textobject("@class.inner", "textobjects")
	end, "Select inner class")

	set({ "x", "o" }, "aa", function()
		select.select_textobject("@parameter.outer", "textobjects")
	end, "Select outer parameter")
	set({ "x", "o" }, "ia", function()
		select.select_textobject("@parameter.inner", "textobjects")
	end, "Select inner parameter")

	set({ "x", "o" }, "ai", function()
		select.select_textobject("@conditional.outer", "textobjects")
	end, "Select outer conditional")
	set({ "x", "o" }, "ii", function()
		select.select_textobject("@conditional.inner", "textobjects")
	end, "Select inner conditional")

	set({ "x", "o" }, "al", function()
		select.select_textobject("@loop.outer", "textobjects")
	end, "Select outer loop")
	set({ "x", "o" }, "il", function()
		select.select_textobject("@loop.inner", "textobjects")
	end, "Select inner loop")

	-- TODO: Find better keymap for that
	-- set({ "x", "o" }, "ab", function()
	-- 	select.select_textobject("@block.outer", "textobjects")
	-- end, "Select outer block")
	-- set({ "x", "o" }, "ib", function()
	-- 	select.select_textobject("@block.inner", "textobjects")
	-- end, "Select inner block")

	set({ "x", "o" }, "a/", function()
		select.select_textobject("@comment.outer", "textobjects")
	end, "Select outer comment")
	set({ "x", "o" }, "i/", function()
		select.select_textobject("@comment.inner", "textobjects")
	end, "Select inner comment")

	set({ "x", "o" }, "as", function()
		select.select_textobject("@local.scope", "locals")
	end, "Select scope")
end

function M.telescope(builtin)
	-- FILES
	set("n", "<leader>fP", builtin.find_files, "find files");
	set("n", "<leader>fp", builtin.git_files, "find files in git repo");

	set("n", "<leader>fd", builtin.diagnostics, "Find diagnostics");

	set("n", "\\\\", builtin.buffers, "List open buffers");

	set("n", "<leader>fr", builtin.oldfiles, "find recent files");
	-- TEXT
	set("n", "<leader>fg", builtin.live_grep, "find Grep");
	-- SPELL
	set("n", "zs", builtin.spell_suggest, "spell suggestions");
	-- GIT
	set("n", "<leader>gc", builtin.git_commits, "git commits");
	set("n", "<leader>gC", builtin.git_bcommits, "git commits (buffer)");
	set("n", "<leader>gb", builtin.git_branches, "git branches");
	set("n", "<leader>gs", builtin.git_status, "git status");
	set("n", "<leader>gS", builtin.git_stash, "git stash");
	-- LSP
	set("n", "<leader>lr", builtin.lsp_references, "LSP references");
	set("n", "<leader>ld", builtin.lsp_definitions, "LSP definitions");
	set("n", "<leader>lD", builtin.lsp_type_definitions, "LSP type definitions");
	set("n", "<leader>li", builtin.lsp_implementations, "LSP implementations");
	set("n", "<leader>ls", builtin.lsp_document_symbols, "LSP document symbols");
	set("n", "<leader>lS", builtin.lsp_workspace_symbols, "LSP workspace symbols");
	set("n", "<leader>lw", builtin.lsp_dynamic_workspace_symbols, "LSP dynamic workspace symbols");
	set("n", "<leader>le", builtin.diagnostics, "LSP diagnostics");
end

-- TODO: Review that keymaps
function M.todo_comments()
	set("n", "<leader>tl", "<cmd>TodoTelescope<cr>", "list all labels");
	set("n", "<leader>tfl", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG,FIXIT,ISSUE,ERR<cr>", "list all FIXME labels");
	set("n", "<leader>ttl", "<cmd>TodoTelescope keywords=TODO,LATER<cr>", "list all TODO labels");
	set("n", "<leader>twl", "<cmd>TodoTelescope keywords=WARN,WARNING,XXX<cr>", "list all WARN labels");
	set("n", "<leader>til", "<cmd>TodoTelescope keywords=NOTE,INFO<cr>", "list all NOTE labels");
	set("n", "<leader>tol", "<cmd>TodoTelescope keywords=PERF,OPTIM,PERFORMANCE,OPTIMIZE<cr>", "list all PERF labels");
	set("n", "<leader>tel", "<cmd>TodoTelescope keywords=TEST,TESTING,PASSED,FAILED<cr>", "list all TEST labels");

	set("n", "<leader>tn", function() require("todo-comments").jump_next() end, "Next label");
	set("n", "<leader>tp", function() require("todo-comments").jump_prev() end, "Previous label");

	set("n", "<leader>tfn",
		function() require("todo-comments").jump_next({ keywords = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE", "ERR" } }) end,
		"Next FIXME label");
	set("n", "<leader>tfp",
		function() require("todo-comments").jump_prev({ keywords = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE", "ERR" } }) end,
		"Prev FIXME label");

	set("n", "<leader>ttn", function() require("todo-comments").jump_next({ keywords = { "TODO", "LATER" } }) end,
		"Next TODO label");
	set("n", "<leader>ttp", function() require("todo-comments").jump_prev({ keywords = { "TODO", "LATER" } }) end,
		"Prev TODO label");

	set("n", "<leader>twn",
		function() require("todo-comments").jump_next({ keywords = { "WARN", "WARNING", "XXX" } }) end, "Next WARN label");
	set("n", "<leader>twp",
		function() require("todo-comments").jump_prev({ keywords = { "WARN", "WARNING", "XXX" } }) end, "Prev WARN label");

	set("n", "<leader>tin", function() require("todo-comments").jump_next({ keywords = { "NOTE", "INFO" } }) end,
		"Next NOTE label");
	set("n", "<leader>tip", function() require("todo-comments").jump_prev({ keywords = { "NOTE", "INFO" } }) end,
		"Prev NOTE label");

	set("n", "<leader>ton",
		function() require("todo-comments").jump_next({ keywords = { "PERF", "OPTIM", "PERFORMANCE", "OPTIMIZE" } }) end,
		"Next PERF label");
	set("n", "<leader>top",
		function() require("todo-comments").jump_prev({ keywords = { "PERF", "OPTIM", "PERFORMANCE", "OPTIMIZE" } }) end,
		"Prev PERF label");

	set("n", "<leader>ten",
		function() require("todo-comments").jump_next({ keywords = { "TEST", "TESTING", "PASSED", "FAILED" } }) end,
		"Next TEST label");
	set("n", "<leader>tep",
		function() require("todo-comments").jump_prev({ keywords = { "TEST", "TESTING", "PASSED", "FAILED" } }) end,
		"Prev TEST label");
end

function M.auto_session()
	set("n", "<leader>ss", "<cmd>AutoSession save<CR>", "Save session");
	-- set("n", "<leader>sr", "<cmd>AutoSession restore<CR>", "Restore session");
	set("n", "<leader>sd", "<cmd>AutoSession delete<CR>", "Delete session");
end

function M.lsp_attach(bufnr)
	local function buf_set(mode, keymap, what, desc)
		set(mode, keymap, what, desc, { buffer = bufnr });
	end

	-- TOGGLE DIAGNOSTICS
	buf_set("n", "td", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end, "toggle diagnostics");
	-- TOGGLE INLAY HINTS (0.10+)
	buf_set("n", "th", function()
		local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
		vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
	end, "toggle inlay hints")
	-- TOGGLE CODELENS
	buf_set("n", "tl", function()
		vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = bufnr }));
	end, "toggle codelens")

	-- DOCUMENTATION
	buf_set("n", "K", vim.lsp.buf.hover, "show hover documentation")
	buf_set("n", "<C-k>", vim.lsp.buf.signature_help, "show signature help")

	-- ACTIONS
	buf_set("n", "<leader>pr", vim.lsp.buf.rename, "rename symbol")
	buf_set("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
	buf_set("n", "<leader>cf", function()
		vim.lsp.buf.format({ async = true })
	end, "format document")

	-- NAVIGATION
	buf_set("n", "gd", vim.lsp.buf.definition, "go to definition")
	buf_set("n", "gD", vim.lsp.buf.declaration, "go to declaration")
	buf_set("n", "gi", vim.lsp.buf.implementation, "go to implementation")
	buf_set("n", "gr", vim.lsp.buf.references, "show references")
	buf_set("n", "gt", vim.lsp.buf.type_definition, "go to type definition")

	-- DIAGNOSTICS
	buf_set("n", "<leader>ce", vim.diagnostic.open_float, "show diagnostic")

	buf_set("n", "<leader>cl", vim.lsp.codelens.run, "run code lens")




	-- buf_set("n", "<leader>cq", vim.diagnostic.setloclist, "diagnostics to loclist")
	-- WORKSPACE
	-- buf_set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
	-- buf_set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
	-- buf_set("n", "<leader>wl", function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, "list workspace folders")
end

function M.sniprun()
	set("n", "<leader>dr", "<cmd>SnipRun<CR>", "Run under cursor")
	set("v", "<leader>dr", ":'<,'>SnipRun<CR>", "Run selection")
	set("n", "<leader>dc", "<cmd>SnipClose<CR>", "Run selection")
end

set({ "n", "i" }, "<C-k>", "<C-b>", "Scroll docs up");
set({ "n", "i" }, "<C-j>", "<C-f>", "Scroll docs down");

return M;
