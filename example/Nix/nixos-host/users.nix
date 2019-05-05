################################################################################
##                                                                            ##
##                              nixos-host users                              ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      # Use `mkpasswd -m SHA-512` to generate a new password hash.
      # Password: root
      hashedPassword = "$6$10ANBznle.bUMU$ex8BpjzUzYQKiOX5cYVT0v4NoPujGza0oPQEqZv.WQguj9p8MAOfiXiFkBkiY1Wt9ePe3fA4J3jw4KjG.pwDH1";
    };

    users.user = {
      isNormalUser = true;
      uid = 1000;
      description = "User";
      extraGroups = [ "wheel" "dialout" "wireshark" ];
      # Password: user
      hashedPassword = "$6$U6PDUk3gTcaZHXey$mrJfd.oAt.lIMgrwJAmYWfIKKiTrOpFYx/4iIpMhQO/xSuLccWPnEPrR901VQUztvzZHgBg2RFoIkxUbt4x0X/";
    };
  };
}
