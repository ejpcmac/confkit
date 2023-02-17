####### Configuration for the shell ############################################
##                                                                            ##
## * Make `tree`, `grep` and `ls` colourful                                   ##
## * Set custom colours for `ls`                                              ##
## * Make `df` and `du` human-readable                                        ##
## * Define `ll`, `la` and `lla` quasi-standard aliases                       ##
## * Always use the system `ls` on Darwin                                     ##
## * Define `nors` for `nixos-rebuild switch` or `darwin-rebuild switch`      ##
## * Define `nic{l,a,r,u}` for `nix-channel --{list,add,remove,update}`       ##
## * Keep the compressed version when using `unxz`                            ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  inherit (pkgs) stdenv;

  cfg = config.confkit.features.shell;

  nixos-rebuild = if stdenv.isDarwin then "darwin-rebuild" else "nixos-rebuild";
in

{
  options.confkit.features.shell = {
    enable = mkEnableOption "the shell configuration from confkit";
  };

  config = mkIf cfg.enable {
    environment = {
      variables =
        if stdenv.isDarwin then {
          LSCOLORS = mkDefault "exfxcxdxbxabadBhFhehgh";
        } else {
          LS_COLORS = mkDefault "di=34:ln=35:so=32:pi=33:ex=31:bd=30;41:cd=30;43:su=1;31;47:sg=1;35;47:tw=34;47:ow=36;47";
        };

      shellAliases = {
        # Coloured `tree`, `grep` and `ls`
        tree = "tree -C";
        grep = "grep --color=auto";
        ls =
          if stdenv.isLinux then "ls -h --color=auto"
          else if stdenv.isDarwin then "/bin/ls -Gh"
          else "ls -Gh";

        # Human-readable `df` and `du`
        df = "df -h";
        du = "du -h";

        # Shortcuts for `ls`
        ll = "ls -l";
        la = "ls -A";
        lla = "ls -Al";

        # Keep compressed version when using `unxz`
        unxz = "unxz -kv";

        # Handy nixos-rebuild aliases
        nor = nixos-rebuild;
        nors = "${nixos-rebuild} switch";
        norb = "${nixos-rebuild} boot";

        # Handy nix-channel aliases
        nic = "nix-channel";
        nicl = "nix-channel --list";
        nica = "nix-channel --add";
        nicr = "nix-channel --remove";
        nicu = "nix-channel --update";
      };
    };
  };
}
