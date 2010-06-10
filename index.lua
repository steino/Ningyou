#!/home/steino/lua/bin/luajit

require"helper.sapi" -- Server API stuff.
require"helper.tags" -- For reading and parsing ningyou tags.

local cgi = require"helper.cgi"
local url = require"helper.url"
local template = require"helper.template"
local _ENV = os.getenv
local _URL = url(_ENV"PATH_INFO" or "/rss/steino/anime/")
local _write = io.write
local _open = io.open
local _load = loadfile


ningyou.POST = cgi:Post(io.stdin, _ENV"CONTENT_LENGHT")
ningyou.QUERY = cgi:Get(_ENV"QUERY_STRING")

local file = "containers/" .. _URL[1] .. ".lua"
local _, fh = pcall(_open, file)

if not fh then
	if ningyou.mysql then ningyou.mysql:close() end
	return _write"404"
end

fh:close()

local _, run, err = pcall(_load, file)

if err then 
	if ningyou.mysql then ningyou.mysql:close() end
	-- Add some kind of debug page here.
	return _write(err) 
end

if not pcall(run) then
	if ningyou.mysql then ningyou.mysql:close() end
	return _write"Something terribly wrong happened"
end

local _, content = pcall(tags.Render, template(_URL[1]))

if not pcall(_write, content) then
	if ningyou.mysql then ningyou.mysql:close() end
	return _write"Something terribly wrong happened"
end

if ningyou.mysql then ningyou.mysql:close() end
