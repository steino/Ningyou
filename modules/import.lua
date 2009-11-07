require"helper.mysql"
local utils = require"helper.utils"
local parse = require"helper.xml"
local runupdate, runimport

--
-- myAnimeList
--

local function myanimelist(userid, file)
	local data = parse(file)
	local updates = {}
	local animeids = {}

	local animedata = _DB:prepare("select * from nin_data_anime")
	local check = _DB:prepare("select * from nin_list_anime where userid = ?")
	local import = _DB:prepare("insert into nin_list_anime (userid, animeid, categoryid, episodes) values (?,?,?,?)")
	local update = _DB:prepare("update nin_list_anime set episodes = '?' where id = ?")

	local catergoryid = {
		["Watching"] = 1,
		["Plan to Watch"] = 2,
		["Completed"] = 3,
		["On-Hold"] = 4,
		["Dropped"] = 5, 
}

	local runcheck = check:execute(userid)
	if not runcheck then
		print(runcheck)
	end
	animedata:execute()
	_DB:commit()
	
	for row in check:rows(true) do
		updates[row["animeid"]] = row["id"]
	end

	for row in animedata:rows(true) do
		animeids[row["title"]] = row["id"]
	end

	local function stripcdata(str)
		if type(str) == "string" then
			nstr = string.match(str, "%[CDATA%[(.+)%]%]") or nil
			return nstr or str
		else
			return str
		end
	end

	for i,v in pairs(data[2]) do
		if ( type(v[2]) == "table" ) and ( v[2].label ~= "user_name" ) then
			if updates[animeids[stripcdata(v[2][1])]] then
				runupdate, updaterror = update:execute(tonumber(v[6][1]), updates[animeids[stripcdata(v[2][1])]])
				if not runupdate then
					print(stripcdata(v[2][1]), animeids[stripcdata(v[2][1])], updates[animeids[stripcdata(v[2][1])]], updaterror)
				end
			else
				runinsert, inserterror = import:execute(userid, animeids[stripcdata(v[2][1])], catergoryid[v[14][1]], tonumber(v[6][1]))
				if not runinsert then
					print(stripcdata(v[2][1]), animeids[stripcdata(v[2][1])], updates[animeids[stripcdata(v[2][1])]], inserterror)
				end
				print(runinsert)
			end
		end
		_DB:commit()
	end
end

return { 
	myanimelist = myanimelist,
}
