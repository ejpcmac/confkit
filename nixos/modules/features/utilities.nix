####### Utilities ##############################################################
##                                                                            ##
## * Install a list of command-line utilities                                 ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.confkit.features.utilities;
in

{
  options.confkit.features.utilities = {
    enable = mkEnableOption {
      description = "Wether to install a bunch of command-line utilities";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bat
      colordiff
      curl
      dcfldd
      dnsutils
      emv
      ffmpeg
      file
      git
      git-lfs
      gnupg
      htop
      iftop
      imagemagick
      inxi
      jq
      killall
      lshw
      lsof
      mkpasswd
      mosh
      openssh
      p7zip
      parted
      pciutils
      qpdf
      rsync
      screenfetch
      smartmontools
      sshfs
      telnet
      testdisk
      traceroute
      trash-cli
      tree
      unzip
      usbutils
      vulnix
      watch
      wget
      xz
      zip
    ];
  };
}
