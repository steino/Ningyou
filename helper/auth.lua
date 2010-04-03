require"helper.mysql"
local mime = require"mime"
local md5 = require"md5"
local salt = io.open"salt":read"*all":gsub("\n$", "")

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
		
	end,
	check = function(self, user, pass)
		local check = _DB:prepare"SELECT username, password FROM nin_users WHERE username = ?"
		local result, error = check:execute(user)
		if error then
			return nil, "Didnt find user", user, error
		else
			local data = result:fetch(true)
			pass = md5.sumhexa(pass .. salt)
			if data["password"] == pass then
				return true
			else
				return nil, "Wrong password", user
			end
		end
	end,
}
