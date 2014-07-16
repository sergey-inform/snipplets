#!/usr/bin/env bash
#
# Post screenshot to logbook.
# Author: Sergey Ryzhikov (IHEP@Protvino) sergey-inform@ya.ru
#
######################################

#set -e #exit on error
WINDOW_WIDTH=350
WINDOW_TITLE="Save screenshot?"

mkdir -p ~/screenshots
TMPFILE=~/screenshots/`date +%s`.png

command -v import 2>/dev/null || { echo ImageMagic not installed.; exit 1; }
command -v zenity 2>/dev/null || { echo Zenity not installed.; exit 1; }

import -frame -border png:${TMPFILE} && \
DESTFILE=$(
        zenity --entry \
        --width=${WINDOW_WIDTH} \
        --title="${WINDOW_TITLE}" \
        --text="Enter filename:" \
        --entry-text "$TMPFILE"
)
if [ $? -ne 0 ]
then 
        rm $TMPFILE
        exit 0
fi

if [ "$TMPFILE" != "$DESTFILE" ]
then
        errtext=$( mv "$TMPFILE" "$DESTFILE" 2>&1) || \
                zenity --error --text "$errtext"
fi

