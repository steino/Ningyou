require'helper.mysql'
local titles = loadfile(os.getenv("HOME").."/animeTitles.lua")()
local up, ins = 0, 0
local updates = {}


local function check_anime()
	local check = _DB:prepare('select id from nin_data_anime')
	check:execute()
	_DB:commit()
	for row in check:rows(true) do
		if titles[row["id"]] then
			table.insert(updates, row["id"], "true")
		end
	end
	check:close()
end

local insert = _DB:prepare('insert into nin_data_anime (id, title, official_title) values (?,?,?)')
local update = _DB:prepare("update nin_data_anime set title = '?', official_title = '?' where id = ?")

check_anime()

for i, k in pairs(titles) do
	if updates[tonumber(i)] then
		update:execute(k["title"], k[1], tonumber(i))
		local up = up + 1
	else
		insert:execute(tonumber(i), k["title"], k[1])
		local ins = ins + 1
	end
end

_DB:commit()
print("There is " .. #updates .. " titles in the update table")
print("Inserted ".. ins .." rows.")
print("Updated " .. up .." rows.")

insert:close()
update:close()
up, ins = nil, nil
updates = nil
