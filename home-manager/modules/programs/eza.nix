####### Configuration for eza ##################################################
##                                                                            ##
## * Alias `ls` to `eza`                                                      ##
## * Define many standard aliases (la, ll, lla) to use eza                    ##
## * Define aliases for tree views (llt, llta, lltt, lltta)                   ##
## * Enable icons                                                             ##
## * Use binary prefixes                                                      ##
## * Show the header, blocksize, group and mountpoint in long views           ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.confkit.programs.eza;
  zsh = config.confkit.programs.zsh.enable;
in

{
  options.confkit.programs.eza = {
    enable = mkEnableOption "the confkit home configuration for eza";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.eza ];

    programs.zsh.shellAliases = mkIf zsh {
      ls = mkDefault "eza --icons";
      la = mkDefault "eza --icons -a";
      ll = mkDefault "eza --icons -lbghMS --group-directories-first";
      lla = mkDefault "ll -aa";
      llt = mkDefault "ll -TL2";
      llta = mkDefault "llt -a";
      lltt = mkDefault "ll -T";
      lltta = mkDefault "lltt -a";
    };
  };
}
