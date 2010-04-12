module("sapi", package.seeall)

headers = { }

function header(name, value)
	if headers[name] and type(headers[name]) == "table" then 
		table.insert(headers[name], value)
	else
		headers[name] = value
	end
end
