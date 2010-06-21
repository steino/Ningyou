ningyou = {}

local config = loadfile("/home/steino/ningyou.lua")()
ningyou.config_path = config['config_path']

local auth = require"helper.auth"
local salt = io.open(ningyou.config_path .. "/salt"):read"*all":gsub("\n$", "")
local cryptkey = io.open(ningyou.config_path .. "/cryptkey"):read"*all":gsub("\n$", "")

local tests = {
	{
		"test",
		function(a)
			io.write"Running test #1: "
			local hash = auth:encodeURLbase64(md5.crypt(a, cryptkey))
			hash = md5.decrypt(auth:decodeURLbase64(hash), cryptkey)
			assert(hash == "test")
			print"Done"
		end,
	},
}

for key, testData in pairs(tests) do
	testData[2](testData[1])
end
