#!/bin/bash

set -ex

# setup new run user
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

APACHE_RUN_USER=www-data
APACHE_RUN_GROUP=root

# populate nextcloud
if [ ! -d /var/www/html/config ]; then
  apachectl start

  for i in $(seq 1 10); do
    echo $i
    sleep 1
    curl -sf localhost:8080 -o /dev/null && break
  done

  # configure redis for nextcloud if set
  if [ -z $REDIS_HOST ] && [ -z $REDIS_PORT ]; then
    php occ config:system:set 'memcache.local' --value '\\OC\\Memcache\\Redis'
    php occ config:system:set 'redis' 'host' --value "$REDIS_HOST"
    php occ config:system:set 'redis' 'port' --value "$REDIS_PORT"
  fi

  apachectl stop
fi

exec apache2-foreground
