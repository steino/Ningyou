ningyou.template = "default"

local menu = tags.RenderMenu()

tags.Register("menu", function() return menu end)
tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "css/test.css" end)
tags.Register("content", function() return "<div align='center'><a>Coming soon&#153;</a></div>" end)
