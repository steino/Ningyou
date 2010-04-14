if not utils then return nil, "Utils not loaded" end

math.randomseed(os.time() % 1e5)

local exec = os.execute

local function chmod(file)
	exec("chmod 777 sessions/"..file)
end

local function touch(file)
	file, err = io.open("sessions/"..file, "w")
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
		local _, err = touch(id)
		chmod(id)
		return id, err
	end,

	Load = function(self, id)
		if check_id(id) then
			local f, err = loadfile("sessions/"..id)
			if not f then
				return nil, err
			else
				return f()
			end
		else
			return nil, "Invalid session ID"
		end
	end,

	Save = function(self, id, data)
		id = tostring(id)
		local s = sessiondata or data
		if s and check_id(id) then
			local fh = assert(io.open("sessions/"..id, "w+"))
			fh:write("return " .. utils.table_tostring(s))
			fh:close()
			return true
		else
			return nil, "Invalid session"
		end
	end,

	Delete = function(self, id)
		if check_id(id) and find(id) then
			local f, err = os.remove("sessions/"..id)
			if f then
				sessiondata = nil
			else
				return nil, err
			end
		end
	end,
}
