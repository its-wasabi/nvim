local M = {}

local set = require("utils").set
local make_set_buf = require("utils").make_set_buf
local smart_resize = require("utils").smart_resize
local set_pwd_to_current_dir = require("utils").set_pwd_to_current_dir
local set_pwd_to_git_root = require("utils").set_pwd_to_git_root

set("n", "<Space>p", "<Nop>", "Remove paste operation");
set({ "n", "v" }, "<Space>", "<Nop>", "Remove any action <Space> had", { silent = true });

set({ "n", "v", "o" }, "H", "0", "Move far", { noremap = true, silent = true });
set({ "n", "v", "o" }, "L", "$", "Move far", { noremap = true, silent = true });
set({ "n", "v", "o" }, "J", "G", "Move far", { noremap = true, silent = true });
set({ "n", "v", "o" }, "K", "gg", "Move far", { noremap = true, silent = true });

set("n", "<A-l>", "<cmd>bnext<CR>", "Next buffer");
set("n", "<A-h>", "<cmd>bprevious<CR>", "Last buffer");

set("v", "o", "\"_dP", "Override");

set("n", "vef", "ggVG", "Select entire buffer");

set("v", "<C-k>", ":m '<-2<CR>gv-gv", "Move lines down in visual mode");
set("v", "<C-j>", ":m '>+1<CR>gv-gv", "Move lines down in visual mode");

set("n", "n", "nzz", "Always center next")
set("n", "N", "Nzz", "Always center prev")

set("v", "<", "<gv", "Indent right without removing highlight");
set("v", ">", ">gv", "Indent right without removing highlight");

set("n", "dl", "dd", "Delete line")

set({ "n", "t" }, "<C-s>q", "<cmd>close<CR>", "close current split");
set("n", "<C-s>h", "<C-w>h", "Focus right split");
set("n", "<C-s>l", "<C-w>l", "Focus left split");
set("n", "<C-s>j", "<C-w>j", "Focus down split");
set("n", "<C-s>k", "<C-w>k", "Focus up split");
set("n", "<C-s>p", "<C-w>v", "Split vertical");
set("n", "<C-s>o", "<C-w>s", "Split horizontal");
set("n", "<C-s><", smart_resize('h'), "Resize left");
set("n", "<C-s>>", smart_resize('l'), "Resize right");
set("n", "<C-s>-", smart_resize('j'), "Resize down");
set("n", "<C-s>+", smart_resize('k'), "Resize up");
set("n", "<C-s>r", "<C-w>=", "equalize splits");

set({ "n", "t" }, "<C-t>n", "<cmd>tabnew<CR>", "new tab")
set({ "n", "t" }, "<C-t>q", "<cmd>tabclose<CR>", "close tab")
set("n", "<C-t>l", "<cmd>tabnext<CR>", "next tab")
set("n", "<C-t>h", "<cmd>tabprev<CR>", "prev tab")
set("t", "<C-t>l", "<C-\\><C-n><cmd>tabnext<CR>", "next tab")
set("t", "<C-t>h", "<C-\\><C-n><cmd>tabprev<CR>", "prev tab")
set("n", "<C-t>mh", "<cmd>tabmove -1<CR>", "move tab left")
set("n", "<C-t>ml", "<cmd>tabmove +1<CR>", "move tab right")
for i = 1, 9 do
	set("n", "<C-t>" .. i, "<cmd>tabn " .. i .. "<CR>", "go to tab " .. i)
	set("t", "<C-t>" .. i, "<C-\\><C-n><cmd>tabn " .. i .. "<CR>", "go to tab " .. i)
end

set("n", "<leader>fe", vim.cmd.Ex, "Open NetRw");

set("n", "tz", function()
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

set("n", "<leader>cD", function()
	set_pwd_to_current_dir()
end, "set pwd to current file directory", { silent = false });
set("n", "<leader>cd", function()
	set_pwd_to_git_root()
end, "set pwd to git root", { silent = false });


if vim.g.neovide then
	local change_scale_factor = function(factor)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * factor
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

M.blink = {
	["<C-p>"]     = { "select_prev", "fallback" },
	["<C-n>"]     = { "select_next", "fallback" },
	["<C-e>"]     = { "hide" },
	["<S-Tab>"]   = { "select_and_accept" },
	["<C-Space>"] = { "show" },
	["<C-k>"]     = { "scroll_documentation_up", "fallback" },
	["<C-j>"]     = { "scroll_documentation_down", "fallback" },
}

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
	set("n", "<leader>fP", builtin.find_files, "find files");
	set("n", "<leader>fp", function()
		local ok = pcall(builtin.git_files);
		if not ok then
			vim.notify("Not in a git repo", vim.log.levels.INFO);
			builtin.find_files();
		end
	end, "find files in git repo");

	set("n", "<leader>fd", builtin.diagnostics, "Find diagnostics");

	set("n", "\\\\", builtin.buffers, "List open buffers");

	set("n", "<leader>fr", builtin.oldfiles, "find recent files");
	set("n", "<leader>fg", builtin.live_grep, "find Grep");
	set("n", "zs", builtin.spell_suggest, "spell suggestions");
	set("n", "<leader>gc", builtin.git_commits, "git commits");
	set("n", "<leader>gC", builtin.git_bcommits, "git commits (buffer)");
	set("n", "<leader>gb", builtin.git_branches, "git branches");
	set("n", "<leader>gs", builtin.git_status, "git status");
	set("n", "<leader>gS", builtin.git_stash, "git stash");

	set("n", "<leader>lr", builtin.lsp_references, "LSP references");
	set("n", "<leader>ld", builtin.lsp_definitions, "LSP definitions");
	set("n", "<leader>lD", builtin.lsp_type_definitions, "LSP type definitions");
	set("n", "<leader>li", builtin.lsp_implementations, "LSP implementations");
	set("n", "<leader>ls", builtin.lsp_document_symbols, "LSP document symbols");
	set("n", "<leader>lS", builtin.lsp_workspace_symbols, "LSP workspace symbols");
	set("n", "<leader>lw", builtin.lsp_dynamic_workspace_symbols, "LSP dynamic workspace symbols");
	set("n", "<leader>le", builtin.diagnostics, "LSP diagnostics");
end

-- TOOD: Unify that into single method
function M.persistence(persistence, picker)
	set("n", "<leader>sr", function()
		persistence.load({ last = true });
	end, "Session restore");

	set("n", "<leader>sp", function()
		picker();
	end, "Session select");

	set("n", "<leader>sd", function()
		persistence.stop();
	end, "Session delete");
end

function M.persistence_picker(map, delete_session)
	map("i", "<C-d>", delete_session)
	map("n", "<C-d>", delete_session)
end

function M.todo_comments()
	set("n", "<leader>ml", "<cmd>TodoTelescope<cr>", "list all labels");
	set("n", "<leader>mfl", "<cmd>TodoTelescope keywords=FIX,FIXME,BUG,FIXIT,ISSUE,ERR<cr>", "list all FIXME labels");
	set("n", "<leader>mtl", "<cmd>TodoTelescope keywords=TODO,LATER<cr>", "list all TODO labels");
	set("n", "<leader>mwl", "<cmd>TodoTelescope keywords=WARN,WARNING,XXX<cr>", "list all WARN labels");
	set("n", "<leader>mil", "<cmd>TodoTelescope keywords=NOTE,INFO<cr>", "list all NOTE labels");
	set("n", "<leader>mol", "<cmd>TodoTelescope keywords=PERF,OPTIM,PERFORMANCE,OPTIMIZE<cr>", "list all PERF labels");
	set("n", "<leader>mel", "<cmd>TodoTelescope keywords=TEST,TESTING,PASSED,FAILED<cr>", "list all TEST labels");

	set("n", "<leader>mn", function() require("todo-comments").jump_next() end, "Next label");
	set("n", "<leader>mp", function() require("todo-comments").jump_prev() end, "Previous label");

	set("n", "<leader>mfn",
		function() require("todo-comments").jump_next({ keywords = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE", "ERR" } }) end,
		"Next FIXME label");
	set("n", "<leader>mfp",
		function() require("todo-comments").jump_prev({ keywords = { "FIX", "FIXME", "BUG", "FIXIT", "ISSUE", "ERR" } }) end,
		"Prev FIXME label");

	set("n", "<leader>mtn", function() require("todo-comments").jump_next({ keywords = { "TODO", "LATER" } }) end,
		"Next TODO label");
	set("n", "<leader>mtp", function() require("todo-comments").jump_prev({ keywords = { "TODO", "LATER" } }) end,
		"Prev TODO label");

	set("n", "<leader>mwn",
		function() require("todo-comments").jump_next({ keywords = { "WARN", "WARNING", "XXX" } }) end, "Next WARN label");
	set("n", "<leader>mwp",
		function() require("todo-comments").jump_prev({ keywords = { "WARN", "WARNING", "XXX" } }) end, "Prev WARN label");

	set("n", "<leader>min", function() require("todo-comments").jump_next({ keywords = { "NOTE", "INFO" } }) end,
		"Next NOTE label");
	set("n", "<leader>mip", function() require("todo-comments").jump_prev({ keywords = { "NOTE", "INFO" } }) end,
		"Prev NOTE label");

	set("n", "<leader>mon",
		function() require("todo-comments").jump_next({ keywords = { "PERF", "OPTIM", "PERFORMANCE", "OPTIMIZE" } }) end,
		"Next PERF label");
	set("n", "<leader>mop",
		function() require("todo-comments").jump_prev({ keywords = { "PERF", "OPTIM", "PERFORMANCE", "OPTIMIZE" } }) end,
		"Prev PERF label");

	set("n", "<leader>men",
		function() require("todo-comments").jump_next({ keywords = { "TEST", "TESTING", "PASSED", "FAILED" } }) end,
		"Next TEST label");
	set("n", "<leader>mep",
		function() require("todo-comments").jump_prev({ keywords = { "TEST", "TESTING", "PASSED", "FAILED" } }) end,
		"Prev TEST label");
end

function M.lsp_attach(bufnr)
	local set_buf = make_set_buf(bufnr)

	set_buf("n", "td", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end, "toggle diagnostics");
	set_buf("n", "th", function()
		local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
		vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
	end, "toggle inlay hints")
	set_buf("n", "tl", function()
		vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = bufnr }));
	end, "toggle codelens")

	set_buf("n", "<C-k>", vim.lsp.buf.hover, "show hover documentation")

	set_buf("n", "<leader>pr", vim.lsp.buf.rename, "rename symbol")
	set_buf("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
	set_buf("n", "<leader>cf", function()
		vim.lsp.buf.format({ async = true })
	end, "format document")

	set_buf("n", "gd", vim.lsp.buf.definition, "go to definition")
	set_buf("n", "gD", vim.lsp.buf.declaration, "go to declaration")
	set_buf("n", "gi", vim.lsp.buf.implementation, "go to implementation")
	set_buf("n", "gr", vim.lsp.buf.references, "show references")
	set_buf("n", "gt", vim.lsp.buf.type_definition, "go to type definition")

	set_buf("n", "<C-e>", vim.diagnostic.open_float, "show diagnostic")

	-- buf_set("n", "<leader>cq", vim.diagnostic.setloclist, "diagnostics to loclist")
	-- WORKSPACE
	-- buf_set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
	-- buf_set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
	-- buf_set("n", "<leader>wl", function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, "list workspace folders")
end

return M
