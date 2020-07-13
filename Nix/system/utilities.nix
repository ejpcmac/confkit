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
    ranger
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
    # TODO: Uncomment once python-ZODB is not broken anymore on NixOS 20.03.
    # vulnix
    watch
    wget
    xz
    zip
  ];
}
