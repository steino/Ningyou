local auth = require"helper.auth"
local user, accessid, accessname = auth:check()

module("tags", package.seeall)

reg = {}
menu = {}

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

function RenderMenu(breaktag, wraptag)
	if type(accessid) == "string" then accessid = 1 end
	local breaktag = breaktag or "li"
	local wraptag = wraptag or "ul"

	local out

	table.sort(menu, function(a,b) return a.weight < b.weight end)

	out = "<"..wraptag..">\n"
	for n, t in pairs(menu) do
		if t.access <= accessid then
			out = out .. "<"..breaktag.."><a href=\""..t.link.."\">"..t.name.."</a></"..breaktag..">\n"
		end
	end
	out = out .. "</"..wraptag..">"

	return out
end

function RegisterMenuItem(name, link, access, weight)
	if name and link then
		local access = access or 1
		local weight = weight or 1

		table.insert(menu, {
			["name"] = name,
			["link"] = link,
			["access"] = access,
			["weight"] = weight,
		})
	else
		return nil
	end
end
