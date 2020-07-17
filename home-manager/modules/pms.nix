####### Configuration for pms ##################################################
##                                                                            ##
## * Configure the columns to artist,disc,track,title,album,year,time         ##
## * Bind u and q to update the DB and quit                                   ##
## * Bind C-l to viewport middle like in Emacs                                ##
## * Optionally use keybindings optimised for BÉPO keyboards                  ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.confkit.pms;
in

{
  options.confkit.pms = {
    enable = mkEnableOption "the confkit home configuration for pms";

    bepo = mkOption {
      type = types.bool;
      default = config.confkit.keyboard.bepo;
      example = true;
      description = "Use keybindings optimised for BÉPO keyboards.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.bepo;
        message = ''
          Please set confkit.pms.bepo = true. There is currently no non-BÉPO
          configuration for pms in confkit.
        '';
      }
    ];

    home.packages = with pkgs; [ pms ];

    xdg.configFile."pms/pms.conf".source = ../../misc/pms_bepo.conf;
  };
}
