###
### CONFIGURATION
###

export ADOTDIR="$HOME/.zsh/plugins"
export POWERLEVEL9K_INSTALLATION_PATH="$ADOTDIR/powerlevel9k.zsh-theme"

###
### PLUGIN LOADING
###

source $ADOTDIR/antigen/antigen.zsh

###
### ANTIGEN
###

# Use the oh-my-zsh core.
antigen use oh-my-zsh

# Add some oh-my-zsh bundles.
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Add additional antigen calls here!
#
#

# Apply the Antigen configuration.
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
