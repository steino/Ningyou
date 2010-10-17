local auth = require"helper.auth"
local user, userid, accessid, accessname = auth:check()
local _ENV = os.getenv
local url = require"helper.url"
local _URL = url(_ENV"PATH_INFO" or "/")
local list

ningyou.template = "default"

-- SQL
require"helper.mysql"
local db = ningyou.mysql
local list_data, list_err = db:prepare"select l.animeid, l.episodes, d.episodes as totaleps, t.title from nin_list_anime as l, nin_data_anime as d, nin_titles_anime as t where t.animeid = l.animeid AND d.id = l.animeid AND t.language = ? AND l.userid = ?"
local sum, sum_err = db:prepare"select SUM(episodes) from nin_list_anime where userid = ?"

local menu = tags.RenderMenu()
tags.Register("menu", function() return menu end)
tags.Register("header", function() return "<h1 id=\"title\">Ningyou</h1>" end)
tags.Register("title", function() return "Ningyou" end)
tags.Register("css", function() return "/ningyou/css/test.css" end)
tags.Register("content", function()
	if _URL[3] then
		local userid = auth:usertoid(_URL[3])
		if not userid then return "No user with the name: " .. _URL[3] end
		local get, get_error = list_data:execute("main", userid)
		if get_error then return get_error end

		sum:execute(userid)
		local sum_eps = sum:fetch(false)
		local count = list_data:rowcount()
		
		list = [[
			<table id="stats" border="0" cellspacing="0" cellpadding="0">
				<tr><td>Total Shows: </td><td>]] .. count .. [[</td><td>Total Episodes: </td><td>]] .. sum_eps[1] .. [[</td></tr>
			</table>
		]]
		list = list .. "<table id=\"list\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n"
		list = list .. "<tr><th><a href=\"#\"> + Add title...</a></th></tr>\n"
		for row in list_data:rows(true) do
			list = list .. "<tr><td><a href=\"http://anidb.net/a" .. row["animeid"] .. "\">" .. row["title"] .. "</a></td><td>" .. row["episodes"] .. " / " .. row["totaleps"] .. "</td></tr>\n"
		end
		list = list .. "</table"

		return list
	elseif _URL[2] and (type(userid) == "number") then
		local get, get_error = list_data:execute("main", userid)
		if get_error then return get_error end

		sum:execute(userid)
		local sum_eps = sum:fetch(false)
		local count = list_data:rowcount()
		
		list = [[
			<table id="stats" border="0" cellspacing="0" cellpadding="0">
				<tr><td>Total Shows: </td><td>]] .. count .. [[</td><td>Total Episodes: </td><td>]] .. sum_eps[1] .. [[</td></tr>
			</table>
		]]
		list = list .. "<table id=\"list\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\n"
		list = list .. "<tr><th><a href=\"#\"> + Add title...</a></th></tr>\n"
		for row in list_data:rows(true) do
			list = list .. "<tr><td><a href=\"http://anidb.net/a" .. row["animeid"] .. "\">" .. row["title"] .. "</a></td><td>" .. row["episodes"] .. " / " .. row["totaleps"] .. "</td></tr>\n"
		end
		list = list .. "</table"

		return list
	elseif _URL[2] then
		return "No user specified"
	elseif type(userid) == "number" then
		return "List select: <br/><br/><a href=\"/ningyou/list/anime\">Anime</a>"
	else
		return "No user specified"
	end
end)
