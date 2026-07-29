local persistence = require("persistence")

persistence.setup({
	branch = true,
	need = 3,
})

local pickers = require("telescope.pickers");
local finders = require("telescope.finders");
local conf = require("telescope.config").values;
local actions = require("telescope.actions");
local action_state = require("telescope.actions.state");
local entry_display = require("telescope.pickers.entry_display");

local devicons = require("nvim-web-devicons");

local displayer = entry_display.create({
	separator = "",
	items = {
		{ width = 2 },
		{ remaining = true },
	}
});

local function make_display(entry)
	local icon, icon_highlight = devicons.get_icon(entry.name, "session", { default = true })
	if not icon or icon == devicons.get_default_icon().icon then
		icon = "󰆓 "
		icon_highlight = "DevIconDefault"
	end

	return displayer({
		{ icon, icon_highlight },
		entry.name,
	})
end

local function session_entry_maker(entry)
	local name = vim.fn.fnamemodify(entry, ":t"):gsub("%%", "/"):gsub("%.vim$", "")
	return {
		value = entry,
		name = name,
		display = make_display,
		ordinal = name,
	}
end

local function clean_and_get_sessions()
	local sessions = persistence.list()
	if not sessions then return {} end

	local uv = vim.uv or vim.loop
	local valid_sessions = {}

	for _, session in ipairs(sessions) do
		local file_name = vim.fn.fnamemodify(session, ":t"):gsub("%.vim$", "")

		local dir_part = file_name
		local branch_sep_idx = string.find(dir_part, "%%%%")
		if branch_sep_idx then
			dir_part = string.sub(dir_part, 1, branch_sep_idx - 1)
		end

		local dir_path = dir_part:gsub("%%", "/")

		-- Direct OS-level check
		local stat = uv.fs_stat(dir_path)
		if stat and stat.type == "directory" then
			table.insert(valid_sessions, session)
		else
			-- Delete orphan and DO NOT insert into valid_sessions
			uv.fs_unlink(session)
		end
	end

	return valid_sessions
end

local function session_picker()
	local sessions = clean_and_get_sessions();

	if not sessions or vim.tbl_isempty(sessions) then
		vim.notify("No saved sessions found", vim.log.levels.INFO, { title = "Persistence" })
		return
	end

	pickers.new({}, {
		prompt_title = "Fuzzy Find Sessions",
		finder = finders.new_table({
			results = sessions,
			entry_maker = session_entry_maker,
		}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				if selection and selection.value then
					vim.cmd("silent! only")
					vim.cmd("source " .. vim.fn.fnameescape(selection.value))
					vim.cmd("wincmd = ")
				end
			end)

			local delete_session = function()
				local selection = action_state.get_selected_entry()
				if not selection then
					return
				end

				local current_picker = action_state.get_current_picker(prompt_bufnr)

				current_picker:delete_selection(function(entry)
					local uv = vim.uv or vim.loop
					if uv.fs_unlink(entry.value) then
						vim.notify(
							"Deleted session: " .. entry.name,
							vim.log.levels.INFO,
							{ title = "Persistence" }
						)
					end
				end)
			end

			require("keybinds").persistence_picker(map, delete_session);

			return true
		end,
	}):find()
end

require("keybinds").persistence(persistence, session_picker)
