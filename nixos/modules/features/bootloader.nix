####### Configuration for the bootloader #######################################
##                                                                            ##
## * Options to configure the bootloader depending on the platform and        ##
##   program                                                                  ##
## * 1-second default timeout, overrideable                                   ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) enum ints str;
  cfg = config.confkit.features.bootloader;
in

{
  options.confkit.features.bootloader = {
    enable = mkEnableOption "the boot configuration from confkit";

    platform = mkOption {
      type = enum [ "bios" "uefi" ];
      example = "uefi";
      description = "The firmware platform";
    };

    program = mkOption {
      type = enum [ "grub" "systemd-boot" ];
      example = "systemd-boot";
      description = "The bootloader program to use";
    };

    device = mkOption {
      type = str;
      default = "";
      example = "/dev/sdb";
      description = "The device on which to write the MBR";
    };

    timeout = mkOption {
      type = ints.unsigned;
      default = 1;
      example = 5;
      description = "The bootloader timeout";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (mkIf (cfg.program == "grub") {
        assertion = cfg.device != "";
        message = ''
          You must set confkit.features.bootloader.device when using GRUB.
        '';
      })

      (mkIf (cfg.program == "systemd-boot") {
        assertion = cfg.platform == "uefi";
        message = ''
          systemd-boot only works on the UEFI platform.
            Please set confkit.features.bootloader.platform to "uefi".
        '';
      })
    ];

    boot.loader = {
      grub = mkIf (cfg.program == "grub") {
        enable = true;
        device = cfg.device;
        efiSupport = cfg.platform == "uefi";
      };

      systemd-boot.enable = cfg.program == "systemd-boot";
      efi.canTouchEfiVariables = cfg.platform == "uefi";
      timeout = cfg.timeout;
    };
  };
}
