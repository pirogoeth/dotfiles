#!/usr/bin/env bash

# This script sets up a hookable shutdown system for a bash shell.

SHUTDOWN_FC_LOADED="yes";       export SHUTDOWN_FC_LOADED

declare -a __shutdown_func=()

function bshu_add_func() {
    if [ -z "${1}" ] ; then
        return 1
    fi

    __fname=$1
    __ftype="$(type -t ${__fname})"
    if [ -n "${__ftype}" ] && [ "${__ftype}" == "function" ] ; then
        __shutdown_func+=(${__fname})
    else
        return 1
    fi
}

function bshu_del_func() {
    if [ -z "${1}" ] ; then
        return -1
    fi

    __fname=$1
    found=0
    for func in ${__shutdown_func[@]}
    do
        if [ "${func}" == "${__fname}" ] ; then
            found=1
            break
        fi
    done

    if [ $found == 1 ] ; then
        __shutdown_func=( "${__shutdown_func[@]//$__fname}" )
        return 0
    else
        return 1
    fi
}

function __bash_shutdown() {
    for i in "${!__shutdown_func[@]}"
    do
        ${__shutdown_func[$i]}
    done
}

trap __bash_shutdown EXIT
