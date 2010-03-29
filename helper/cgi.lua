return {
	Post = function(self, stdin, limit)
		limit = tonumber(limit) or 0
		local blocksize = 2048
		if limit < 1 then
			stdin:close()
			return nil
		else
			local read = (limit > blocksize) and blocksize or limit
			limit = limit - read
			local args = stdin:read(read)
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
}
