local h = ngx.req.get_headers()

signature = h["X-Hub-Signature"]

if signature == nil then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end

for k, v in string.gmatch(signature, "(%w+)=(%w+)") do
    -- expect 'sha1=xxxxxxxxx'
    signature = v
end

ngx.req.read_body()
local data = ngx.req.get_body_data()

local str = require "resty.string"
local hmac = str.to_hex(ngx.hmac_sha1("MYSECRET!", data))

if hmac ~= signature then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end

local handle = io.popen("uname")
local result = handle:read("*a")
handle:close()

ngx.say(result)
