local tags = {}

return {
	Register = function(self, tag, func, args)
		tags[tag] = {
			func = func,
			args = args,
		}
	end,
	Render = function(self, layout)
		layout = layout:gsub("<nin:(.-)/>", function(tag)
			return tags[tag].func(tags[tag].args)
		end)
	
		return layout
	end,
	tags = tags
}
