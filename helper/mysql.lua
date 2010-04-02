local config = loadfile(os.getenv("/home/steino/ningyou.lua")())
require"DBI"

local dbh = assert(DBI.Connect('MySQL', config['db'], config['user'], config['pass'], config['host'], 3306))

if dbh:ping() then
	_DB = dbh
end
