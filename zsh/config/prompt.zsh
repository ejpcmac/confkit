setopt prompt_subst
autoload -U colors && colors

# Set the prompt to `[user@host.domain]:/path %` in red for root, in green for
# other users.
if [ $(id -u) -eq 0 ]; then
    PROMPT="%{$fg_bold[red]%}[%n@%M]:%{$reset_color%}%d %# "
else
    PROMPT="%{$fg_bold[green]%}[%n@%M]:%{$reset_color%}%~ %# "
fi

# Show the time in the right prompt.
RPROMPT="%{$fg[cyan]%}[%D{%H:%M:%S}]%{$reset_color%}"
