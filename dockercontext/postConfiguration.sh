#!/bin/bash

set -ex

# wait for nextcloud become installed
while true; do
  if $(php occ config:system:get installed &> /dev/null); then
    if [ "$(php occ config:system:get installed)" == 'true' ] || [ "$(php occ config:system:get installed)" = *"require upgrade"* ]; then
      break;
    fi
  fi

  sleep 10
done

# configure redis for nextcloud if set
if [ ! -z $REDIS_HOST ] && [ ! -z $REDIS_PORT ]; then
  php occ config:system:set 'memcache.locking' --value '\OC\Memcache\Redis'
  php occ config:system:set 'redis' 'host' --value "$REDIS_HOST"
  php occ config:system:set 'redis' 'port' --value "$REDIS_PORT"
  php occ config:system:set trusted_domains 1 --value "$NEXTCLOUD_SERVICE_HOST"
  php occ config:system:set trusted_domains 2 --value "$(hostname -I | xargs)"
  php occ config:system:set 'datadirectory' '/appdata'

  # must be the last configuration line as Nextcloud will override it
  # after another setting
  php occ config:system:set 'memcache.local' --value '\OC\Memcache\Redis'
fi
