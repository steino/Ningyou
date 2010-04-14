module("utils", package.seeall)

local handleKey = function(key)
	if type(key) == "number" or type(key) == "boolean" then
		return ("[%s]"):format(key)
	else
		return ("[%q]"):format(tostring(key))
	end
end

local handleValue = function(value, i)
	if type(value) == "table" then
		return table_tostring(value, i+1)
	elseif type(value) == "number" or type(value) == "boolean" then
		return value
	else
		return ("%q"):format(value)
	end
end

function table_tostring(t, i)
	if type(t) ~= "table" then return end
	i = i or 1
	local str = ""
	for k,v in pairs(t) do
		str = str .. ("%s%s = %s,\n"):format(("\t"):rep(i), handleKey(k), handleValue(v, i))
	end
	
	return ("{\n"..str..("\t"):rep(i-1).."}")
end

function split(msg, char)
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
end

function table_print(tt, indent, done)
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

function copy(a, out)
	local o = out or {}
	for k,v in pairs(a) do
		o[k] = v
	end
	return o
end
	
function intersect(a, b, out)
	local o = out or {}
	for k,v in pairs(a) do 
		o[k] = b[k]
	end
	return o
end

function union(a, b, out)
	local o = out or {}
	copy(a, o)
	copy(b, o)
	return o
end

function difference(a, b, out)
	local o = out or {}
	local temp = copy(a, o)
	for k,v in pairs(b) do
		o[k] = nil
	end
	return o
end
