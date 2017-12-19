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

# post configure nextcloud
if [ -f /var/www/html/config/config.php ]; then

  # configure redis for nextcloud if set
  if [ -z $REDIS_HOST ] && [ -z $REDIS_PORT ]; then
    php occ config:system:set 'memcache.local' --value '\\OC\\Memcache\\Redis'
    php occ config:system:set 'redis' 'host' --value "$REDIS_HOST"
    php occ config:system:set 'redis' 'port' --value "$REDIS_PORT"
  fi
fi

exec apache2-foreground
