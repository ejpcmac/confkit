autoload -U colors && colors

# Set the prompt to `[user@host.domain]:/path %` in green, or in red for root.
if [ "`id -u`" -eq 0 ]; then
    PS1="%{$fg_bold[red]%}[%n@%M]:%{$reset_color%}%d %# "
else
    PS1="%{$fg_bold[green]%}[%n@%M]:%{$reset_color%}%~ %# "
fi

# Show the time in the right prompt.
RPS1="%{$fg[cyan]%}[%D{%H:%M:%S}]%{$reset_color%}"
