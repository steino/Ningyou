local utils = require"helper.utils"

local tree = {}

local lists = {
	['*'] = 'list:bullet';
	['#'] = 'list:numeric';
}

local replaces = {
	{
		['%(tm%)'] = '™',
		['%(r%)'] = '®',
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
		if(block) then
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
	end

	doReplaces(data)

	data.type = 'paragraph'
	tree[line] = data
end

return function(input)
	for line, content in ipairs(utils.split(input, "\n")) do
		handle(line, content)
	end
	return tree
end
