return function(template)
	local filename = "templates/" .. template
	local file = io.open(filename)

	if file then
		local out = file:read("*all"):gsub('\n$', '')
		io.close(file)
		return out
	end
end
