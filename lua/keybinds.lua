local M = {}
local set = require("utils").set
local smart_resize = require("utils").smart_resize
local set_pwd = require("utils").set_pwd;
local find_git_root = require("utils").find_git_root

set("n", "<Space>p", "<Nop>", "Remove paste operation");
set({ "n", "v" }, "<Space>", "<Nop>", "Remove any action <Space> had", { silent = true });

set({ "n", "v", "o" }, "H", "0", "Move far", { noremap = true, silent = true });
set({ "n", "v", "o" }, "L", "$", "Move far", { noremap = true, silent = true });
set({ "n", "v", "o" }, "J", "G", "Move far", { noremap = true, silent = true });
set({ "n", "v", "o" }, "K", "gg", "Move far", { noremap = true, silent = true });

set("n", "<A-h>", "<cmd>bprevious<CR>", "Last buffer");
set("n", "<A-l>", "<cmd>bnext<CR>", "Next buffer");

set("v", "o", "\"_dP", "Override");

set("n", "vef", "ggVG", "Select entire buffer");

set("v", "<C-k>", ":m '<-2<CR>gv-gv", "Move lines down in visual mode");
set("v", "<C-j>", ":m '>+1<CR>gv-gv", "Move lines down in visual mode");

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
	local current_file = vim.fn.expand("%:p:h");
	if current_file ~= '' then
		set_pwd(current_file);
	else
		notify("failed to set pwd", vim.log.levels.ERROR)
	end
end, "set pwd to current file directory", { silent = false });
set("n", "<leader>cd", function()
	local current_file = vim.fn.expand("%:p:h");
	local git_root = find_git_root(current_file);
	if git_root then
		set_pwd(git_root);
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

function M.lsp_attach()
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




	-- buf_set("n", "<leader>cq", vim.diagnostic.setloclist, "diagnostics to loclist")
	-- WORKSPACE
	-- buf_set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "add workspace folder")
	-- buf_set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "remove workspace folder")
	-- buf_set("n", "<leader>wl", function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, "list workspace folders")
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

return M
