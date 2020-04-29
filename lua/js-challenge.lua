if ngx.var.cookie_addr == nil then
    local s1 = 
     "<html><head><script>document.cookie='addr=%s';" ..
     "setTimeout('location.reload();', 2);</script></head>" ..
     "<body>This page requires JavaScript. " ..
     "Please wait 2 seconds.</body></html>"
    ngx.header.content_type = "text/html"
    ngx.say(string.format(s1, ngx.var.remote_addr))
elseif ngx.var.cookie_addr ~= ngx.var.remote_addr then
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.header.content_type = "text/html"
    ngx.say("We expect your ip is " .. ngx.var.cookie_addr)
    ngx.say("but we got " .. ngx.var.remote_addr)
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
