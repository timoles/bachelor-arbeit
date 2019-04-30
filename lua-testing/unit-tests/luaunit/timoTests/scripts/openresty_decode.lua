-- file.lua
local proxy_malleable = require('/usr/local/openresty/nginx/conf/openresty_malleable')

function decode()
	ngx.req.read_body() -- read body, body now empty!
	local old_body = ngx.req.get_body_data() -- get entire body data
    --ngx.log(1, old_body)
    --ngx.log(1, "IN DECRYPT.")
    
    local malleable_result = proxy_malleable.decode(old_body)
    -- Set new body
    ngx.req.set_body_data(malleable_result)
    
end

-- TODO handle send this request into decode as well, let the user handle this!
-- TODO docs on how typical POST and GET look (Empty not empty and so on)
if ngx.req.get_method() ~= "GET" -- if we have anything but GET we want to base64 decode the payload
then
  decode()
end
