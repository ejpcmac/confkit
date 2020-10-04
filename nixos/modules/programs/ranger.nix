####### Configuration for ranger ###############################################
##                                                                            ##
## * Disable mouse support (TODO: Option)                                     ##
## * Hide only dotfiles                                                       ##
## * Enable VCS support                                                       ##
## * Make cd completion fuzzy                                                 ##
## * Define C-R to reload the configuration                                   ##
## * Use $ to tag instead of "                                                ##
## * Add kt and kd to create files and directories                            ##
## * Add bindings starting with D to trash using trash-cli                    ##
## * Add bindings starting with f to archive / compress files                 ##
## * Add handy binding starting with \ to mount / unmount                     ##
## * Remove Midnight Commander bindings                                       ##
## * Optionally use keybindings optimised for BÉPO keyboards                  ##
##                                                                            ##
## For an exhaustive list of options, please see `../ranger/[bepo_]rc.conf`   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.confkit.programs.ranger;
in

{
  options.confkit.programs.ranger = {
    enable = mkEnableOption "the confkit configuration for ranger";

    bepo = mkOption {
      type = types.bool;
      default = config.confkit.keyboard.layout == "bépo";
      example = true;
      description = "Use keybindings optimised for BÉPO keyboards.";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.ranger ];

      etc = {
        "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
        "ranger/rc.conf".source = if cfg.bepo
                                  then ../../../ranger/bepo_rc.conf
                                  else ../../../ranger/rc.conf;
      };

      # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
      variables.RANGER_LOAD_DEFAULT_RC = "FALSE";
    };
  };
}
