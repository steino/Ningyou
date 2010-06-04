if not ningyou then ningyou = {} end

require"DBI"
local config = loadfile("/home/steino/ningyou.lua")()
local dbh = assert(DBI.Connect('MySQL', config['db'], config['user'], config['pass'], config['host'], 3306))

if dbh:ping() then
	ningyou.mysql = dbh
else
	return nil, "Unable to connect to database"
end
