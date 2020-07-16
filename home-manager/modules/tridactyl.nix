####### Configuration for Tridactyl ############################################
##                                                                            ##
## * Optionally use keybindings optimised for BÉPO keyboards                  ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (builtins) readFile;
  inherit (lib) mkOption mkEnableOption mkIf optionalString types literalExample;
  cfg = config.confkit.tridactyl;
in

{
  options.confkit.tridactyl = {
    enable = mkEnableOption "the confkit home configuration for Tridactyl";

    bepo = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Use keybindings optimised for BÉPO keyboards.";
    };

    editor = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = literalExample "${pkgs.emacs}/bin/emacsclient --create-frame";
      description = "The editorcmd Tridactyl setting.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.bepo;
        message = ''
          Please set confkit.tridactyl.bepo = true. There is currently no
          non-BÉPO configuration for Tridactyl in confkit.
        '';
      }
    ];

    xdg.configFile."tridactyl/tridactylrc".text =
      readFile ../../misc/tridactylrc_bepo
      + optionalString (!isNull cfg.editor) "\nset editorcmd ${cfg.editor}";
  };
}
