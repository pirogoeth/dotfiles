#!/usr/bin/env bash

# This magical little part will check for the existence of a .bin
# folder in the user's home directory, find any subdirectories that
# have a bin folder in them, and add that directory to the user's path/

BINS_LOADED="YES";      export BINS_LOADED

BIN_DIR="${HOME}/.bin"
if [[ ! -d "${BIN_DIR}" ]] ; then
    exit
fi

for subdir in $(ls $BIN_DIR) ; do
    subdir="${BIN_DIR}/${subdir}"
    if [[ -d "${subdir}/bin" ]] ; then
        bindir="${subdir}/bin"
        PATH="${PATH}:${bindir}";   export PATH
    fi
done
