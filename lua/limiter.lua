local limit_req = require "resty.limit.req"
local limit_count = require "resty.limit.count"
local client = ngx.var.binary_remote_addr
-- user address

local main_req_limiter, err = limit_req.new("main_req_store", 40, 100)
-- 40 r/s, brust 100 r/s
assert(main_req_limiter, err)

local main_count_limiter, err = limit_count.new("main_count_store", 1000, 3600)
-- 1000 r/3600 s (1 hr)
assert(main_count_limiter, err)

local delay, err = main_req_limiter:incoming(client, true)
if not delay then
    if err == 'rejected' then 
        return ngx.exit(ngx.HTTP_SERVICE_UNAVAILABLE)
    end
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

local delay, err = main_count_limiter:incoming(client, true)
if not delay then
	if err == 'rejected' then
        main_req_limiter:set_rate(1)
        -- only allow 1 r/s if you request too much
    end
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

if delay >= 0.001 then
    ngx.sleep(delay)
end