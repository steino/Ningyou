local _PATH = require'helper.url'

local tests = {
	{
		'/haste/anime/',
		function(_PATH)
			io.write'Running test #1: '
			assert(_PATH[1] == 'haste')
			assert(_PATH[2] == 'anime')
			print('Done')
		end,
	}
}

for key, testData in pairs(tests) do
	local path = _PATH(testData[1])
	testData[2](path)
end
