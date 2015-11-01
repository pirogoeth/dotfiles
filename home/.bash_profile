#!/usr/bin/env bash

# Set PROFILE_LOADED to keep out of a sourcing loop.
PROFILE_LOADED="yes";   export PROFILE_LOADED

# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add rvm gems and nginx to the path
# export PATH=$PATH:~/.gem/ruby/2.8/bin:/opt/nginx/sbin
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin

# These are normally set through /etc/login.conf.  You may override them here
# if wanted.
# PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:$HOME/bin; export PATH
# BLOCKSIZE=K;	export BLOCKSIZE

# Setting TERM is normally done through /etc/ttys.  Do only override
# if you're sure that you'll never log in via telnet or xterm or a
# serial line.
TERM=xterm;          	export TERM
NO_COLOR="NO";         export NO_COLOR

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set git_ps1 magic features :]
export GIT_PS1_SHOWDIRTYSTATE=true

# base bash completion
[[ -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
    source /usr/local/share/bash-completion/bash_completion.sh
[[ -f /usr/share/bash-completion/bash_completion ]] && \
    source /usr/share/bash-completion/bash_completion

# git completion and prompt
[[ -f $HOME/.bash/git-completion.sh ]] && \
    source $HOME/.bash/git-completion.sh
[[ -f $HOME/.bash/git-prompt.sh ]] && \
    source $HOME/.bash/git-prompt.sh

# bash theme
[[ -f $HOME/.bash/bash-theme.sh ]] && \
    source $HOME/.bash/bash-theme.sh

# bin loader
[[ -f $HOME/.bash/load-bin.sh ]] && [[ -z "${BINS_LOADED}" ]] && \
    source $HOME/.bash/load-bin.sh

# shutdown handler
[[ -f $HOME/.bash/bash-shutdown.sh ]] && [[ -z "${SHUTDOWN_FC_LOADED}" ]] && \
    source $HOME/.bash/bash-shutdown.sh

# common
[[ -f $HOME/.bash/common.sh ]] && [[ -z "${COMMON_LOADED}" ]] && \
    source $HOME/.bash/common.sh

EDITOR=vim;   	export EDITOR
PAGER=less;  	export PAGER

# set ENV to a file invoked each time sh is started for interactive use.
ENV=$HOME/.shrc; export ENV

# Check if the bashrc was loaded, and source it if not.
[[ -z "${BASHRC_LOADED}" ]] && \
    source $HOME/.bashrc

if [ -x /usr/games/fortune ] ; then /usr/games/fortune freebsd-tips ; fi
