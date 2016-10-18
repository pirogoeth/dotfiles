#
# stubs.sh -- collection of stubs to easily install utilities
#

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

# alias for ntfy, if it's uninstalled
if [[ -z `which ntfy 2>/dev/null` ]] ; then
    function ntfy () {
        echo " [!] ntfy is not installed -- installing now!"
        sudo pip -q install -U ntfy
        if [[ "$?" != "0" ]] ; then
            echo " [-] Pip threw an error during install.."
            return 1
        else
            unset -f ntfy
            if [[ ! -z `which ntfy 2>/dev/null` ]] ; then
                echo " [+] Done!"
            else
                echo " [!] Installation succeeded, but can't find path to executable 'ntfy'.."
            fi
        fi
    }
    export -f ntfy
fi

# alias for gimme, if it is not present
if [[ -z "$(which gimme 2>/dev/null)" ]] ; then
    function gimme() {
        echo " [!] gimme is not installed -- installing now!"
        if [[ -d "$HOME/.bin" ]] && [[ ! -z "$(echo $PATH | grep $HOME/.bin)" ]] ; then
            # installing to local user bin directory
            curl -sL -o $HOME/.bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
            chmod +x $HOME/.bin/gimme
        else
            # install to system-wide bin
            sudo curl -sL -o /usr/local/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
            if [[ $? != 0 ]] ; then
                echo " [-] Could not download gimme to /usr/local/bin"
                return 1
            else
                sudo chmod +x /usr/local/bin/gimme
            fi
        fi

        if [[ ! -z "$(which gimme 2>/dev/null)" ]] ; then
            echo " [+] Done!"
            unset -f gimme
        else
            echo " [!] Installation seemed successful, but can't find path to 'gimme'.."
        fi
    }
    export -f gimme
fi

# alias for the dokku client, if it is not present
if [[ -z "`alias | grep dokku`" ]] && [[ ! -d "$HOME/.dokku" ]] ; then
    function dokku() {
        echo " [!] dokku_client.sh is not installed -- installing now!"
        if [[ ! -d "$HOME/.dokku" ]] ; then
            git clone -q https://github.com/dokku/dokku.git $HOME/.dokku
            if [[ $? != 0 ]] ; then
                echo " [-] Git threw an error while cloning dokku.."
            else
                chmod +x $HOME/.dokku/contrib/dokku_client.sh
                unset -f dokku
                alias dokku="$HOME/.dokku/contrib/dokku_client.sh"
                $HOME/.dokku/contrib/dokku_client.sh $*
            fi
        else
            unset -f dokku
            alias dokku="$HOME/.dokku/contrib/dokku_client.sh"
            $HOME/.dokku/contrib/dokku_client.sh $*
        fi
    }
    export -f dokku
else
    alias dokku="$HOME/.dokku/contrib/dokku_client.sh"
fi

