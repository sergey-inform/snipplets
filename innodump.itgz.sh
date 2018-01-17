#!/usr/bin/env bash

# Make full backup of selected databases with xtrabackup.

PASS=P@SSW0RD:)

DEST=/data/backup/db/fulldump.tar.gz
# TODO: $(dirname "$DEST")/$(basename "$DEST")
DEST_TEMP=${DEST}~

LOGFILE=${DEST}.log

INNO_OPTS="--no-timestamp --user root --no-lock "
MYADMIN_OPTS="-u root"

#DATABASES="linguadb"

# ==============================================

set -o errexit
set -o pipefail

[ -z $DATABASES ] || INNO_OPTS="$INNO_OPTS --databases=$DATABASES"
[ -z $PASS ] || {
        INNO_OPTS="$INNO_OPTS --pass $PASS"
        MYADMIN_OPTS="$MYADMIN_OPTS -p${PASS}"
}

echo $PASS $DATABASES

BENICE="ionice -c 3 nice "
BENICE=" "

mkdir -p $(dirname "$DEST")
echo Started: `date`

# Flush tables and logs
echo mysqladmin ${MYADMIN_OPTS} flush-tables flush-logs

# Clear logfile
echo > $LOGFILE

# Make full dump
# xtrabackup_binary goes to tmp, but it contains only string "xtrabackup", so there is no need to worry about it.
time $BENICE innobackupex-1.5.1 $INNO_OPTS --stream=tar /tmp/ 2>> "$LOGFILE" | pv | $BENICE pigz > "$DEST_TEMP"
echo Backup done `date`.

# Replace old dump with the new one
mv -T "$DEST_TEMP" "$DEST"

echo All finished: `date`.
