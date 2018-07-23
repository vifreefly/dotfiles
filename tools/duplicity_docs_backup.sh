#!/bin/bash

logger() {
  local GREEN="\033[1;32m"
  local NC="\033[00m"
  echo -e "${GREEN}Installer:${NC}"
}

# define all env variables for cron
source $HOME/Dropbox/configs/env_secrets.sh

# prepare notify-send to show notifications
# (linux desktop, it's need only when calling script from cron)
# this covers gnome-like environments and kde, check this manual for other DE's
# https://selivan.github.io/2016/07/08/notify-send-from-cron-in-ubuntu.html
# Also, if you don't have notify-send, install it first: `$ sudo apt install libnotify-bin`
# Note: if for reading /proc/.../environ system asks for a sudo, but you don't want to run
# this script as root (`sudo crontab -e`), add /bin/egrep to visudo (`$ sudo visudo`),
# `bob ALL=NOPASSWD: /bin/egrep` where bob is username.
# Then use `export $(sudo -S egrep` instead of `export $(egrep` .
export $(sudo -S egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session || pgrep -u $LOGNAME kdeinit | head -1)/environ)

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
/usr/bin/notify-send 'Docs Backup' 'Starting copyining...' --icon=dialog-information

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
/usr/bin/notify-send 'Docs Backup' 'Finished.' --icon=dialog-information

# done! To restore from command line, example:
# PASSPHRASE=passphrase duplicity restore webdavs://cloud_user:cloud_pass@webdav.yandex.ru/my_backups ~/restore
