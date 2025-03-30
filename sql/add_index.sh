#!/bin/sh

set -ex
cd `dirname $0`

# インデックスを追加
for db in ../tenant_db/*.db; do
    echo "Adding indexes to $db"
    sqlite3 "$db" < tenant/11_index.sql
done 