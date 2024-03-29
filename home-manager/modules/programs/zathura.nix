####### Configuration for Zathura ##############################################
##                                                                            ##
## * Bind C-l to viewport middle like in Emacs                                ##
## * Optionally use keybindings optimised for BÉPO keyboards                  ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) bool;
  cfg = config.confkit.programs.zathura;
in

{
  options.confkit.programs.zathura = {
    enable = mkEnableOption "the confkit home configuration for Zathura";

    bepo = mkOption {
      type = bool;
      default = config.confkit.keyboard.layout == "bépo";
      example = true;
      description = "Use keybindings optimised for BÉPO keyboards.";
    };
  };

  config = mkIf cfg.enable {
    warnings =
      if !cfg.bepo then [
        "There is currently no non-BÉPO configuration for zathura in confkit."
      ] else [ ];

    programs.zathura = {
      enable = true;
      extraConfig = mkIf cfg.bepo (readFile ../../../misc/zathurarc_bepo);
    };
  };
}
