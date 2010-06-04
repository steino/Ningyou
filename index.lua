#!/home/steino/lua/bin/luajit

require"helper.sapi" -- Server API stuff.

local cgi = require"helper.cgi"
local url = require"helper.url"
local _ENV = os.getenv
local _write = io.write
local _open = io.open
local _load = loadfile

ningyou.POST = cgi:Post(io.stdin, _ENV"CONTENT_LENGHT")
ningyou.QUERY = cgi:Get(_ENV"QUERY_STRING")

local file = "containers/" .. url(_ENV"PATH_INFO")[1] .. ".lua"
local _, fh = pcall(_open, file)
if not fh then return "404" end
fh:close()

local _,content = pcall(_load, file)
if not content then return nil, "No content"  end
