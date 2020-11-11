####### Configuration for the bootloader #######################################
##                                                                            ##
## * Options to configure the bootloader depending on the platform and        ##
##   program                                                                  ##
## * 1-second default timeout, overrideable                                   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf mkDefault types;
  cfg = config.confkit.features.bootloader;
in

{
  options.confkit.features.bootloader = {
    enable = mkEnableOption "the boot configuration from confkit";

    platform = mkOption {
      type = types.enum [ "uefi" ];
      example = "uefi";
      description = "The firmware platform";
    };

    program = mkOption {
      type = types.enum [ "systemd-boot" ];
      example = "systemd-boot";
      description = "The bootloader program to use";
    };

    timeout = mkOption {
      type = types.ints.unsigned;
      default = 1;
      example = 5;
      description = "The bootloader timeout";
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = cfg.program == "systemd-boot";
      timeout = cfg.timeout;

      efi = mkIf (cfg.platform == "uefi") {
        canTouchEfiVariables = mkDefault true;
        efiSysMountPoint = mkDefault "/boot";
      };
    };
  };
}
