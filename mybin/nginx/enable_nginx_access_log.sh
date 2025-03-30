#!/bin/bash -eu

NGINX_CONF="/etc/nginx/nginx.conf"

sed -i 's#^[[:space:]]*access_log[[:space:]].*#access_log /var/log/nginx/access.log with_time;#' "$NGINX_CONF"

sudo nginx -t && sudo systemctl reload nginx

