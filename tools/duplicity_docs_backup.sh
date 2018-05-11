#!/bin/bash

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Installer:${NC}"
}

# define all env variables for cron
source $HOME/Dropbox/configs/env_secrets.sh

# prepare notify-send
export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)

export XDEVICEFILES=1
export PASSPHRASE="$DUPLICITY_BACKUP_PASSPHRASE"

ORIGIN="$DUPLICITY_ORIGIN"
DEST="$DUPLICITY_DEST"
FILELIST="$DUPLICITY_FILTER_FILELIST_PATH"
DAYS_FULL=6
DAYS_STORE=30

echo "$(logger) Starting copyining backup... ($(date))"
/usr/bin/notify-send 'Docs Backup' 'Starting copyining...' --icon=dialog-information

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
/usr/bin/notify-send 'Docs Backup' 'Finished.' --icon=dialog-information
