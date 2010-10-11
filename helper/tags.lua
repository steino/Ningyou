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

	out = "<"..wraptag..">\n"
	for n, t in pairs(menu) do
		if t.access <= accessid then
			out = out .. "<"..breaktag.."><a href=\""..t.link.."\">"..t.name.."</a></"..breaktag..">\n"
		end
	end
	out = out .. "</"..wraptag..">"

	return out
end

function RegisterMenuItem(name, link, access, order)
	if name and link then
		local access = access or 1
		local order = order or 1

		-- find first available ordernumber after set order.
		while menu[order] do order = order+1 end

		menu[order] = {
			["name"] = name,
			["link"] = link,
			["access"] = access,
		}
	else
		return nil
	end
end
