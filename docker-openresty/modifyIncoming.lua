-- file.lua

base64=require('/usr/local/openresty/nginx/conf/ee5_base64')

--print( base64.encode("This is a string") )
--print( base64.decode("RHVkZSEgV2hlcmUgaXMgbXkgY2FyPz8/Cg==") )

function decode()
	ngx.req.read_body() -- read body, body now empty!
	local old_body = ngx.req.get_body_data() -- get entire body data
    --ngx.log(1, old_body)
    --ngx.log(1, "IN DECRYPT.")

	local new_variables = string.match(old_body, "viewstate=\"(.-)\"") -- get payload from viewstate
    --ngx.log(1, new_variables)
    if (new_variables ~= nil) then
    	new_variables = base64.decode(new_variables) -- decode base64
        response_body = new_variables
        --response_body = string.sub(new_variables, 1, -2) -- remove the last character (unwanted newline)
        ngx.log(1, response_body)
    	ngx.req.set_body_data(response_body) -- set new response
    else
        ngx.req.set_body_data(old_body)
    end
end

if ngx.req.get_method() ~= "GET" -- if we have anything but GET we want to base64 decode the payload
then
  decode()
end