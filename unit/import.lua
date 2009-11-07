local import = require"modules.import"

local userid = 2
local file = getenv("HOME")."/animelist.xml"

import.myanimelist(userid, file)
