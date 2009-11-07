local import = require"modules.import"

local userid = 2
local file = os.getenv("HOME").."/animelist.xml"

local test = import.myanimelist(userid, file)

table.foreach(test, print)
