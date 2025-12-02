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
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

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
        codium --wait flake.nix
    fi

    if [ ! -e ./.envrc ]; then
        cat > .envrc << 'EOF'
watch_file flake.nix flake.lock
use flake . --print-build-logs
EOF
        direnv allow
    fi
}

nixify-rust() {
    if [ ! -e flake.nix ]; then
        cat > flake.nix << 'EOF'
{
  description = "A Rust development shell.";

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

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { system, ... }:
        let
          overlays = [ (import inputs.rust-overlay) ];
          pkgs = import inputs.nixpkgs { inherit system overlays; };
          rust-toolchain = pkgs.rust-bin.stable.latest.default;
          # rust-toolchain =
          #   pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
        in
        {
          devshells = {
            default = {
              name = "Rust";

              packages = with pkgs; [
                # Build toolchain
                rust-toolchain

                # IDE Toolchain
                nixd
                rust-analyzer

                # Development tools
                bacon
                cargo-nextest
              ] ++ lib.optionals (!stdenv.isDarwin) [
                clang
              ];

              env = [
                {
                  name = "RUSTFLAGS";
                  value = "-Clink-arg=-fuse-ld=${pkgs.mold}/bin/mold";
                }
                {
                  name = "NIX_PATH";
                  value = "nixpkgs=${inputs.nixpkgs}";
                }
                {
                  name = "TYPOS_LSP_PATH";
                  value = "${pkgs.typos-lsp}/bin/typos-lsp";
                }
              ];
            };

            # Devshell to run tools with a nightly toolchain.
            rust-nightly = {
              name = "Rust Nightly";

              packages = [
                pkgs.rust-bin.nightly."XXXX-XX-XX".minimal
              ];
            };
          };
        };
    };
}
EOF
        sed -e "s/XXXX-XX-XX/$(date +%Y-%m-%d)/" -i flake.nix
        git add --intent-to-add flake.nix
        codium --wait flake.nix
    fi

    if [ ! -e ./.envrc ]; then
        cat > .envrc << 'EOF'
watch_file flake.nix flake.lock rust-toolchain.toml
use flake . --print-build-logs
EOF
        direnv allow
    fi
}
