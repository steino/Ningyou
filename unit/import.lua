local import = require"modules.import"

local userid = 2
local file = os.getenv("HOME").."/animelist.xml"

local mal_ins, mal_up, notfound = import.myanimelist(userid, file)
local anidb_ins, anidb_up = import.anidb(userid, file)

print("MyAnimeList: " .. mal_ins .. " inserts. " .. mal_up .. " updates.")
print("AniDB: " .. anidb_ins .. " inserts. " .. anidb_up .. " updates.")

table.foreach(notfound, print)
