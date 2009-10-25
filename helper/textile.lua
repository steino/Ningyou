local split = function(msg, char)
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

local input = [[
A wild line appears!(tm)

* Line 1.1
** Line 2.1
** Line 2.2
* Line 1.2

@Some code@

'it's'
"it's"

3 x 3 = 9
a ^2^ + b ^2^ = c ^2^
log ~2~ x

I'm %{color:red}unaware%
of most soft drinks.

p(haha). lawl
*(haha) Line 1.1
]]

local tree = {}

local lists = {
	['*'] = 'list:bullet';
	['#'] = 'list:numeric';
}

local replaces = {
	{
		['%(tm%)'] = '™',
		['%(r%) '] = '®',
		['%(c%)'] = '©',

		['%-%-'] = '—',

		["(%w+)'(%w+)"] = '%1‘%2',

		[' x '] = ' x ',
		['"(.-)"'] = '“%1”',

		-- These do slightly more lifting
		['_(.-)_'] = '<em>%1</em>',
		['%*(.-)%*'] = '<strong>%1</strong>',
		['__(.-)__'] = '<i>%1</i>',
		['%*%*(.-)%*%*'] = '<b>%1</b>',
		['%?%?(.-)%?%?'] = '<cite>%1</cite>',
		['%-(.-)%-'] = '<del>%1</del>',
		['%+(.-)%+'] = '<ins>%1</ins>',
		['%^(.-)%^'] = '<sup>%1</sup>',
		['~(.-)~'] = '<sub>%1</sub>',
		['%%(.-)%%'] = '<span>%1</span>',
		['@(.-)@'] = '<code>%1</code>'
	},
	{
		["'(.-)'"] = '‘%1’',
		['%-'] = '–',
	},
}

local doReplaces = function(data)
	local content = data.content

	for k, repTable in ipairs(replaces) do
		for input, replacement in next, repTable do
			content = content:gsub(input, replacement)
		end
	end

	data.content = content
end

local doAttributes = function(data)
	local attributes = data.attributes

end

local handle = function(line, content)
	-- Shared data.
	local data = {line = line}

	if(#content == 0) then
		data.type = 'empty'

		tree[line] = data
		return
	else
		data.raw = content
		data.content = content
	end

	-- Check if it is a list:
	local listMark = content:sub(1, 1)
	if(lists[listMark]) then
		-- If the first and the last match, then it's fine!
		local block, _, type, attributes, content = content:find"([*#])([^ #*]*) (.*)$"

		data.type = lists[type] or 'list:invalid'
		data.block = block

		if(attributes ~= '') then
			data.attributes = attributes
		end

		-- We need to overwrite with our extracted contend.
		data.content = content

		doReplaces(data)

		tree[line] = data
		return
	end

	doReplaces(data)

	data.type = 'paragraph'
	tree[line] = data
end

for line, content in ipairs(split(input, "\n")) do
	handle(line, content)
end

function table_print (tt, indent, done)
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

print('Input\n', input)
print'======='
table_print(tree)
