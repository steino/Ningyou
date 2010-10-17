local auth = require"helper.auth"
local cgi = require"helper.cgi"
local template = require"helper.template"
local post = cgi:Post(io.stdin, os.getenv"CONTENT_LENGTH")
local user, userid, accessid, accessname = auth:check()

ningyou.template = "default"

local referer = os.getenv("HTTP_REFERER")

if post and post["referer"] then
	referer = post["referer"]
	if referer:match"localhost" or referer:match"ningyou" then
		referer = string.gsub(referer, "+", " ")
		referer = string.gsub(referer, "%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end)
		referer = string.gsub(referer, "\r\n", "\n")
	else
		referer = "home"
	end
end

local menu = tags.RenderMenu()

tags.Register("menu", function() return menu end)
tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "css/test.css" end)
tags.Register("referer", function() return (referer or "home") end)
tags.Register("content", function()
	if post then
		local user, loginerr = auth:login(post["login"], post["pw"])
		if user then
			return "Successfully logged in as: " .. user .. "<br/><br/><a href=\"" .. referer .. "\">Return</a>"
		else
			return "Could not log you in because: " .. loginerr .. "<br/><br/><a href='login'>Try again.</a>"
		end
	elseif user then
		return "Already logged in as: " .. user .. " (".. accessname .. ")"
	else
		return "<div align='center'>" .. tags.Render(template"login") .. "</div>"
	end
end)
