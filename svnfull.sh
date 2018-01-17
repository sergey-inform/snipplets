#!/bin/bash

# incremental backup for SVN

set -o errexit
set -o pipefail

REPO=lingualeo
SRC=/data/svn/repo/$REPO
DST=/data/backup/svn/
REV=$DST/$REPO-lastrev


NEWREV=`svnlook youngest $SRC`


svnadmin -q dump "$SRC" | gzip --rsyncable > "$DST/svn-$REPO-full.dump.gz.tmp"

#if ok
        echo -n "$NEWREV" > "$REV"
        mv "$DST/svn-$REPO-full.dump.gz.tmp" "$DST/svn-$REPO-full.dump.gz"

        #purge old incrementals
!       rm "$DST/svn-$REPO-inc"*
