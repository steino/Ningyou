#!/home/haste/lua/haste.ixo.no/bin/lua

local _ENV = os.getenv
local w = io.write
local wln = function(...)
	pcall(w, ...)
	w'\r\n'
end

-- Guess we should move this into the dispatcher.
wln("Content-Type: text/html;charset="utf-8"", "\r\n")

pcall(w, "Swoosh Ningyou~~<br />")
for i, var in ipairs{
	'AUTH_TYPE',
	'CONTENT_LENGTH',
	'CONTENT_TYPE',
	'GATEWAY_INTERFACE',
	'PATH_INFO',
	'PATH_TRANSLATED',
	'QUERY_STRING',
	'REMOTE_ADDR',
	'REMOTE_HOST',
	'REMOTE_IDENT',
	'REMOTE_USER',
	'REQUEST_METHOD',
	'SCRIPT_NAME',
	'SCRIPT_FILENAME',
	'SCRIPT_URL',
	'SCRIPT_URI',
	'SERVER_NAME',
	'SERVER_PORT',
	'SERVER_PROTOCOL',
	'SERVER_SOFTWARE',
} do
	print(string.format('%02d: %s = %s<br />',i, var, _ENV(var) or 'nil'))
end
