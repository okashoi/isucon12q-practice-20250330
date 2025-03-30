#!/bin/sh -eu
#
# mysql_slow_query.sh
#   1) init : 設定ファイルにスロークエリログの初期設定を追記
#   2) on   : slow_query_log = ON に書き換え
#   3) off  : slow_query_log = OFF に書き換え
# 使い方:
#   ./mysql_slow_query.sh init
#   ./mysql_slow_query.sh on
#   ./mysql_slow_query.sh off

CONFIG_FILE="/etc/mysql/mysql.conf.d/mysqld.cnf"
SERVICE_NAME="mysql"

init_config() {
  # バックアップを作成
  sudo cp -p "$CONFIG_FILE" "${CONFIG_FILE}.$(date +'%Y%m%d_%H%M%S').bak"

   sudo sed -i "/^\[mysqld\]/a \
# Slow query\n\
slow_query_log = ON\n\
slow_query_log_file = /var/log/mysql/mysql-slow.log\n\
long_query_time = 0 # 0 = 全部吐き出す" "$CONFIG_FILE"

  sudo systemctl restart "$SERVICE_NAME"
}

enable_slow_query() {
    sudo sed -i \
    "s/^[#[:space:]]*\(slow_query_log[[:space:]]*=[[:space:]]*\)\(OFF\|0\).*/\1ON/" \
    "$CONFIG_FILE"

    sudo systemctl restart "$SERVICE_NAME"
}

disable_slow_query() {
     sudo sed -i \
    "s/^[#[:space:]]*\(slow_query_log[[:space:]]*=[[:space:]]*\)\(ON\|1\).*/\1OFF/" \
    "$CONFIG_FILE"

  # slow_query_log を強制的に OFF に書き換え
  sudo systemctl restart "$SERVICE_NAME"
}

case "$1" in
  init)
    init_config
    ;;
  on)
    enable_slow_query
    ;;
  off)
    disable_slow_query
    ;;
  *)
    echo "使い方: $0 {init|on|off}"
    exit 1
    ;;
esac
