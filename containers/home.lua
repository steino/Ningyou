ningyou.template = "default"


egister("menu", function() 
	local out = [[
		<ul>
		<li><a href="home">Home</a></li>
	]]
	if type(accessid) == "number" and accessid >= 99 then
		out = out .. "<li><a href=\"admin\">Admin</a></li>"
	end
	return out .. "</ul>"
end)

tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "css/test.css" end)
tags.Register("content", function() return "<div align='center'><a>Coming soon&#153;</a></div>" end)
