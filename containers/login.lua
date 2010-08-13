local cgi = require"helper.cgi"
local post = cgi:Post(io.stdin, _ENV("CONTENT_LENGHT"))

ningyou.template = "default"

tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "" end)
tags.Register("content", function() return post["login"] end)
