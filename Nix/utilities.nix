####### Utilities ##############################################################
##                                                                            ##
## * Install a list of command-line utilities                                 ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    curl
    dcfldd
    dnsutils
    emv
    git
    git-lfs
    gnupg
    htop
    iftop
    imagemagick
    killall
    lshw
    lsof
    mkpasswd
    mosh
    openssh
    p7zip
    pciutils
    ranger
    rsync
    screenfetch
    smartmontools
    sshfs
    testdisk
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
}
