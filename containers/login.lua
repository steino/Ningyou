local auth = require"helper.auth"
local cgi = require"helper.cgi"
local template = require"helper.template"
local post = cgi:Post(io.stdin, os.getenv"CONTENT_LENGTH")
local check, accessid, accessname = auth:check()

ningyou.template = "default"

tags.Register("menu", function() 
	local out = [[
	<ul>
	<li><a href="home">Home</a></li>
	]]
	if accessid >= 99 then
		out = out .. "<li><a href=\"admin\">Admin</a></li>"
	end
	return out .. "</ul>"
end)
tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "css/test.css" end)
tags.Register("content", function() 
	if post then
		local user, loginerr = auth:login(post["login"], post["pw"])
		if user then
			return "Successfully logged in as: " .. user
		else
			return "Could not log you in because: " .. loginerr .. "<br/><br/><a href='login'>Try again.</a>"
		end
	elseif check then
		return "Already logged in as: " .. check .. " (".. accessname .. ")"
	else
		return "<div align='center'>" .. tags.Render(template"login") .. "</div>"
	end
end)
