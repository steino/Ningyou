math.randomseed(os.time() % 1e5)

local function touch(file)
	file, err = io.open(file, "w")
	if file then
		file:close()
	else
		return nil, err
	end
end

local function find(file)
	local fh = io.open("sessions/" .. file)
	if fh then 
		fh:close()
		return true
	end
end

local function new_id()
	return math.random(9999999)
end

local function check_id(id)
	return id and (id:find"^%d+$" ~= nil)
end

return {
	New = function(self)
		local id = new_id()
		if find(id) then
			repeat
				id = new_id()
			until not find(id)
			math.randomseed(math.mod(id, 999999999))
		end
		local _, err = touch("sessions/" .. id)
		return id, err
	end,

	Load = function(self, id)
	end,

	Set = function(self, id, key, value)
	end,

	Unset = function(self, id, key)
	end,
}
