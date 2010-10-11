local auth = require"helper.auth"
local user, accessid, accessname = auth:check()

-- Global variables/tables

tags.RegisterMenuItem("Home", "home")
tags.RegisterMenuItem("Admin", "admin", 99, 99)

if user then 
	tags.RegisterMenuItem("Logout", "logout", 1, 91)
	tags.RegisterMenuItem("Dashboard", "dashboard", 1, 90)
else
	tags.RegisterMenuItem("Login", "login", 0, 90)
end

tags.Register("redirect", function() return "" end)
