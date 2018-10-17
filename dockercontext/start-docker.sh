#!/bin/bash

sudo -u www-data --preserve-env /postConfiguration.sh &

exec /entrypoint.sh apache2-foreground
