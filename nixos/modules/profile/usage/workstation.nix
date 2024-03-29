####### Configuration profile for workstations #################################
##                                                                            ##
## * Install the exfat kernel module                                          ##
## * Install ntfs3g                                                           ##
## * Enable PulseAudio and ALSA sound                                         ##
## * Use NetworkManager to manage network interfaces                          ##
## * Enable CUPS, pcscd and xserver                                           ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkIf;

  hostName = config.networking.hostName;
  layout = config.confkit.keyboard.layout;
  fs = config.confkit.features.fileSystems;

  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  config = mkIf (builtins.elem "workstation" config.confkit.profile.usage) {

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = mkIf fs.enable {
      "/config" = mkFs {
        volumePath = "/local/config";
        options = [ "noatime" "nodev" "nosuid" ];
      };

      "/persist/cups" = mkIf fs.rootOnTmpfs (mkFs {
        volumePath = "/system/data/cups";
      });

      "/persist/NetworkManager/connections" = mkIf fs.rootOnTmpfs (mkFs {
        volumePath = "/system/data/NetworkManager/connections";
      });

      "/var/lib/AccountsService" = mkIf fs.rootOnTmpfs (mkFs {
        volumePath = "/system/data/AccountsService";
      });

      "/var/lib/NetworkManager" = mkIf fs.rootOnTmpfs (mkFs {
        volumePath = "/system/data/NetworkManager/state";
      });
    };

    ########################################################################
    ##                            Persistence                             ##
    ########################################################################

    environment.etc = mkIf fs.rootOnTmpfs {
      # Link the NixOS configuration to the config repository.
      "nixos/flake.nix".source = "/config/Nix/${hostName}/flake.nix";
      "nixos/hardware-configuration.nix".source = "/config/Nix/${hostName}/hardware-configuration.nix";

      # Persisted non-static files in /etc
      "NetworkManager/system-connections".source = "/persist/NetworkManager/connections";
    };

    systemd.tmpfiles.rules = mkIf fs.rootOnTmpfs [
      "z /persist/cups 755 root root - -"
      "L+ /var/lib/cups - - - - /persist/cups"

      "z /persist/NetworkManager/connections 700 root root - -"
    ];

    ########################################################################
    ##                              Hardware                              ##
    ########################################################################

    hardware = {
      pulseaudio.enable = mkDefault true;
    };

    sound = {
      # Enable ALSA sound.
      enable = mkDefault true;
      mediaKeys.enable = mkDefault true;
    };

    ########################################################################
    ##                             Networking                             ##
    ########################################################################

    networking = {
      networkmanager.enable = mkDefault true;
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      pcscd.enable = mkDefault true;
      printing.enable = mkDefault true;
      udisks2.enable = mkDefault true;

      xserver = {
        enable = mkDefault true;

        # Configure the keyboard layout if it has been set in
        # confkit.keyboard.layout.
        layout = mkIf (layout == "bépo") "fr";
        xkbVariant = mkIf (layout == "bépo") "bepo_afnor";

        # Enable touchpad support with natural scrolling.
        libinput = {
          enable = mkDefault true;
          touchpad.naturalScrolling = mkDefault true;
        };
      };
    };

    ########################################################################
    ##                          System packages                           ##
    ########################################################################

    environment.systemPackages = with pkgs; [
      # Utilities
      ntfs3g
    ];
  };
}
