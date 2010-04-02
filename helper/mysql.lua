require"DBI"

local config = loadfile("/home/steino/ningyou.lua")()

local dbh = assert(DBI.Connect('MySQL', config['db'], config['user'], config['pass'], config['host'], 3306))

if dbh:ping() then
	_DB = dbh
end
