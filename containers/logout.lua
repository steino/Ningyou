local auth = require"helper.auth"
local logout, lerror = auth:logout()

ningyou.template = "default"

local menu = tags.RenderMenu()

tags.Register("menu", function() return menu end)
tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "css/test.css" end)
tags.Register("content", function()
	if logout then
		return "Sucessfully logged out.<br/><br/><a href=\"home\">Go home.</a>"
	else
		return "You are not logged in, <a href=\"home\">go home.</a>"
	end
end)
