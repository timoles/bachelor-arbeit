-- file.lua

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' -- You will need this for encoding/decoding
-- encoding
function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
    end))
end

function decode()
	local data, eof = ngx.arg[1], ngx.arg[2]
	ngx.log(1, data)
	local new_variables = string.match(data, "viewstate=\"(.-)\"") -- get payload from viewstate

    if (new_variables ~= nil) then
   		new_variables = dec(new_variables) -- decode base64
   		--ngx.log(1, string.sub(new_variables, 1, -2))
   		--ngx.arg[1] = string.sub(new_variables, 1, -2) -- remove the last character (unwanted newline)
   		ngx.log(1, new_variables)
   		ngx.arg[1] = new_variables -- remove the last character (unwanted newline)
   	end
end


if ngx.req.get_method() ~= "GET" -- if we have anything but GET we want to base64 decode the payload
then
  decode()
end