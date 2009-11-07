local import = require"modules.import"

local userid = 2
local file = os.getenv("HOME").."/animelist.xml"

import.myanimelist(userid, file)
