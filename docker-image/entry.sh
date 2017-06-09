#!/usr/bin/env bash

set -e

[ "$DEBUG" == 'true' ] && set -x

echo ">> Strider Docker Image $STRIDER_VERSION Starting..."

## Check that SMTP variables are defined
#if [ -z "${SMTP_PORT_587_TCP_ADDR}" -a -z "$SMTP_HOST" ]; then
#    echo "You must link this container with SMTP or define SMTP_HOST"
#    exit 1
#fi
#
## Alias SMTP variables
#if [ -z "$SMTP_HOST" ]; then
#    export SMTP_HOST="${SMTP_PORT_587_TCP_ADDR:-localhost}"
#    export SMTP_PORT="${SMTP_PORT_587_TCP_PORT:-587}"
#    echo "$(basename $0) >> Set SMTP_HOST=$SMTP_HOST, SMTP_PORT=$SMTP_PORT"
#fi
#
## Wait for SMTP to be available
#while ! exec 6<>/dev/tcp/${SMTP_HOST}/${SMTP_PORT}; do
#    echo "$(date) - waiting to connect to SMTP at ${SMTP_HOST}:${SMTP_PORT}"
#    sleep 1
#done
#
#exec 6>&-
#exec 6<&-

# Extract port / host for testing below
MONGO_PORT=$(python -c "from urlparse import urlparse; print urlparse('$DB_URI').port")
MONGO_HOST=$(python -c "from urlparse import urlparse; print urlparse('$DB_URI').hostname")

# Wait for Mongo to be available
while ! exec 6<>/dev/tcp/${MONGO_HOST}/${MONGO_PORT}; do
    echo "$(date) - waiting to connect to MONGO at ${MONGO_HOST}:${MONGO_PORT}"
    sleep 1
done

exec 6>&-
exec 6<&-

# Create admin user if variables defined
if [ ! -z "$STRIDER_ADMIN_EMAIL" -a ! -z "$STRIDER_ADMIN_PASSWORD" ]; then
    echo "$(basename $0) >> Running addUser"
    strider addUser --email $STRIDER_ADMIN_EMAIL --password $STRIDER_ADMIN_PASSWORD --force --admin true
    echo "$(basename $0) >> Created Admin User: $STRIDER_ADMIN_EMAIL, Password: $STRIDER_ADMIN_PASSWORD"
fi

echo "Executing command $@"
exec "$@"
