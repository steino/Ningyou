return {
	escape = function(self, s)
		s:gsub("\n", "\r\n")
		s:gsub("([^0-9a-zA-Z ])", function(c) return string.format("%%%02X", string.byte(c)) end)
		s:gsub(" ", "+")
		return s
	end,
	unescape = function(self, s)
		s:gsub("+", " ")
		s:gsub("%%(%x%x)", function(h) return string.char(tonumber(h,16)) end)
		s:gsub("\r\n", "\n")
		return s
	end,
}
