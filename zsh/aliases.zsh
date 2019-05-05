#######################
# Aliases & Functions #
#######################

# Configuration
alias oc='emacsclient --create-frame --no-wait ~/config'
alias ocd='cd ~/config'

# Zsh
alias rz='source ~/.zshrc'
alias zu='upgrade_oh_my_zsh && update-zsh-plugins'
alias zi='install-zsh-plugins'

# Files
alias gmod='chmod -R u=rwX,go=rX'
alias gmodg='chmod -R ug=rwX,o=rX'

# GPG
alias gpg-e='gpg --edit-key'
alias gpg-cs='gpg --check-sigs'

# Emacs
alias ec='emacsclient'
alias ecc='emacsclient --create-frame --no-wait'
alias ect='emacsclient --tty'

# Miscellanous
alias ra='ranger'
alias e='code .'
alias di='diceware --fr -s 8'

# Easter Eggs
alias love='echo ❤️'

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
