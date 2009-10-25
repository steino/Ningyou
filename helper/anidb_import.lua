require'helper.mysql'
local titles = loadfile(os.getenv("HOME").."/animeTitles.lua")()

local query = _DB:prepare('insert into nin_data_anime (id, title, official_title) values (?,?,?)')

for i, k in pairs(titles) do
	query:execute(tonumber(i), k["title"], k[1])
end

_DB:commit()
query:close()
