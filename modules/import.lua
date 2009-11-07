require"helper.mysql"
local utils = require"helper.utils"
local parse = require"helper.xml"
local run_update, run_import, error_update, error_import
local title, animeid, episodes, categoryid

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
	local update = _DB:prepare("update nin_list_anime set episodes = ? where id = ?")

	local catergorytoid = {
		["Watching"] = 1,
		["Plan to Watch"] = 2,
		["Completed"] = 3,
		["On-Hold"] = 4,
		["Dropped"] = 5, 
}

	local runcheck, checkerror = check:execute(userid)
	if not runcheck then
		print(checkerror)
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
		title = stripcdata(v[2][1])
		animeid = animeids[v[2][1]]
		catergoryid = catergorytoid(v[14][1])
		episodes = tonumber(v[6][1])
		
		if ( type(v[2]) == "table" ) and ( v[2].label ~= "user_name" ) then
			if animeid then
				if updates[animeid] then
					run_update, error_update = update:execute(episodes, animeid)
					if not run_update then print("Error updating "..title..": " ..error_update) end
				else
					run_importi, error_import = import:execute(userid, animeid, categoryid, episodes)
					if not run_import then print("Error adding "..title..": " ..error_import) end
				end
			else
				print"Anime "..title.." not found"
			end
		end
		_DB:commit()
	end
end

return { 
	myanimelist = myanimelist,
}
