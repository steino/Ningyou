local config = loadfile(os.getenv("HOME"].."/ningyou"
require"DBI"

local dbh = assert(DBI.Connect('MySQL', config()[db], config()[user], config()[pass], config()[host], 3306))


