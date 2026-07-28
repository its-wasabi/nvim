local M = {};

function M.set(mode, keymap, what, desc, opts)
	local local_opts = {}
	local_opts.noremap = true;
	local_opts.silent = true;
	local_opts = opts or {};
	local_opts.desc = desc;

	vim.keymap.set(mode, keymap, what, local_opts);
end

function M.smart_resize(direction)
	local amount = 1;
	return function()
		local count = vim.v.count > 0 and vim.v.count or 1;

		local is_rightmost = vim.fn.winnr('l') == vim.fn.winnr();
		local is_bottommost = vim.fn.winnr('j') == vim.fn.winnr();

		if direction == 'h' then
			vim.cmd(is_rightmost and 'vertical resize +' .. count or 'vertical resize -' .. count);
		elseif direction == 'l' then
			vim.cmd(is_rightmost and 'vertical resize -' .. count or 'vertical resize +' .. count);
		elseif direction == 'k' then
			vim.cmd(is_bottommost and 'resize +' .. count or 'resize -' .. count);
		elseif direction == 'j' then
			vim.cmd(is_bottommost and 'resize -' .. count or 'resize +' .. count);
		end
	end
end

function M.find_git_root(path)
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.shellescape(path) .. " rev-parse --show-toplevel")
		[1];
	if vim.v.shell_error == 0 then
		return git_root;
	end
	return nil;
end

function M.set_pwd(path)
	local ok, _ = pcall(vim.cmd, "cd " .. path);
	if ok then
		M.notify("set pwd to: " .. path, vim.log.levels.INFO, {
			timeout = 3000,
		});
	else
		error("Failed to set pwd: " .. path);
	end
end

return M;
