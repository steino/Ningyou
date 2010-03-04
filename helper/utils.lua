local function table_print (tt, indent, done)
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
				table_print (value, indent + 7, done)
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
end

local utils = {
	split = function(msg, char)
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
	tableprint = table_print,
	copy = function(a, out)
		local o = out or {}
		for k,v in pairs(a) do
			o[k] = v
		end
		return o
	end,
	intersect = function(a, b, out)
		local o = out or {}
		for k,v in pairs(a) do 
			o[k] = b[k]
		end
		return o
	end,
	union = function(a, b, out)
		local o = out or {}
		copy(a, o)
		copy(b, o)

		return o
	end,
	difference = function(a, b, out)
		local o = out or {}
		copy(a, o)
		for k,v in pairs(b) do
			o[k] = nil
		end
		return o
	end
}

return utils
