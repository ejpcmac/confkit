###############
# Nix Aliases #
###############

# nix-env
alias ne='nix-env'
alias ns='nix-env -qaP'
alias ni='nix-env --install'
alias nun='nix-env --uninstall'
alias nu='nix-env --upgrade'
alias nrb='nix-env --rollback'
alias neq='nix-env --query'
alias ngl='nix-env --list-generations'
alias ngs='nix-env --switch-generation'
alias ngd='nix-env --delete-generations'

# nix-channel
alias nic='nix-channel'
alias nicl='nix-channel --list'
alias nica='nix-channel --add'
alias nicr='nix-channel --remove'
alias nicu='nix-channel --update'
alias nicrb='nix-channel --rollback'

# root channels
alias snic='sudo nix-channel'
alias snicl='sudo nix-channel --list'
alias snica='sudo nix-channel --add'
alias snicr='sudo nix-channel --remove'
alias snicu='sudo nix-channel --update'
alias snicrb='sudo nix-channel --rollback'

# nix-build
alias nb='nix-build'

# nix-shell
alias nis='nix-shell'
alias nisp='nix-shell --pure'
alias niss='nix-instantiate shell.nix --indirect --add-root $PWD/shell.drv'

# nix-collect-garbage
alias ngc='nix-collect-garbage'
alias ngcd='nix-collect-garbage -d'
alias ngco='nix-collect-garbage --delete-older-than 30d'

# nix-store
alias nso='nix-store --optimise -v'

# home-manager
alias h='home-manager'
alias hb='home-manager build'
alias hs='home-manager switch'
alias hp='home-manager packages'
alias hn='home-manager news'
alias hgen='home-manager generations'

# NixOS rebuild
alias snors="sudo nixos-rebuild switch"
alias bnors="nix build --no-link -f '<nixpkgs/nixos>' config.system.build.toplevel && \
    nixos-rebuild switch"
alias sbnors="sudo su -c \"\
    nix build --no-link -f '<nixpkgs/nixos>' config.system.build.toplevel && \
    nixos-rebuild switch\""

##
## Helpers to preview the changes to the package list prior to rebuild.
##
## Usage:
##
## 1. Run `csp` to create the cache. Note that it will not list what is
##    currently installed on your system. It will instead evaluate what will be
##    your system after a rebuild.
##
## 2. Update your configuration and/or your channels.
##
## 3. Run `dsp` to print a diff between the cached version and the version that
##    would be applied by a rebuild.
##

alias esp='eval-system-packages'
alias eval-system-packages="nix-instantiate --strict --json --eval -E \
    'builtins.map (p: p.name) (import <nixpkgs/nixos> {}).config.environment.systemPackages' \
    | jq -r '.[]' \
    | sort -u"

alias csp='cache-system-packages'
alias cache-system-packages='eval-system-packages > ~/.cache/system-packages'

alias dsp='diff-system-packages'
alias diff-system-packages="eval-system-packages \
    | colordiff -y ~/.cache/system-packages -"
