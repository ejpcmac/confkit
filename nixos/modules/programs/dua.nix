####### Configuration for dua ##################################################
##                                                                            ##
## * Alias `du` to `dua`                                                      ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.programs.dua;
in

{
  options.confkit.programs.dua = {
    enable = mkEnableOption "the confkit configuration for dua";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.dua ];

      shellAliases = {
        du = "dua";
      };
    };
  };
}
