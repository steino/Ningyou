require'helper.mysql'
local titles = loadfile(os.getenv("HOME").."/animeTitles.lua")()
local up, ins = 0, 0
local updates = {}
local update_count = 0
local run_update, error_update, run_import, error_import

local check = _DB:prepare('select id from nin_data_anime')
local import = _DB:prepare('insert into nin_titles_anime_anidb (id, title, language) values (?,?,?)')
local update = _DB:prepare("update nin_titles_anime_anidb set title = '?', language = '?' where animeid = ?")

check:execute()
_DB:commit()

for row in check:rows(true) do
	if titles[row["id"]] then
		updates[row["id"]] = "true"
		update_count = update_count + 1
	end
end

check:close()

for id, t in pairs(titles) do
	if updates[id] then
		for lang, title in pairs(t) do
			run_update, error_update = update:execute(title, lang, id)
			if not run_update then print("Could not update \"" .. title .. "\": ".. error_update) end
		end
	else
		for lang, title in pairs(t) do
			run_import, error_import = import:execute(id, title, lang)
			if not run_update then print("Could not import \"" .. title .. "\": ".. error_import) end
		end
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
