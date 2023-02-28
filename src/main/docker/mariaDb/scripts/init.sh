#!/bin/bash

set -e
set -u

export USER="$MYSQL_USER"

function create_database() {
    database="$1"
  echo "  Creating database '$database' "

 mysql -u "$MYSQL_ROOT_USER" -p"$MYSQL_ROOT_PASSWORD" <<-EOSQL
       CREATE DATABASE $database;
       GRANT ALL PRIVILEGES ON *.* TO '$USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
EOSQL

mysql -u "$USER" -p"$MYSQL_PASSWORD" -D "$database"  < /db/ddl-1.sql
# mysql -u "$USER" -p"$MYSQL_PASSWORD" -D "$database"  < /db/ddl-2.sql
}

echo "starting script"

if [ -n "$MYSQL_MULTIPLE_DATABASES" ]; then
    echo "Multiple database creation requested: $MYSQL_MULTIPLE_DATABASES"
    for DB in $(echo $MYSQL_MULTIPLE_DATABASES | tr ',' ' '); do
        create_database $DB
    done
    echo "Multiple databases created"
fi

echo "finish script"
