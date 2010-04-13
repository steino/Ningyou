require"helper.mysql"
local cookie = require"helper.cookies"
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
		if session then
			local data = md5.decrypt(decodeURLbase64(session), cryptkey)
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
		local check = _DB:prepare"SELECT username, password FROM nin_users WHERE username = ?"
		local result, sqlerror = check:execute(user)
		if sqlerror then
			return nil, nil, "SQL error: " .. error
		else
			local data = check:fetch(true)
			if data then
				pass = md5.sumhexa(pass .. salt)
				if data["password"] == pass then
					local userdata = _ENV"REMOTE_ADDR" .. username
					userdata = encodeURLbase64(md5.crypt(userdata, cryptkey))
					cookie:Set("Session", userdata)
					return user, nil
				else
					return nil, errormsg
				end
			else
				return nil, errormsg
			end
		end
	end,
}
