describe("stackmap", function()
	before_each(function()
		require("stackmap").clear()
		--  Make sure not this key mapping when we start
		pcall(vim.keymap.del, "n", "asdfasdf")
	end)

	it("can be required", function()
		require("stackmap")
	end)

	local find_mapping = function(lhs, rhs)
		local maps = vim.api.nvim_get_keymap("n")
		for _, value in ipairs(maps) do
			if value.lhs == lhs and value.rhs == rhs then
				return true
			end
		end
		return false
	end

	it("push map works", function()
		require("stackmap").push("hello", "n", { ["asdfasdf"] = "abc" })
		local exist = find_mapping("asdfasdf", "abc")
		assert(exist, true)
	end)
end)
