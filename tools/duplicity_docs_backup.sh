#!/bin/bash

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Installer:${NC}"
}

# define all env variables for cron
source $HOME/Dropbox/configs/env_secrets.sh

# prepare notify-send to show notifications (linux desktop, not working on KDE)
# export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)

export XDEVICEFILES=1
# passphrase for duplicity arcives
export PASSPHRASE="$DUPLICITY_BACKUP_PASSPHRASE"

# example "/home/username"
ORIGIN="$DUPLICITY_ORIGIN"
# example "webdavs://cloud_user:cloud_pass@webdav.yandex.ru/my_backups"
DEST="$DUPLICITY_DEST"
# example "~/Dropbox/duplicity_filters.txt"
FILELIST="$DUPLICITY_FILTER_FILELIST_PATH"
DAYS_FULL=6
DAYS_STORE=30

echo "$(logger) Starting copyining backup... ($(date))"
# /usr/bin/notify-send 'Docs Backup' 'Starting copyining...' --icon=dialog-information

# to make a dry run add --dry-run
duplicity ${ORIGIN} ${DEST} \
          --full-if-older-than ${DAYS_FULL}D \
          --verbosity i \
          --asynchronous-upload \
          --progress \
          --include-filelist "$FILELIST"

echo "$(logger) Done. Now removing old backups from dest if older than 30 days..."
duplicity remove-older-than ${DAYS_STORE}D --force ${DEST}

# reset the ENV variables
unset XDEVICEFILES
unset PASSPHRASE

echo "$(logger) All done! ($(date))"
# /usr/bin/notify-send 'Docs Backup' 'Finished.' --icon=dialog-information

# done! To restore from command line, example:
# PASSPHRASE=passphrase duplicity restore webdavs://cloud_user:cloud_pass@webdav.yandex.ru/my_backups ~/restore
