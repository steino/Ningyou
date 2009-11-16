require"helper.mysql"
local MAL = require"data.mal_titles"
local utils = require"helper.utils"
local parse = require"helper.xml"
local run_update, run_import, error_update, error_import
local title, animeid, episodes, cid, weps, eps

local notfound = {}

	local function stripcdata(str)
		if type(str) == "string" then
			nstr = string.match(str, "%[CDATA%[(.+)%]%]") or nil
			return nstr or str
		else
			return str
		end
	end

-- myAnimeList

local function myanimelist(userid, file)
	local data = parse(file)
	local updates = {}
	local animeids = {}
	local up, ins = 0, 0

	local history = _DB:prepare("insert into nin_history (userid, showtype, showid, event, value) values (?,?,?,?,?)")
	local titles = _DB:prepare("select * from nin_titles_anime")
	local check = _DB:prepare("select * from nin_list_anime where userid = ?")
	local import = _DB:prepare("insert into nin_list_anime (userid, animeid, categoryid, episodes) values (?,?,?,?)")
	local update = _DB:prepare("update nin_list_anime set episodes = ? where id = ?")

	local categorytoid = {
		["Watching"] = 1,
		["Plan to Watch"] = 2,
		["Completed"] = 3,
		["On-Hold"] = 4,
		["Dropped"] = 5, 
	}

	local runcheck, checkerror = check:execute(userid)
	if not runcheck then print(checkerror) end
	titles:execute()
	_DB:commit()
	
	for row in check:rows(true) do
		updates[row["animeid"]] = row["id"]
	end

	for row in titles:rows(true) do
		animeids[row["title"]:lower()] = row["animeid"]
	end

	for i,v in pairs(data[2]) do
		if ( type(v[2]) == "table" ) and ( v[2].label ~= "user_name" ) then
			title = stripcdata(v[2][1])
			title = title:gsub("'", "`")
			title = title:gsub("%.$", "")
			title = title:gsub("%s(wo)%s", " o ")
			title = title:gsub("[%s%s]+", " ")
			
			-- Check the MAL table for id's.
			animeid = MAL[title]
			-- Nothing in the MAL table, go for the MySQL database of AniDB titles.
			if not animeid then animeid = animeids[title:lower()] end
			
			cid = categorytoid[v[14][1]] or 0
			episodes = tonumber(v[6][1])

			if animeid then
				if updates[animeid] then
					run_update, error_update = update:execute(episodes, updates[animeid])
					if not run_update then print("Error updating "..title..": " ..error_update.. "\n") else up = up + 1 end
				else
					run_import, error_import = import:execute(userid, animeid, cid, episodes)
					if not run_import then print("Error adding "..title..": " ..error_import.. "\n") else ins = ins + 1 end
				end
			else
				table.insert(notfound, title)
			end
		end
	end

	run_history, error_history = history:execute(userid, "anime", "NULL", "import_mal", ins.. ";"..up)
	if not run_history then print("Error adding history") end
	_DB:commit()

	return ins, up, notfound
end

-- AniDB

local function anidb(userid, file)
	local data = parse(file)
	local updates = {}
	local up, ins = 0, 0

	local history = _DB:prepare("insert into nin_history (userid, showtype, showid, event, value) values (?,?,?,?,?)")
	local check = _DB:prepare("select * from nin_list_anime where userid = ?")
	local import = _DB:prepare("insert into nin_list_anime (userid, animeid, categoryid, episodes) values (?,?,?,?)")
	local update = _DB:prepare("update nin_list_anime set episodes = ? where id = ?")

	local runcheck, checkerror = check:execute(userid)
	if not runcheck then print(checkerror) end

	_DB:commit()

	for row in check:rows(true) do
		updates[row["animeid"]] = row["id"]
	end

	for i,v in pairs(data[2]) do
		if v[1] and v[3] and v[15] then
			animeid = tonumber(stripcdata(v[1][1]))
			eps = tonumber(stripcdata(v[3][1]))
			weps = tonumber(stripcdata(v[15][1]))
			if weps == eps then cid = 3 else cid = 1 end
			if updates[animeid] then
				run_update, error_update = update:execute(weps, updates[animeid])
				if not run_update then print("Error updating "..title..": " ..error_update.. "\n") else up = up + 1 end
			else
				run_import, error_import = import:execute(userid, animeid, cid, weps)
				if not run_import then print("Error adding "..title..": " ..error_import.. "\n") else ins = ins + 1 end
			end
		end
	end

	run_history, error_history = history:execute(userid, "anime", "NULL", "import_anidb", ins.. ";"..up)
	if not run_history then print("Error adding history") end
	_DB:commit()

	return ins, up
end

return {
	myanimelist = myanimelist,
	anidb = anidb, 
}
