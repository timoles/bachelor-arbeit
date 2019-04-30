-- file.lua
local data_encode = require('/usr/local/openresty/nginx/conf/openresty_malleable')

function encode()
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
	local malleable_result = data_encode.encode(table.concat(ngx.ctx.buffers))
	ngx.arg[1] = malleable_result
end
--ngx.log(1, "----------------Outgoing----------------")
--encode() -- encode ALL outgoing messages
encode()
--ngx.log(1, "----------------OutgoingEND----------------")
