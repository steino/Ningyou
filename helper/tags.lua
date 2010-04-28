local tags = {}

return {
	Register = function(self, tag, func, args)
		tags[tag] = {
			func = func,
			args = args,
		}
	end,
	Render = function(self, layout, args)
		layout = layout:gsub("<nin:(.-)/>", function(tag)
			if tags[tag] then
				if args then
					return tags[tag].func(args)
				else
					return tags[tag].func(tags[tag].args)
				end
			end
		end)

		return layout
	end,
	tags = tags
}
