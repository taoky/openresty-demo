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

local hmac = ngx.hmac_sha1("MYSECRET!", data)
ngx.say(hmac)
