require"helper.mysql"

local tests = {
	{
		"insert into nin_data_anime (id, title, official_title, episodes, genres) values (?,?,?,?,?)",
		function(q)
			io.write'Running test #1: '
			local query = assert(_DB:prepare(q))
			assert(query:execute(0,'title test', 'official title test', '0', '0'))
			assert(_DB:commit())
			assert(query:close())
			print('Done')
		end,
	},
	{
		"select * from nin_data_anime where id = ?",
		function(q)
			local output
			io.write'Running test #2: '
			local query = assert(_DB:prepare(q))
			assert(query:execute(0))
			assert(_DB:commit())
			local cols = assert(query:columns())
			local row = assert(query:fetch(true))
			assert(row["id"] == 0)
			assert(row["title"] == "title test")
			assert(row["official_title"] == "official title test")
			assert(row["episodes"] == 0)
			assert(row["genres"] == 0)
			assert(query:close())
			print'Done'
		end,
	},
	{
		"delete from nin_data_anime where id = ?",
		function(q)
			io.write'Running test #3: '
			local query = assert(_DB:prepare(q))
			assert(query:execute(0))
			assert(_DB:commit())
			assert(query:close())
			print'Done'
		end,
	}
}

for key, testData in pairs(tests) do
	testData[2](testData[1])
end
