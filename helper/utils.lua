local table = require'table'
local string = require'string'
local base = _G

local next = next
local type = type
local tostring = tostring

module(...)

local handleKey = function(key)
	if type(key) == "number" or type(key) == "boolean" then
		return ("[%s]"):format(key)
	else
		return ("[%q]"):format(tostring(key))
	end
end

local handleValue = function(value, i)
	if type(value) == "table" then
		return table.tostring(value, i+1)
	elseif type(value) == "number" or type(value) == "boolean" then
		return value
	else
		return ("%q"):format(value)
	end
end

function table.tostring(t, i)
	if type(t) ~= "table" then return end
	i = i or 1
	local str = ""
	for k,v in next, t do
		str = str .. ("%s%s = %s,\n"):format(("\t"):rep(i), handleKey(k), handleValue(v, i))
	end
	
	return ("{\n"..str..("\t"):rep(i-1).."}")
end

function string.split(msg, char)
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
	return base.unpack(arr)
end

set = {}
function set.copy(a, out)
	local o = out or {}
	for k,v in next, a do
		o[k] = v
	end
	return o
end
	
function set.intersect(a, b, out)
	local o = out or {}
	for k,v in next, a do 
		o[k] = b[k]
	end
	return o
end

function set.union(a, b, out)
	local o = out or {}
	set.copy(a, o)
	set.copy(b, o)
	return o
end

function set.difference(a, b, out)
	local o = out or {}
	local temp = set.copy(a, o)
	for k,v in next, b do
		o[k] = nil
	end
	return o
end
