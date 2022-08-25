local maps = vim.api.nvim_get_keymap("normal")
PT(maps)

local find_mapping = function(maps, lhs)
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

PT(find_mapping(maps, "test"))
