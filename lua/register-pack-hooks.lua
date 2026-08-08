-- TODO: Fix notifications for that
return function(build_hooks)
	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			local cmd = build_hooks[name]

			if cmd and (kind == "install" or kind == "update") then
				local result = vim.system(cmd, { cwd = ev.data.path }):wait()

				vim.schedule(function()
					if result.code == 0 then
						vim.notify(name .. " built successfully!", vim.log.levels.INFO)
					else
						local err = (result.stderr and result.stderr ~= "")
							and vim.trim(result.stderr)
							or "Unknown error (" .. result.code .. ")"

						vim.notify(name .. " build failed: \n\t" .. err, vim.log.levels.ERROR)
					end
				end)
			end
		end
	})
end
