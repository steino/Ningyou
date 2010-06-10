module("tags", package.seeall)

reg = {}

function Register(tag, func, args)
	reg[tag] = {
		func = func,
		args = args,
	}
end

function Render(layout, args)
	layout = layout:gsub("<nin:(.-)/>", function(tag)
		if reg[tag] then
			if args then
				return reg[tag].func(args)
			else
				return reg[tag].func(reg[tag].args)
			end
		else
			return "Missing tag: " .. tag
		end
	end)

	return layout
end
