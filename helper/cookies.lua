if not sapi then return end

local urlcode = require"helper.urlcode"

local function header(...)
	return sapi.header(...) 
end

return {
	Set = function(self, key, value, expire)
		local cookie = key .. "=" .. urlcode:escape(value)
		if expire then
			local t = os.date("!%A, %d-%b-%Y %H:%M:%S GMT", expire)
			cookie = cookie .. "; expires=" .. t
		end
		header("Set-Cookie", cookie)
	end,
	Get = function(self, key)
		local cookies = os.getenv"HTTP_COOKIE" or ""
		cookies = ";" .. cookies .. ";"
		cookies = cookies:gsub("%s*;%s*", ";")
		local pattern = ";" .. key .. "=(.-);"
		local _, _, value = cookies:find(pattern)
		if value then
			return value, urlcode:unescape(value)
		end
	end,
	Delete = function(self, key)
		self:Set(key, "", 1)
	end,
}
