-- FIXME: For some reason it starts even in non xterm-kitty terminals
-- NOTE: Works only with kitty image protocol
if vim.env.TERM == "xterm-kitty" then
	-- local missing = {}
	-- for _, bin in ipairs({ "node", "convert", "rsvg-convert" }) do
	-- 	if vim.fn.executable(bin) ~= 1 then
	-- 		table.insert(missing, bin)
	-- 	end
	-- end
	--
	-- if #missing > 0 then
	-- 	require("wasabi.util").notify(
	-- 		"Missing dependencies:\n- " .. table.concat(missing, "\n- "),
	-- 		vim.log.levels.ERROR,
	-- 		{ title = "mdmath" }
	-- 	);
	-- 	return;
	-- end

	require("mdmath").setup({
		filetypes = { "markdown" },
		foreground = "Normal",

		-- Hide the text when the equation is under the cursor.
		anticonceal = true,
		-- Hide the text when in the Insert Mode.
		hide_on_insert = true,

		-- Enable dynamic size for non-inline equations.
		dynamic = true,

		-- Configure the scale of dynamic-rendered equations.
		dynamic_scale = 1.0,
		-- Interval between updates (milliseconds).
		update_interval = 400,

		-- Internal scale of the equation images, increase to prevent blurry images when increasing terminal
		-- font, high values may produce aliased images.
		-- WARNING: This do not affect how the images are displayed, only how many pixels are used to render them.
		--          See `dynamic_scale` to modify the displayed size.
		internal_scale = 1.0,
	});
end
