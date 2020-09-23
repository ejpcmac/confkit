##############################
# direnv (Aliases & Helpers) #
##############################

##
## Aliases
##

# direnv
alias dl='cat $HOME/.local/share/direnv/allow/* | sort'
alias ds='direnv status'
alias de='direnv edit'
alias da='direnv allow'
alias dn='direnv deny'
alias dar='direnv deny && rm -rf .direnv'
alias dp='direnv prune'
alias dr='direnv reload'

##
## Helpers
##

nixify() {
    if [ ! -e ./.envrc ]; then
        echo "use nix" > .envrc
        direnv allow
    fi

    if [ ! -e shell.nix ]; then
        cat > shell.nix << 'EOF'
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    # Add dependencies here.
  ];
}
EOF
    $EDITOR shell.nix
    fi
}
