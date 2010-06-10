local template = require"helper.template"
local url = require"helper.url"
local items = ""
local _ENV = os.getenv
local _URL = url(_ENV"PATH_INFO" or "/rss/steino/anime")
local content = ""

tags.Register("ctitle", function() return _URL[2].. "'s " .. _URL[3] .. "list" end)
tags.Register("clink", function() return "http://ningyou.ixo.no/list/".._URL[2].."/".._URL[3] end)
tags.Register("cdesc", function() return _URL[2].."'s " .. _URL[3] .. "list" end)

tags.Register("itemtitle", function(title) return title[1] end)
tags.Register("itemlink", function(link) return link[2] end)
tags.Register("itemdesc", function(desc) return desc[3] end)

tags.Register("items", function()
	for i = 1, 4 do
		items = items .. "\n" .. tags.Render(template"rss.item", { _URL[3] .. " item " .. i, "http://ningyou.ixo.no/rss/" .. i, "This is test item nr #" .. i })
	end
	return items
end)
