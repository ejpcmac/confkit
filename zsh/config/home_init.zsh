###########
# Plugins #
###########

function export_local_bin() {
    if [ -z "$IN_NIX_SHELL" ]; then
        export PATH=$HOME/.local/bin:$PATH
    fi
}

# Some plugins may need local programs to work.
export_local_bin

for script ($HOME/.zsh/*.zsh); do
    source $script
done
unset script

# Local programs have precedence on plugins.
export_local_bin

##########
# Prompt #
##########

# Set the prompt color: blue in Nix shells, red for root and green otherwise.
prompt_color() {
    if [ -n "$IN_NIX_SHELL" ]; then
        echo "$fg_bold[blue]"
    elif [ $(id -u) -eq 0 ]; then
        echo "$fg_bold[red]"
    else
        echo "$fg_bold[green]"
    fi
}

autoload -U add-zsh-hook && add-zsh-hook precmd prompt_precmd
function prompt_precmd() {
    PROMPT="%{$(prompt_color)%}[%n@%m]:%{$reset_color%}%~ %# "
}
