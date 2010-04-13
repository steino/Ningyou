require"helper.mysql"
local cookie = require"helper.cookies"
local session = require"helper.session"
local mime = require"mime"
local md5 = require"md5"
local salt = io.open"salt":read"*all":gsub("\n$", "")
local cryptkey = io.open"cryptkey":read"*all":gsub("\n$", "")
local errormsg = "Invalid username or password."
local _ENV = os.getenv

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
	username = function(self)
		local session = cookie:Get"Session"
		local token = session:Get(session, "userdata")
		if token then
			local data = md5.decrypt(self:decodeURLbase64(token), cryptkey)
			local user_ip = data and data:gsub(",.*$", "") or nil
			if user_ip ~= os.getenv"REMOTE_ADDR" then
				cookie:Delete"Session"
				return
			else
				local user = data and data:gsub("^.*,", "") or nil
				return user
			end
		end
	end,
	login = function(self, user, pass)
		local sessionid = cookie:Get"Session" or nil
		if sessionid then
			--return session:Get(sessionid, "username"), "Already logged in"
			return nil, "Already logged in", sessionid
		else
			local check = _DB:prepare"SELECT username, password FROM nin_users WHERE username = ?"
			local result, sqlerror = check:execute(user)
			if sqlerror then
				return nil, nil, "SQL error: " .. error
			else
				local data = check:fetch(true)
				if data then
					pass = md5.sumhexa(pass .. salt)
					if data["password"] == pass then
						local id = session:New()
						local userdata = (_ENV"REMOTE_ADDR" or "1.1.1.1") .. data["username"]
						userdata = self:encodeURLbase64(md5.crypt(userdata, cryptkey))
						cookie:Set("Session", id)
						--session:Set(id, "userdata", userdata)
						--session:Set(id, "username", data["username"]
						--session:Set(id, "password", data["password"]
						return user, nil, id
					else
						return nil, errormsg
					end
				else
					return nil, errormsg
				end
			end
		end
	end,
}