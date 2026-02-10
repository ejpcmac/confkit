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
      description = "Whether to install a bunch of command-line utilities";
    };
  };

  config = mkIf cfg.enable {
    # programs = {
    #   trippy.enable = true;
    # };

    environment.systemPackages = with pkgs; [
      bat
      colordiff
      curl
      # dcfldd
      difftastic
      # dmidecode
      dnsutils
      dua
      emv
      fd
      ffmpeg
      file
      fzf
      git
      git-lfs
      gnupg
      htop
      iftop
      imagemagick
      # inetutils
      inxi
      jq
      killall
      # lshw
      lsof
      mkpasswd
      mosh
      neofetch
      nvd
      openssh
      p7zip
      # parted
      pciutils
      qpdf
      ripgrep
      rsync
      smartmontools
      sshfs
      testdisk
      # traceroute
      trash-cli
      tree
      unzip
      # usbutils
      vulnix
      watch
      wget
      xz
      zip
    ];
  };
}
