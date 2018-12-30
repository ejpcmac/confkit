##
## nixos-host users
##

{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      hashedPassword = "foo";
    };

    users.user = {
      isNormalUser = true;
      uid = 1000;
      description = "User";
      extraGroups = [ "wheel" "dialout" "wireshark" ];
      hashedPassword = "bar";
    };
  };
}
