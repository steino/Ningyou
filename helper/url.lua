return function(path)
	path = path or os.getenv('PATH_INFO')

	if(path) then
		local _PATH = {}
		for str in path:gmatch'[^/]+' do
			table.insert(_PATH, str)
		end

		return _PATH
	end
end
