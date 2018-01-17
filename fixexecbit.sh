#!/bin/bash

# Set chmod +x on files that looks like shell scripts

############## do not edit below this line ################
REM() { echo -e 1>&2 '\E[32m' "$@" '\e[0m'; }


set -o errexit
set -o pipefail

cd $1

REM \* search in subdirs and make chmod +x on files that looks like scripts
find -type f -not -name ".*" -not -path '*/.*' -not -empty -not -executable \
        -execdir sed -e '/^#\!\/bin\//Q' -e'Q1' {} \; \
        -execdir chmod +x {} \; \
        -print

REM Done.
