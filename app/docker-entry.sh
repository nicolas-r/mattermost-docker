#!/bin/bash

CONFIG="/mattermost/config/config.json"

DB_HOST=${DB_HOST:-db}
DB_PORT=${DB_PORT:-5432}
MM_USERNAME=${MM_USERNAME:-mmuser}
MM_PASSWORD=${MM_PASSWORD:-mmuser_password}
MM_DBNAME=${MM_DBNAME:-mattermost}

echo -ne "Configure database connection..."
if [ ! -f ${CONFIG} ]
then
    cp /config.template.json ${CONFIG}
    sed -Ei "s/DB_HOST/$DB_HOST/" ${CONFIG}
    sed -Ei "s/DB_PORT/$DB_PORT/" ${CONFIG}
    sed -Ei "s/MM_USERNAME/$MM_USERNAME/" ${CONFIG}
    sed -Ei "s/MM_PASSWORD/$MM_PASSWORD/" ${CONFIG}
    sed -Ei "s/MM_DBNAME/$MM_DBNAME/" ${CONFIG}
    echo OK
else
    echo SKIP
fi

echo "Wait until database ${DB_HOST}:${DB_PORT} is ready..."
until nc -z ${DB_HOST} ${DB_PORT}
do
    sleep 10
done

# Wait to avoid "panic: Failed to open sql connection pq: the database system is starting up"
sleep 10

echo "Starting platform"
cd /mattermost/bin
./platform $*
