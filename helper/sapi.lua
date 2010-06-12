local w = io.write

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

function setheader(header)
	if setheaders then return end
	header = header or sapi.headers
	for n,v in pairs(header) do
		if type(v) == "table" then
			for _,t in pairs(v) do
				pcall(w, n .. ": " .. t .. "\r\n")
			end
		else
			pcall(w, n .. ": " .. v .."\r\n")
		end
	end
	w"\r\n"

	setheaders = "true"
end
