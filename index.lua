#!/home/haste/lua/haste.ixo.no/bin/lua

local _ENV = os.getenv
local w = io.write
local wln = function(...)
	return pcall(w,..., '\r\n')
end

-- Guess we should move this into the dispatcher.
wln"Content-Type: text/html"

pcall(w, "Swoosh Ningyou~~")
pcall(w, _ENV"PATH_INFO")
