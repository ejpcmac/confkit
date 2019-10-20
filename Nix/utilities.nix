####### Utilities ##############################################################
##                                                                            ##
## * Install a list of command-line utilities                                 ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    colordiff
    curl
    dcfldd
    dnsutils
    emv
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
