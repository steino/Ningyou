require"helper.mysql"

local db = ningyou.mysql

local tests = {
	{
		"insert into nin_data_anime (id, title, official_title, episodes) values (?,?,?,?)",
		function(q)
			io.write'Running test #1: '
			local query = assert(db:prepare(q))
			assert(query:execute(0,'title test', 'official title test', '0'))
			assert(db:commit())
			assert(query:close())
			print('Done')
		end,
	},
	{
		"select * from nin_data_anime where id = ?",
		function(q)
			io.write'Running test #2: '
			local query = assert(db:prepare(q))
			assert(query:execute(0))
			assert(db:commit())
			local cols = assert(query:columns())
			local row = assert(query:fetch(true))
			assert(row["id"] == 0)
			assert(row["title"] == "title test")
			assert(row["official_title"] == "official title test")
			assert(row["episodes"] == 0)
			assert(query:close())
			print'Done'
		end,
	},
	{
		"delete from nin_data_anime where id = ?",
		function(q)
			io.write'Running test #3: '
			local query = assert(db:prepare(q))
			assert(query:execute(0))
			assert(db:commit())
			assert(query:close())
			print'Done'
		end,
	}
}

for key, testData in pairs(tests) do
	testData[2](testData[1])
end
