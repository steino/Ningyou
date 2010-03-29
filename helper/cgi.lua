return {
	Post = function(self, stdin, limit)
		limit = tonumber(limit) or 0
		if limit < 1 then
			stdin:close()
			return nil
		else
			local args = stdin:read(limit)
			if not args then
				stdin:close()
				return nil
			else
				local out = {}
				args:gsub("([^&=]+)=([^&=]*)&?", function(i,v) out[i] = v end)
				return out
			end
		end
	end,
	Get = function(self, query)
		local out = {}
		query:gsub("([^&=]+)=([^&=]*)&?", function(i,v) out[i] = v end)
		return out
	end,
}
