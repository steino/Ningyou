local cgi = require"helper.cgi"
local template = require"helper.template"
local post = cgi:Post(io.stdin, os.getenv"CONTENT_LENGTH")

ningyou.template = "default"

tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "" end)
tags.Register("content", function() 
	if post then
		return post["login"]
	else
		return tags.Render(template"login")
	end
end)
