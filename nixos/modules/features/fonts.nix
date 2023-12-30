####### Configuration for the fonts ############################################
##                                                                            ##
## * Enable the default fonts                                                 ##
## * Optionally install more fonts                                            ##
## * Enable embedded bitmaps for fonts like Calibri                           ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption;
  inherit (lib.types) bool;
  cfg = config.confkit.features.fonts;
in

{
  options.confkit.features.fonts = {
    enable = mkEnableOption "the fonts configuration from confkit";

    installFonts = mkOption {
      type = bool;
      default = true;
      example = false;
      description = "Wether to install some fonts.";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; mkIf cfg.installFonts [
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
        includeUserConf = mkDefault false;
        subpixel.rgba = "rgb";
        useEmbeddedBitmaps = mkDefault true; # Useful for fonts like Calibri.
      };
    };
  };
}
