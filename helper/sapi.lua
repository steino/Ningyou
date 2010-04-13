module("sapi", package.seeall)

headers = {
	["Content-Type"] = "text/html;charset=utf8",
}

function header(name, value)
	if headers[name] and type(headers[name]) == "table" then 
		table.insert(headers[name], value)
	elseif headers[name] then
		local old = headers[name]
		headers[name] = { old }
		table.insert(headers[name], value)
	else
		headers[name] = value
	end
end
