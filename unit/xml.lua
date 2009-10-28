local parse = require"helper.xml"
local data = parse"unit/xmldata.xml"

local function stripcdata(str)
	if type(str) == "string" then
		nstr = string.match(str, "%[CDATA%[(.+)%]%]") or nil
		return nstr or str
	else
		return str
	end
end

io.write"Running test #1: "
assert(stripcdata(data[1][2][1]) == "Zoku Sayonara Zetsubou Sensei")
assert(tonumber(stripcdata(data[1][6][1])) == 0)
assert(stripcdata(data[1][14][1]) == "Plan to Watch")
print"Done"
