local M = {}

-- M.setup = function(opts)
-- 	print(opts)
-- end

-- local maps = vim.api.nvim_get_keymap("normal")
-- PT(maps)
--
-- { {
--     buffer = 0,
--     expr = 0,
--     lhs = "<C-B>",
--     lnum = 0,
--     mode = "x",
--     noremap = 1,
--     nowait = 0,
--     rhs = "<Cmd>lua Scroll('<C-B>', 1, 1)<CR>",
--     script = 0,
--     sid = -8,
--     silent = 0
--   }, {
--     buffer = 0,
--     expr = 0,
--     functions we need:
--     vim.keymap.set()
--     vim.api.nvim_get_keymap()
local find_mapping = function(maps, lhs)
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

M._stack = {}

M.push = function(name, mode, mappings)
	local maps = vim.api.nvim_get_keymap(mode)
	local existing_maps = {}

	for lhs, rhs in pairs(mappings) do
		local existing = find_mapping(maps, lhs)
		if existing then
			existing_maps[lhs] = existing
		end

		vim.keymap.set(mode, lhs, rhs)
	end

	M._stack[name] = M._stack[name] or {}

	M._stack[name][mode] = {
		existing = existing_maps,
		mappings = mappings,
	}
end

M.pop = function(name, mode)
	local state = M._stack[name][mode]
	for lhs in pairs(state.mappings) do
		if state.existing[lhs] then
			vim.keymap.set(mode, lhs, state.existing[lhs].rhs)
		else
			vim.keymap.del(mode, lhs)
		end
	end
end

M.clear = function()
	M._stack = {}
end

return M
