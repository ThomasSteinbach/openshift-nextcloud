#!/bin/bash

sudo -u www-data --preserve-env /postConfiguration.sh &

exec apache2-foreground
