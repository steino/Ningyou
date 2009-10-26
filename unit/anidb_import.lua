local titles = loadfile("anidb_import_titles.lua")()
local up, ins = 0,0
local updates = {}
local update_count = 0

local function check_titles()
	for i in pairs(titles) do
		updates[i] = "true"
		update_count = update_count + 1
	end
end

check_titles()

for id, t in pairs(titles) do
	if updates[id] then
		up = up + 1
	else
		ins = ins + 1
	end
end

io.write"Running test #1: "
assert(up == 5000)
assert(ins == 0)
assert(update_count == 5000)
print"Done"
