#!/home/steino/lua/bin/luajit

ningyou = {}

require"helper.sapi" -- Server API stuff.
require"helper.tags" -- For reading and parsing ningyou tags.
require"helper.crash"

local config = loadfile("/home/steino/ningyou.lua")()

ningyou.config_path = config['config_path']

local url = require"helper.url"
local template = require"helper.template"
local _ENV = os.getenv
local _URL = url(_ENV"PATH_INFO" or "/")

local page = (_URL[1] or "home")

local file = "containers/".. page ..".lua"
local openfile, fh = pcall(io.open, file)

if openfile and fh then
	fh:close()
else
	return io.write(crash.error(404))
end

local _, run, err = pcall(loadfile, file)

if err then return io.write(crash.error(err, page)) end

if not pcall(run) then
	return io.write(crash.error("Something terribly wrong happened", page))
end

local _, content = pcall(tags.Render, template((ningyou.template or page)))

pcall(sapi.setheader)

if not pcall(io.write, content) then
	return io.write(crash.error("Something terribly wrong happened", page))
end

if ningyou.mysql then ningyou.mysql:close() end
