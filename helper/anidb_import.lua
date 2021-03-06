local x = os.clock()

require"helper.mysql"

print"Downloading latest titles file from anidb.net:"
os.execute"wget -N http://anidb.net/api/animetitles.dat.gz"

print"Extracting file:"
os.execute"zcat -v animetitles.dat.gz > animetitles.dat"

local db = ningyou.mysql
local up, ins, up_c, updates = 0, 0, 0, {}
local run_update, error_update, run_import, error_import

local check = db:prepare"select animeid, language, title from nin_titles_anime"
local import, im_error = db:prepare"insert into nin_titles_anime (animeid, title, language) values (?,?,?)"
local update, up_error = db:prepare"update nin_titles_anime set title = ?, language = ? where animeid = ?"
local history = db:prepare"insert into nin_history (userid, showtype, showid, event, value) values (?,?,?,?,?)"

check:execute()

io.write"\nParsing file: "

local titles = loadfile"parse.lua"()

print"Done."

io.write"\nChecking for existing titles in the database: "

for row in check:rows(true) do
	if not updates[row["animeid"]] then updates[row["animeid"]] = {} end
	if titles[row["animeid"]] then
		if titles[row["animeid"]][row["language"]] then
			updates[row["animeid"]][row["language"]] = row["title"]
			up_c = up_c + 1
		end
	end
end

check:close()

print(up_c .. " titles found.")

io.write"Inserting and updating titles: "

for id, t in pairs(titles) do
	for lang, title in pairs(t) do
		if updates[id] and updates[id][lang] then
			if not update then print("Could not update \"" .. title.. "\": ".. up_error) else
				if title ~= updates[id][lang] then
					run_update, error_update = update:execute(title, lang, id)
					if not run_update then print("Could not update \"" .. title .. "\": ".. error_update) else up = up + 1 end
				end
			end
		else
			if not import then print("Could not import \"" .. title.. "\": ".. im_error) else
				run_import, error_import = import:execute(id, title, lang)
				if not run_import then print("Could not import \"" .. title .. "\": ".. error_import) else ins = ins + 1 end
			end
		end
	end
end

print(up .. " updated, " .. ins .. " inserted.")

run_history, error_history = history:execute("admin", "anime", "NULL", "import_anidb_titles", ins.. ";"..up)

io.write"Commiting changes to database: "
db:commit()
print"Done."

import:close()
update:close()
up, ins = nil, nil
updates = nil
update_count = nil

print(string.format("Elapsed time: %.2f", os.clock() - x))
