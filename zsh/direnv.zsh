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
    if [ ! -e flake.nix ]; then
        cat > flake.nix << 'EOF'
{
  description = "A generic development shell.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];
      systems = [ "x86_64-linux" ];

      perSystem = { system, ... }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          devshells.default = {
            name = "devshell";

            packages = with pkgs; [
              # Add dependencies here.
            ];
          };
        };
    };
}
EOF
        git add --intent-to-add flake.nix
        $EDITOR flake.nix
    fi

    if [ ! -e ./.envrc ]; then
        cat > .envrc << 'EOF'
watch_file flake.nix flake.lock
use flake . --print-build-logs
EOF
        direnv allow
    fi
}
