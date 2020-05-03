#!/bin/sh

if [ -x "$(command -v openresty)" ]; then
    openresty -p "$(pwd)" -c conf/nginx.conf
else
    nginx -p "$(pwd)" -c conf/nginx.conf
fi
