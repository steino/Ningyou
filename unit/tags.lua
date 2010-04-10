local tags = require"helper.tags"

local tests = {
	{
		"<nin:test1/>",
		function(t)
			io.write"Running test #1: "
			tags:Register("test1", function() return "This is test 1" end)
			local out = assert(tags:Render(t))
			assert(out == "This is test 1")
			print"Done"
		end,
	},
	{
		"<nin:css/>",
		function(t)
			io.write"Running test #2: "
			tags:Register("css", function(css) return "<link rel=\"stylesheet\" type=\"text/css\" href=\"" .. css[1] .. "\" />" end, { "css/test.css" })
			local out = assert(tags:Render(t))
			assert(out == "<link rel=\"stylesheet\" type=\"text/css\" href=\"css/test.css\" />")
			print"Done"
		end,
	},
}

for key, testData in pairs(tests) do
	testData[2](testData[1])
end
