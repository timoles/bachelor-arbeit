--encode.lua
local base64=require('/usr/local/openresty/nginx/conf/ee5_base64')

local M = {}

local function encode(data)
	local result = data
	if data ~= nil and data ~= "" then
		result = '<html><head></head><body>viewstate="' .. base64.encode(tostring(data)) .. '"</body></html>'
	end

	return result
end

local function decode(data)
	local result = data
	if data ~= nil then
		local viewstate = string.match(data, "viewstate=\"(.-)\"") -- get payload from viewstate
		if (viewstate ~= nil) then
	    	result = base64.decode(tostring(viewstate)) -- decode base64
	    end
	end
    return result
end

M.encode = encode
M.decode = decode

return M