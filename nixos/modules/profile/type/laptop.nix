####### Configuration profile for laptops ######################################
##                                                                            ##
## * Enable TLP                                                               ##
## * Install brightnessctl and cpupower                                       ##
## * Install the udev rules for brightnessctl                                 ##
## * Make cpupower usable by non-root users                                   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (builtins.elem "laptop" config.confkit.profile.type) {

    ########################################################################
    ##                              Security                              ##
    ########################################################################

    security = {
      sudo.extraRules = lib.modules.mkAfter [
        {
          users = [ "ALL" ];
          commands = [
            {
              command = "${pkgs.linuxPackages.cpupower}/bin/cpupower";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      tlp.enable = lib.mkDefault true;
      udev.packages = [ pkgs.brightnessctl ];
    };

    ########################################################################
    ##                          System packages                           ##
    ########################################################################

    environment.systemPackages = with pkgs; [
      # Utilities
      brightnessctl
      linuxPackages.cpupower
    ];
  };
}
