################################################################################
##                                                                            ##
##                    System configuration for nixos-host                     ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";  # Did you read the comment?

  imports = with confkit.modules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    # Configuration shared between hosts
    ../common/configuration.nix
  ];

  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot = {

    loader = {
      # TODO: Uncomment this line if you are using a legacy BIOS system.
      # grub.device = "/dev/sda";

      # TODO: Uncomment this block if you are using an EFI system.
      # # Use the systemd-boot EFI boot loader.
      # systemd-boot.enable = true;
      # efi.canTouchEfiVariables = true;
      # efi.efiSysMountPoint = "/boot";

      timeout = 1;
    };

    cleanTmpDir = true;
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  networking = {
    hostName = "nixos-host";
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Applications
    firefox
    keepassx2
  ];

  # Uninstall unneeded gnome applications.
  environment.gnome3.excludePackages = with pkgs.gnome3; [
    evolution
  ];
}
