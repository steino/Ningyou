local auth = require"helper.auth"
local user, accessid, accessname = auth:check()

ningyou.template = "default"

tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "css/test.css" end)
tags.Register("content", function() return check end)
