require"helper.mysql"

local db = ningyou.mysql
local cookie = require"helper.cookies"
local session = require"helper.session"
local mime = require"mime"
local md5 = require"md5"
local salt = io.open(ningyou.config_path .. "/salt"):read"*all":gsub("\n$", "")
local cryptkey = io.open(ningyou.config_path .. "/cryptkey"):read"*all":gsub("\n$", "")
local errormsg = "Invalid username or password."
local _ENV = os.getenv

local accessnames = {
	[99] = "Site Admin",
	[1]  = "User"
}

local sessionid = cookie:Get"Session"

if sessionid then
	sessiondata = session:Load(sessionid)
end

return {
	encodeURLbase64 = function(self, str)
		local b64 = mime.b64(str)
		local urlb64 = b64:gsub("=", "")
		b64:gsub("+", "*")
		b64:gsub("/", "-")
		b64:gsub(" ", "_")
		return b64
	end,
	decodeURLbase64 = function(self, str)
		local b64 = str:gsub("*", "+")
		b64:gsub("-", "/")
		b64:gsub("_", " ")

		local b64PadLen = math.fmod(4 - math.fmod(b64:len(), 4), 4)
		b64 = b64 .. string.rep("=", b64PadLen)
		
		local str = mime.unb64(b64)
		return str
	end,
	check = function(self)
		local session = cookie:Get"Session"
		if not sessiondata then return nil, "Cannot read sessiondata" end
		
		local check = db:prepare"SELECT password, access FROM nin_users where username = ?"
		local result, sqlerror = check:execute(sessiondata.username)
		if sqlerror then return nil, sqlerror end
		
		local sqldata = check:fetch(true)
		if not sqldata then return nil, errormsg end
		
		if sqldata["password"] ~= sessiondata.password then return nil, errormsg end
		
		local token = sessiondata.userdata
		if token then
			local data = md5.decrypt(self:decodeURLbase64(token), cryptkey)
			local user_ip = data and data:gsub(",.*$", "") or nil
			if user_ip ~= os.getenv"REMOTE_ADDR" then
				cookie:Delete"Session"
				return nil, "Invalid IP: " .. user_ip
			else
				local user = data and data:gsub("^.*,", "") or nil
				return user, sqldata["access"], accessnames[sqldata["access"]]
			end
		end
	end,
	login = function(self, user, pass)
		local sessionid = cookie:Get"Session" or nil
		if sessiondata and sessionid then
			return sessiondata.username, "Already logged in"
		else
			local check = db:prepare"SELECT username, password FROM nin_users WHERE username = ?"
			local result, sqlerror = check:execute(user)
			if sqlerror then
				return nil, nil, "SQL error: " .. sqlerror
			else
				local data = check:fetch(true)
				if data then
					pass = md5.sumhexa(pass .. salt)
					if data["password"] == pass then
						local id, err = session:New()
						if not id then return nil, err end
						local userdata = (_ENV"REMOTE_ADDR" or "1.1.1.1") ..",".. data["username"]
						userdata = self:encodeURLbase64(md5.crypt(userdata, cryptkey))
						local sessiondata = {}
						sessiondata.userdata = userdata
						sessiondata.username = data["username"]
						sessiondata.password = data["password"]
						cookie:Set("Session", id)
						local save, err = session:Save(id, sessiondata)
						if not save then return nil, err end
						return user, nil, id, sessiondata
					else
						return nil, errormsg
					end
				else
					return nil, errormsg
				end
			end
		end
	end,
	logout = function(self)
		local check, err = self:check()
		if not check then return nil, err end

		local sessionid = cookie:Get"Session"
		cookie:Delete"Session"
		sessiondata = nil
		session:Delete(sessionid)
		return true
	end,
}
