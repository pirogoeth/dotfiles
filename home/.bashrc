# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

BASHRC_LOADED="yes";    export BASHRC_LOADED

if [[ -z "${PROFILE_LOADED}" ]] ; then
    source ${HOME}/.bash_profile
fi

 # If not running interactively, don't do anything
[ -z "$PS1" ] && return

 # don't put duplicate lines in the history. See bash(1) for more options
 # ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

 # append to the history file, don't overwrite it
shopt -s histappend

 # super fabulous shell options
shopt -s cdspell checkjobs extglob histreedit histverify hostcomplete

 # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2500
HISTFILESIZE=8000

 # check the window size after each command and, if necessary,
 # update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

 # force colors in the prompt
force_color_prompt=yes

 # enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ${HOME}/.dircolors && eval "$(dircolors -b ${HOME}/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# if exa is available, use it instead!
_exa_path="$(which exa 2>/dev/null)"
if [ $? == 0 ] && [ ! -z "${_exa_path}" ] ; then
    alias ls='exa'
fi

 # Add an "alert" alias for long running commands.  Use like so:
 #   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ${HOME}/.bash_aliases ]; then
    . ${HOME}/.bash_aliases
fi

 # enable programmable completion features (you don't need to enable
 # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
 # sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[[ $PS1 && -f /usr/local/share/bash-completion/bash_completion.sh ]] && \
    source /usr/local/share/bash-completion/bash_completion.sh
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    source /usr/share/bash-completion/bash_completion

# shell options
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# add alias for npm-exec
alias npm-exec='PATH=$(npm bin):$PATH'
if [[ ! -z "$(which nvim)" ]] ; then
    alias vim="$(which nvim)"
fi

# backup the path to revert after workon/activate in venv
export __PATH="$PATH"

# import utility stubs
if [[ -z "${STUBS_LOADED}" ]] ; then
    source ${HOME}/.bash/stubs.sh
fi
