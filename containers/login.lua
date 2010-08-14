local auth = require"helper.auth"
local cgi = require"helper.cgi"
local template = require"helper.template"
local post = cgi:Post(io.stdin, os.getenv"CONTENT_LENGTH")
local check = auth:check()

ningyou.template = "default"

tags.Register("menu", function() return [[
	<ul>
	<li><a href="#">Home</a></li>
	</ul>
	]] end)
tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "" end)
tags.Register("content", function() 
	if post then
		local user, loginerr = auth:login(post["login"], post["pw"])
		if user then
			return "Successfully logged in as: " .. user
		else
			return "Could not log you in because: " .. loginerr .. "<br/><br/><a href='login'>Try again.</a>"
		end
	elseif check then
		return "Already logged in as: " .. check
	else
		return tags.Render(template"login")
	end
end)
