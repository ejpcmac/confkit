#######################
# Aliases & Functions #
#######################

# Configuration
alias oc='emacsclient --create-frame --no-wait /config'
alias ocd='cd /config'

# Zsh
alias rz='source ~/.zshrc'
alias zu='upgrade_oh_my_zsh && update-zsh-plugins'
alias zi='install-zsh-plugins'

# Files
alias gmod='__smod 0755 0644'
alias gmodg='__smod 0775 0664'

# GPG
alias gpg-e='gpg --edit-key'
alias gpg-cs='gpg --check-sigs'

# Emacs
alias ec='emacsclient'
alias ecc='emacsclient --create-frame --no-wait'
alias ect='emacsclient --tty'

# Miscellanous
alias ra='ranger'
alias sra='sudo ranger'
alias e='code .'
alias wn='watch -n 1 nmcli'
alias di='diceware --fr -s 8'

# Easter Eggs
alias love='echo ❤️'

##
## Functions
##

# Files
__smod() {
    if [ $# -ne 3 ]; then
        echo "usage: __smod <dmod> <fmod> <dir>"
        return 1
    fi

    local dmod=$1
    local fmod=$2
    local dir=$3

    find $dir -type d -print0 | xargs -0 chmod $dmod
    find $dir -type f -print0 | xargs -0 chmod $fmod
}


# Random string generation
random-string() {
    if [[ $# -ne 1 ]]; then
        echo "usage: random-string <num_chars>"
        return 1
    fi

    tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' < /dev/random \
        | head -c $1; echo
}

##
## Oh My Zsh plugin management (TODO: Nixify)
##

install-zsh-plugins() {
    git clone https://github.com/gusaiani/elixir-oh-my-zsh.git $ZSH_CUSTOM/plugins/elixir
    git clone https://github.com/chisui/zsh-nix-shell.git $ZSH_CUSTOM/plugins/nix-shell
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
}

update-zsh-plugins() {
    current_pwd=$(pwd)

    cd $ZSH_CUSTOM/plugins
    for plugin (*~example); do
        echo
        echo "Updating $plugin..."
        cd $plugin && git pull
        cd ..
    done

    cd "$current_pwd"
}
