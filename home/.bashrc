# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

BASHRC_LOADED="yes";    export BASHRC_LOADED

if [[ -z "${PROFILE_LOADED}" ]] ; then
    source ~/.bash_profile
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
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

 # some more ls aliases
alias ls='ls -G'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias for dmenu + lpass
alias dmenu_lpass='lpass ls | awk -f ~/.bash/lpass-ls.awk | dmenu -i -b -l 8 -p "lpass> " | xargs -I {} lpass show "{}" | grep "Password" | awk "{ print \$2 }" | xclip -i -loops 1 -verbose -selection clipboard'

 # Add an "alert" alias for long running commands.  Use like so:
 #   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# add alias for npm-exec
alias npm-exec='PATH=$(npm bin):$PATH'
if [[ ! -z "$(which nvim)" ]] ; then
    alias vim="$(which nvim)"
fi

# backup the path to revert after workon/activate in venv
export __PATH="$PATH"

# alias for homeshick, if it's uninstalled
if [[ ! -d "$HOME/.homesick/repos/homeshick" ]] ; then
    function homeshick () {
        echo " [!] Homeshick is not installed -- installing now!"
        mkdir -p $HOME/.homesick/repos
        git clone -q https://github.com/andsens/homeshick.git \
            $HOME/.homesick/repos/homeshick
        if [[ "$?" != "0" ]] ; then
            echo " [-] Git threw an error.."
        else
            unset -f homeshick
            source "$HOME/.homesick/repos/homeshick/homeshick.sh"
            source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
            echo " [+] Done!"
        fi
    }
    export -f homeshick
else
    source "$HOME/.homesick/repos/homeshick/homeshick.sh"
    source "$HOME/.homesick/repos/homeshick/completions/homeshick-completion.bash"
fi

# alias for asdf, if it's uninstalled
if [[ ! -d "$HOME/.asdf" ]] ; then
    function asdf () {
        echo " [!] asdf-vm is not installed -- installing now!"
        git clone -q https://github.com/asdf-vm/asdf.git \
            $HOME/.asdf
        if [[ "$?" != "0" ]] ; then
            echo " [-] Git threw an error.."
        else
            unset -f asdf
            source "$HOME/.asdf/asdf.sh"
            source "$HOME/.asdf/completions/asdf.bash"
            echo " [+] Done!"
        fi
    }
    export -f asdf
else
    source "$HOME/.asdf/asdf.sh"
    source "$HOME/.asdf/completions/asdf.bash"
fi
