if not _G.ningyou then _G.ningyou = {} end

require"DBI"
local config = loadfile("/home/steino/ningyou.lua")()
local dbh = assert(DBI.Connect('MySQL', config['db'], config['user'], config['pass'], config['host'], 3306))

if dbh:ping() then
	_G.ningyou.mysql = dbh
else
	return nil, "Unable to connect to database"
end
