#!/bin/bash
# Sergey Ryzhikov: sergey-werk@ya.ru
# 12.2012
#
# Dump all databases to file.

set -o pipefail

PASSFILE=/etc/mysql/debian.cnf
BKPDIR=/backup/db
BKPNUM=`date +[%d]`
BKPSUFF=.dump.gz
EXCLUDE="mysql|information_schema|performance_schema|.+_dev"

# # # # # # # # # # # # # # # # # # # # # # # 

DBLIST=`mysql --defaults-file=${PASSFILE} -Bse 'show databases;' | grep -Ev "(${EXCLUDE})"`

for DB in $DBLIST
do

# Rotate files
! rm -f $(printf %q "${BKPDIR}/${DB}${BKPNUM}")*

# Dump
mysqldump --defaults-file=${PASSFILE} --opt --hex-blob --force $DB |\
        nice ionice -c 3 gzip > ${BKPDIR}/${DB}${BKPNUM}${BKPSUFF} 

done
