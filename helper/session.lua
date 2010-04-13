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
		if find(id .. ".lua") then
			repeat
				id = new_id()
			until not find(id .. ".lua")
			randomseed(math.mod(id, 999999999))
		end
		return id
	end,

	Load = function(self, id)
	end,

	Set = function(self, id, key, value)
	end,

	Unset = function(self, id, key)
	end,
}
