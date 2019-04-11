-- file.lua

base64=require('/usr/local/openresty/nginx/conf/ee5_base64')

function encode()
    -- encapsule body in viewstate
    
    ngx.log(1, ngx.arg[1])
    
    if(ngx.arg[1] ~= nil) then
        local encapsuled_body = '<html><head></head><body>viewstate="' .. base64.encode(ngx.arg[1]) .. '"</body></html>'
        ngx.arg[1] =  encapsuled_body -- set encapsuled response as new body
        ngx.arg[2] = true -- Set end of stream to true (or something like that)
        ngx.log(1, "Outgoing Edit")
        ngx.log(1, encapsuled_body)
    end
end
ngx.log(1, "----------------Outgoing----------------")
encode() -- encode ALL outgoing messages
ngx.log(1, "----------------OutgoingEND----------------")
