#!/bin/bash -eu

NGINX_CONF="/etc/nginx/nginx.conf"

if [ ! -f ${NGINX_CONF}.bak ]; then
    sudo cp $NGINX_CONF ${NGINX_CONF}.bak
    echo "設定ファイルのバックアップを作成しました: ${NGINX_CONF}.bak"
else
    echo "バックアップはすでに存在します: ${NGINX_CONF}.bak"
fi

LOG_FORMAT="log_format with_time '\$remote_addr - \$remote_user [\$time_local] \"\$request\" \$status \$body_bytes_sent \"\$http_referer\" \"\$http_user_agent\" \$request_time';"

if sudo grep -q "log_format with_time" $NGINX_CONF; then
    echo "log_format設定はすでに存在します。"
else
    sudo sed -i "/^access_log \/var\/log\/nginx\/access.log;/i\    $LOG_FORMAT" "$NGINX_CONF"
    echo "log_format設定を追加しました。"
fi

sudo nginx -t && sudo systemctl reload nginx
