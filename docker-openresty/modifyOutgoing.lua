-- file.lua

base64=require('/usr/local/openresty/nginx/conf/ee5_base64')

function encode()
    -- encapsule body in viewstate
    
    
    
    if(ngx.arg[1] ~= nil and ngx.arg[1] ~= "") then
    	ngx.log(1, '00000\n')
		--ngx.log(1, "\nOutgoing unEdit B-----------------------------------------\n")
        --ngx.log(1, '\n0000---------'..ngx.arg[1])
        --ngx.log(1, "\nOutgoing unEdit E-----------------------------------------\n")
        local encapsuled_body = '<html><head></head><body>viewstate="' .. base64.encode(ngx.arg[1]) .. '"</body></html>'
        --local encapsuled_body = '<html><head></head><body>viewstate="' .. ngx.arg[1] .. '"</body></html>'
        ngx.arg[1] =  encapsuled_body -- set encapsuled response as new body
        --ngx.arg[2] = true -- Set end of stream to true (or something like that)
        --ngx.log(1, "\nOutgoing Edit B-----------------------------------------\n")
        ngx.log(1, '\n010101---------'..encapsuled_body .. "\n")
        --ngx.log(1, "\nOutgoing Edit E-----------------------------------------\n")
    else
    	ngx.log(1, '11111\n')
    	--ngx.log(1, "NGX ARG NIL or empty !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    	ngx.arg[1] = ngx.arg[1]
    	ngx.arg[2] = true
    end
end

function encode2()
	-- Quelle: https://gist.github.com/ejlp12/b3949bb40e748ae8367e17c193fa9602
	local ctx = ngx.ctx 
	if ctx.buffers == nil then 
    	ctx.buffers = {} 
    	ctx.nbuffers = 0 
    end 

	local data = ngx.arg[1] 
	local eof = ngx.arg[2] 
	local next_idx = ctx.nbuffers + 1 

	if not eof then 
		if data then 
			ctx.buffers[next_idx] = data 
			ctx.nbuffers = next_idx 
            -- Send nothing to the client yet. 
			ngx.arg[1] = nil 
		end 
        return 
	elseif data then 
		ctx.buffers[next_idx] = data 
		ctx.nbuffers = next_idx 
	end 

	-- Yes, we have read the full body. 
	-- Make sure it is stored in our buffer. 
	assert(ctx.buffers) 
	assert(ctx.nbuffers ~= 0, "buffer must not be empty") 
	-- TIMO begin
	if table.concat(ngx.ctx.buffers) ~= "" then
		local encapsuled_body = '<html><head></head><body>viewstate="' .. base64.encode(table.concat(ngx.ctx.buffers)) .. '"</body></html>'
		ngx.arg[1] = encapsuled_body
	else
	-- TIMO ENd
	-- And send a new body 
	ngx.arg[1] = table.concat(ngx.ctx.buffers) 
	end -- timo changed
  end
--ngx.log(1, "----------------Outgoing----------------")
--encode() -- encode ALL outgoing messages
encode2()
--ngx.log(1, "----------------OutgoingEND----------------")
