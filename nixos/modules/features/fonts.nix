####### Configuration for the fonts ############################################
##                                                                            ##
## * Enable the default fonts                                                 ##
## * Optionally install more fonts                                            ##
## * Enable embedded bitmaps for fonts like Calibri                           ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.confkit.features.fonts;
in

{
  options.confkit.features.fonts = {
    enable = mkEnableOption "the fonts configuration from confkit";

    installFonts = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Wether to install some fonts.";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultFonts = true;

      fonts = with pkgs; mkIf cfg.installFonts [
        carlito # Compatible with Calibri.
        eb-garamond
        fira
        fira-code
        lato
        libertine
        noto-fonts
        open-sans
        source-code-pro
        source-sans-pro
        source-serif-pro
      ];

      fontconfig = {
        includeUserConf = false;
        useEmbeddedBitmaps = true; # Useful for fonts like Calibri.
      };
    };
  };
}
