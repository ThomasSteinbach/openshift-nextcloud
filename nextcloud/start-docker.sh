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

/postConfiguration.sh &

exec apache2-foreground
