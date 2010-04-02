return function(template)
	local filename = "templates/" .. template
	local file = io.open(filename)

	if file then
		return file:read("*all"):sub(1, -2)
	else
		return nil
	end
end
