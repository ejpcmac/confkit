###############
# Nix Aliases #
###############

# nix
alias nb='nix build'
alias nd='nix develop'
alias nfa='nix flake archive'
alias nfcl='nix flake clone'
alias nfl='nix flake lock'
alias nflu='nix flake lock --update-input'
alias nfu='nix flake update'
alias npdc='nix profile diff-closures'
alias nph='nix profile history'
alias npi='nix profile install'
alias npl='nix profile list'
alias npr='nix profile remove'
alias nprb='nix profile rollback'
alias npu='nix profile upgrade'
alias npua="nix profile upgrade '.*'"
alias ns='nix search'
alias nsp='nix search nixpkgs'
alias nsh='nix shell'
alias nso='nix store optimise'
alias nwd='nix why-depends'

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

# NixOS rebuild
alias snors="sudo nixos-rebuild switch"
alias snorb="sudo nixos-rebuild boot"

# nixos-container
alias ncl='nixos-container list'
alias ncc='nixos-container create'
alias ncd='nixos-container destroy'
alias ncs='nixos-container status'
alias ncst='nixos-container start'
alias ncsp='nixos-container stop'
alias nclo='nixos-container login'
alias ncrlo='nixos-container root-login'
alias ncr='nixos-container run'
alias ncip='nixos-container show-ip'
alias ncu='nixos-container update'

# sudo nixos-container operations
alias sncc='sudo nixos-container create'
alias sncd='sudo nixos-container destroy'
alias sncst='sudo nixos-container start'
alias sncsp='sudo nixos-container stop'
alias snclo='sudo nixos-container login'
alias sncrlo='sudo nixos-container root-login'
alias sncr='sudo nixos-container run'
alias sncu='sudo nixos-container update'

# home-manager
alias h='home-manager'
alias hb='home-manager build'
alias hs='home-manager switch'
alias hp='home-manager packages'
alias hn='home-manager news'
alias hgen='home-manager generations'

# nix-collect-garbage
alias ngc='nix-collect-garbage'
alias ngco='nix-collect-garbage --delete-older-than 30d'
