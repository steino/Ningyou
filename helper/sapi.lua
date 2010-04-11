require"wsapi.response"

local r = wsapi.response.new()

return {
	Response = {
		contenttype = function(header)
			r["Content-Type"] = header
		end,
		errorlog = function(msg, errlevel)
			io.stderr:write(msg)
		end,
		header = function(header, value)
			if r[header] then
				if type(r[header]) == "table" then
					table.insert(r[header], value)
				else
					r[header] = { r[header], value}
				end
			else
				r[header] = value
			end
		end,
		redirect = function(url)
			r.status = 302
			r.headers["Location"] = url
		end,
		write = function(...)
			r:write({...})
		end,
	}
}
