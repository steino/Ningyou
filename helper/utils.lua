return {
	handleKey = function(self, key)
		if type(key) == "number" or type(key) == "boolean" then
			return ("[%s]"):format(key)
		else
			return ("[%q]"):format(tostring(key))
		end
	end,
	handleValue = function(self, value, i)
		if type(value) == "table" then
			return self:table_tostring(value, i+1)
		elseif type(value) == "number" or type(value) == "boolean" then
			return value
		else
			return ("%q"):format(value)
		end
	end,
	table_tostring = function(self, t, i)
		if type(t) ~= "table" then return "Not a table" end
		i = i or 1
		local str = ""
		for k,v in pairs(t) do
			str = str .. ("%s%s = %s,\n"):format(("\t"):rep(i), self:handleKey(k), self:handleValue(v, i))
		end
		
		return ("{\n"..str..("\t"):rep(i-1).."}")
	end,
	split = function(self, msg, char)
		local arr = {}
		local fchar = "(.-)" .. char
		local last_end = 1
		local s, e, cap = msg:find(fchar, 1)

		while s do
			if s ~= 1 or cap ~= "" then
				table.insert(arr, cap)
			end
			last_end = e+1
			s, e, cap = msg:find(fchar, last_end)
		end

		if last_end <= #msg then
			cap = msg:sub(last_end)
			table.insert(arr, cap)
		 end

		return arr
	end,
	table_print = function(self, tt, indent, done)
		done = done or {}
		indent = indent or 0
		if type(tt) == "table" then
			for key, value in pairs (tt) do
				io.write(string.rep (" ", indent)) -- indent it
				if type (value) == "table" and not done [value] then
					done [value] = true
					io.write(string.format("[%s] => table\n", tostring (key)));
					io.write(string.rep (" ", indent+4)) -- indent it
					io.write("(\n");
					self:table_print (value, indent + 7, done)
					io.write(string.rep (" ", indent+4)) -- indent it
					io.write(")\n");
				else
					io.write(string.format("[%s] => %s\n",
					tostring (key), tostring(value)))
				end
			end
		else
			io.write(tt .. "\n")
		end
	end,
	copy = function(self, a, out)
		local o = out or {}
		for k,v in pairs(a) do
			o[k] = v
		end
		return o
	end,
	intersect = function(self, a, b, out)
		local o = out or {}
		for k,v in pairs(a) do 
			o[k] = b[k]
		end
		return o
	end,
	union = function(self, a, b, out)
		local o = out or {}
		copy(a, o)
		copy(b, o)

		return o
	end,
	difference = function(self, a, b, out)
		local o = out or {}
		copy(a, o)
		for k,v in pairs(b) do
			o[k] = nil
		end
		return o
	end
}
