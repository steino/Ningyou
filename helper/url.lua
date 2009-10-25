return function()
	local path = os.getenv('PATH_INFO')

	if(path) then
		local _PATH = {}
		for str in input:gmatch'[^/]+' do
			table.insert(_PATH, str)
		end

		return _PATH
	end
end
