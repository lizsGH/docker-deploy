#!/bin/bash
# order=1

sudo service cron start

sudo mkdir -p $BACKUP_DIR

CRONTAB_FILE=$INIT_DIR/main.d/crontab
# create crontab
sudo crontab -u root $CRONTAB_FILE 

