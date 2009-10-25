loadfile"config"
require"DBI"

local dbh = assert(DBI.Connect('MySQL', db, username, password, host, 3306))

