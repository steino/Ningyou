if not ningyou then ningyou = {} end

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
		if not query then return nil, "Empty query" end
		local out = {}
		query:gsub("([^&=]+)=([^&=]*)&?", function(i,v) out[i] = v end)
		return out
	end,
	Run = function(self, file)
		local fh = io.open(file)
		if not fh then return nil, "Could not open file." end
		fh:close()

		-- Fill POST/QUERY
		_G.ningyou.POST = pcall(self:Post(io.stdin, os.getenv"CONTENT_LENGHT"))
		_G.ningyou.QUERY = self:Get(os.getenv"QUERY_STRING")

		local content, err = loadfile(file)

		if not content then
			return nil, err
		else
			return pcall(content)
		end
	end,
}
