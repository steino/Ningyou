require'helper.mysql'
local utils = require'helper.utils'
local titles = loadfile(os.getenv("HOME").."/animeTitles.lua")()
local up, ins = 0, 0
local updates = {}
local update_count = 0
local run_update, error_update, run_import, error_import

local check = _DB:prepare('select animeid, language from nin_titles_anime_anidb')
local import, im_error = _DB:prepare('insert into nin_titles_anime_anidb (animeid, title, language) values (?,?,?)')
local update, up_error = _DB:prepare('update nin_titles_anime_anidb set title = ?, language = ? where animeid = ?')

check:execute()
_DB:commit()

for row in check:rows(true) do
	if not updates[row["animeid"]] then updates[row["animeid"]] = {} end
	if titles[row["animeid"]][row["language"]] then
		updates[row["animeid"]][row["language"]] = "true"
		update_count = update_count + 1
	end
end

check:close()

--utils.tableprint(updates)

for id, t in pairs(titles) do
	for lang, title in pairs(t) do
		if updates[id] and updates[id][lang] then
			if not update then print ("Could not update \"" .. title.. "\": ".. up_error) else
				run_update, error_update = update:execute(title, lang, id)
				if not run_update then print("Could not update \"" .. title .. "\": ".. error_update) else up = up + 1 end
			end
		else
			if not import then print ("Could not import \"" .. title.. "\": ".. im_error) else
				run_import, error_import = import:execute(id, title, lang)
				if not run_import then print("Could not import \"" .. title .. "\": ".. error_import) else ins = ins + 1 end
			end
		end
	end
end

_DB:commit()
print("There is ".. update_count .. " titles in the update table.")
print("Inserted ".. ins .." rows.")
print("Updated " .. up .." rows.")

import:close()
update:close()
up, ins = nil, nil
updates = nil
update_count = nil
