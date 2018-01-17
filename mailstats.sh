#!/bin/bash

# Make yesterday mail sending statistics

set -o errexit
set -o pipefail

LOGFILE="/var/log/mail.log"
STATFILE="/data/lingualeo/log/mailstats/`date +%F`.stats"
OPTS="-d yesterday --problems_first --detail 20"

/usr/sbin/pflogsumm $OPTS "$LOGFILE" > "$STATFILE"
