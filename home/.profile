#!/usr/bin/env bash
# vim: set ai et ts=4 sts=4 sw=4 syntax=sh:
# -*- coding: utf-8 -*-

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ ! -z "${GDMSESSION}" ] ; then
    # restore backgrounds
    /usr/bin/nitrogen --restore
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# source localrc, if available
if [ -f "$HOME/.localrc" ] ; then
    if [ -z "${LOCALRC_LOADED}" ] ; then
        . "$HOME/.localrc"
        if [ ! -z "${GDMSESSION}" ] ; then
            unset LOCALRC_LOADED
        fi
    fi
fi
