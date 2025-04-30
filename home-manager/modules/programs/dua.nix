####### Configuration for dua ##################################################
##                                                                            ##
## * Alias `du` to `dua`                                                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.confkit.programs.dua;
  zsh = config.confkit.programs.zsh.enable;
in

{
  options.confkit.programs.dua = {
    enable = mkEnableOption "the confkit home configuration for dua";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.dua ];

    programs.zsh.shellAliases = mkIf zsh {
      du = mkDefault "dua";
    };
  };
}
