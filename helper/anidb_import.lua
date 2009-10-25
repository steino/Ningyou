require'helper.mysql'
local titles = loadfile(os.getenv("HOME").."/animeTitles.lua")()

local function check_anime(id)
	local check = _DB:prepare('select id from nin_data_anime where id = ?')
	check:execute(id)
	_DB:commit()
	if check:fetch() then
		check:close()
		return true
	else
		check:close()
		return nil
	end
end

local insert = _DB:prepare('insert into nin_data_anime (id, title, official_title) values (?,?,?)')
local update = _DB:prepare("update nin_data_anime set id = '?', title = '?', official_title = '?'")


for i, k in pairs(titles) do
	if check_anime(i) then
		update:execute(tonumber(i), k["title"], k[1])
	else
		insert:execute(tonumber(i), k["title"], k[1])
	end
end

_DB:commit()
insert:close()
update:close()

io.write("Inserted ".. insert:affected().." rows.")
io.write("Updated " .. update:affected().." rows.")
