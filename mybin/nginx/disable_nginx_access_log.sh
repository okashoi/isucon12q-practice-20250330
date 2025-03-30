#!/bin/bash -eu

NGINX_CONF="/etc/nginx/nginx.conf"

sudo sed -i 's#^[[:space:]]*access_log[[:space:]].*#access_log off;#' "$NGINX_CONF"

sudo nginx -t && sudo systemctl reload nginx
