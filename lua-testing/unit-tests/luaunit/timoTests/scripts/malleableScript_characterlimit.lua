-- TODO restore all the comments from the official nmap source
local assert = assert
local error = error
local ipairs = ipairs
local setmetatable = setmetatable

local open = require "io".open
local popen = require "io".popen

local random = require "math".random

local tmpname = require "os".tmpname
local remove = require "os".remove


local char = require "string".char

local concat = require "table".concat

local b64table = {
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
  'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
  'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
  'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
  'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
  'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
  'w', 'x', 'y', 'z', '0', '1', '2', '3',
  '4', '5', '6', '7', '8', '9', '+', '/'
}

local M = {}

---
-- Encodes a string to Base64.
-- @param p Data to be encoded.
-- @return Base64-encoded string.
function enc (p)
    local out = {}
    local i = 1
    local m = #p % 3

    while i+2 <= #p do
        local a, b, c = p:byte(i, i+2)
        local e1 = b64table[((a>>2)&0x3f)+1];
        local e2 = b64table[((((a<<4)&0x30)|((b>>4)&0xf))&0x3f)+1];
        local e3 = b64table[((((b<<2)&0x3c)|((c>>6)&0x3))&0x3f)+1];
        local e4 = b64table[(c&0x3f)+1];
        out[#out+1] = e1..e2..e3..e4
        i = i + 3
    end

    if m == 2 then
        local a, b = p:byte(i, i+1)
        local c = 0
        local e1 = b64table[((a>>2)&0x3f)+1];
        local e2 = b64table[((((a<<4)&0x30)|((b>>4)&0xf))&0x3f)+1];
        local e3 = b64table[((((b<<2)&0x3c)|((c>>6)&0x3))&0x3f)+1];
        out[#out+1] = e1..e2..e3.."="
    elseif m == 1 then
        local a = p:byte(i)
        local b = 0
        local e1 = b64table[((a>>2)&0x3f)+1];
        local e2 = b64table[((((a<<4)&0x30)|((b>>4)&0xf))&0x3f)+1];
        out[#out+1] = e1..e2.."=="
    end

    return concat(out)
end

local db64table = setmetatable({}, {__index = function (t, k) error "invalid encoding: invalid character" end})
do
    local r = {["="] = 0}
    for i, v in ipairs(b64table) do
        r[v] = i-1
    end
    for i = 0, 255 do
        db64table[i] = r[char(i)]
    end
end

---
-- Decodes Base64-encoded data.
-- @param e Base64 encoded data.
-- @return Decoded data.
function dec (e)
    local out = {}
    local i = 1
    local done = false

    e = e:gsub("%s+", "")

    local m = #e % 4
    if m ~= 0 then
        error "invalid encoding: input is not divisible by 4"
    end

    while i+3 <= #e do
        if done then
            error "invalid encoding: trailing characters"
        end

        local a, b, c, d = e:byte(i, i+3)

        local x = ((db64table[a]<<2)&0xfc) | ((db64table[b]>>4)&0x03)
        local y = ((db64table[b]<<4)&0xf0) | ((db64table[c]>>2)&0x0f)
        local z = ((db64table[c]<<6)&0xc0) | ((db64table[d])&0x3f)

        if c == 0x3d then
            assert(d == 0x3d, "invalid encoding: invalid character")
            out[#out+1] = char(x)
            done = true
        elseif d == 0x3d then
            out[#out+1] = char(x, y)
            done = true
        else
            out[#out+1] = char(x, y, z)
        end
        i = i + 4
    end

    return concat(out)
end

function encode(s)
    --return s
    encoded = enc(s)
    resultString = "test=123&viewstate=\"" .. encoded ..  "\"&test2=456"
    return(resultString)
end

function decode(s)
    if s == nil then
        return s
    end

    if string.match(s, 'viewstate') then        
        s = string.match(s, 'viewstate=\"(.-)\"</body></html>')

        if s == "" then
            return nil
        end        
        return(dec(s))
    else
        return s
    end

end

M.encode = encode
M.decode = decode

return M -- TODO check if this breaks the meterpreter implemnation
-- charachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimit
-- charachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimitcharachterlimit
-- limit limit limit limit limit limit limit limit limit limit limit limi