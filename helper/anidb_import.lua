require'helper.mysql'
local titles = loadfile(os.getenv("HOME").."/animeTitles.lua")()
local up, ins = 0, 0
local updates = {}
local update_count = 0

local function check_anime()
	local check = _DB:prepare('select id from nin_data_anime')
	check:execute()
	_DB:commit()
	for row in check:rows(true) do
		if titles[row["id"]] then
			updates[row["id"]] = "true"
			update_count = update_count + 1
		end
	end
	check:close()
end

local insert = _DB:prepare('insert into nin_data_anime (id, title, official_title) values (?,?,?)')
local update = _DB:prepare("update nin_data_anime set title = '?', official_title = '?' where id = ?")

check_anime()

for id, t in pairs(titles) do
	if updates[id] then
		update:execute(t["title"], t[1] or "No title", id)
		up = up + 1
	else
		insert:execute(id, t["title"], t[1] or "No title")
		ins = ins + 1
	end
end

_DB:commit()
print("There is ".. update_count .. " titles in the update table.")
print("Inserted ".. ins .." rows.")
print("Updated " .. up .." rows.")

insert:close()
update:close()
up, ins = nil, nil
updates = nil
update_count = nil
