describe("stackmap", function()
	before_each(function()
		require("stackmap").clear()
		--  Make sure not this key mapping when we start
		pcall(vim.keymap.del, "n", "asdfasdf")
	end)

	it("can be required", function()
		require("stackmap")
	end)

	local find_mapping = function(lhs)
		local maps = vim.api.nvim_get_keymap("n")
		for _, value in ipairs(maps) do
			if value.lhs == lhs then
				return value
			end
		end
	end

	local rhs = "echo 'This is a test'"
	local name = "test1"
	local mode = "n"
	local lhs = "asdf"

	it("can push a single mapping", function()
		require("stackmap").push(name, mode, { [lhs .. lhs] = rhs })
		local found = find_mapping(lhs .. lhs)
		assert.are.same(rhs, found.rhs)
	end)

	it("can push multiple mapping", function()
		local lhs1 = lhs .. "1"
		local lhs2 = lhs .. "2"
		local rhs1 = rhs .. "1"
		local rhs2 = rhs .. "2"
		require("stackmap").push(name, mode, {
			[lhs1] = rhs1,
			[lhs2] = rhs2,
		})

		local found1 = find_mapping(lhs1)
		local found2 = find_mapping(lhs2)

		assert.are.same(rhs1, found1.rhs)
		assert.are.same(rhs2, found2.rhs)
	end)

	-- can delete mappings after pop: no existing

	it("can delete mappings after pop: no existing", function()
		require("stackmap").push(name, mode, { [lhs] = rhs })
		local found = find_mapping(lhs)
		assert.are.same(rhs, found.rhs)
		require("stackmap").pop(name, mode)
		found = find_mapping(lhs)
		assert.are.same(nil, found)
	end)
	-- can delete mappings after pop: yes existing
	it("can delete mappings after pop: yes existing", function()
		vim.keymap.set(mode, lhs, "echo 'original mapping'")

		require("stackmap").push(name, mode, { [lhs] = rhs })
		local found = find_mapping(lhs)
		assert.are.same(rhs, found.rhs)
		require("stackmap").pop(name, mode)
		found = find_mapping(lhs)
		assert.are.same("echo 'original mapping'", found.rhs)
	end)
end)
