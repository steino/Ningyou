local import = require"modules.import"

local mal_userid = 2
local mal_file = os.getenv("HOME").."/animelist.xml"

local anidb_userid = 0
local anidb_file = os.getenv("HOME").."/anidb.xml"

local mal_ins, mal_up, notfound = import.myanimelist(mal_userid, mal_file)
local anidb_ins, anidb_up = import.anidb(anidb_userid, anidb_file)

print("MyAnimeList: " .. mal_ins .. " inserts. " .. mal_up .. " updates.")
print("AniDB: " .. anidb_ins .. " inserts. " .. anidb_up .. " updates.")

table.foreach(notfound, print)
