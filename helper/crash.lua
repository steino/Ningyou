-- TODO: Make a table with generic error messages.
-- TODO: Create a error template for said error messages.

local w = io.write
local template = require"helper.template"
local content = ""
local err
local codes = {
	[404] = "Page not found",
}

module("crash", package.seeall)

function error(msg, page)
	if ningyou.mysql then ningyou.mysql:close() end -- Kill mysql object if it exists.

	sapi.setheader()

	if type(msg) == "string" then
		err = msg
		log(msg)
	else
		err = tostring(msg) .. " " .. codes[msg]
	end

	tags.Register("title", function() return "Error Page" end)
	tags.Register("css", function() return "css/test.css" end)
	tags.Register("error", function(err) return "<a>" .. err[1] .. "</a>" end, { err })

	content = content .. tags.Render(template"header")
	content = content .. tags.Render(template"crash")
	content = content .. tags.Render(template"footer")


	return content
end

function log(err)
	if not err then return end
	local date = os.date("%Y-%m-%d %H:%M:%S")
	local file, file_err = io.open("logs/lua-error", "a")
	if file then
		file:write(date .. " - " .. err .. "\n")
		file:close()
		return true
	else
		return nil, file_err
	end
end
