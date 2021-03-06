#!/bin/bash

set -ex

# wait for nextcloud become installed
while true; do
  if $(php occ config:system:get installed &> /dev/null); then
    if [[ "$(php occ config:system:get installed)" =~ 'true' ]]; then
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
  php occ config:system:set trusted_domains 0 --value "$NEXTCLOUD_PUBLIC_HOSTNAME"
  php occ config:system:set trusted_domains 1 --value "$NEXTCLOUD_SERVICE_HOST"
  php occ config:system:set trusted_domains 2 --value "$(hostname -I | xargs)"
  php occ config:system:set 'overwrite.cli.url' --value "http://$NEXTCLOUD_PUBLIC_HOSTNAME"
  php occ config:system:set 'overwriteprotocol' --value 'https'
  php occ config:system:set 'datadirectory' --value "$NEXTCLOUD_DATA_DIR"

  # must be the last configuration line as Nextcloud will override it
  # after another setting
  php occ config:system:set 'memcache.local' --value '\OC\Memcache\Redis'
fi

# Preview Generator
# https://apps.nextcloud.com/apps/previewgenerator
# https://nextcloud.com/blog/setup-cron-or-systemd-timers-for-the-nextcloud-preview-generator/

while [ true ]; do
  # wait until 01:00 AM UTC (3 AM in Germany)
  # https://stackoverflow.com/questions/645992/bash-sleep-until-a-specific-time-date
  sleep $((($(date -f - +%s- <<<$'01:00 tomorrow\nnow')0)%86400))
  sudo -u www-data /usr/local/bin/php -d memory_limit=2048M -f /var/www/html/occ preview:pre-generate
done
