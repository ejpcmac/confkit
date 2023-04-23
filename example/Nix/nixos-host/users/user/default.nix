################################################################################
##                                                                            ##
##                    User declaration for user@nixos-host                    ##
##                                                                            ##
################################################################################

{
  users.users.user = {
    isNormalUser = true;
    uid = 1000;
    description = "User";
    extraGroups = [ "wheel" "dialout" "wireshark" ];
    # Password: user
    # Use `mkpasswd -m SHA-512` to generate a new password hash.
    hashedPassword = "$6$U6PDUk3gTcaZHXey$mrJfd.oAt.lIMgrwJAmYWfIKKiTrOpFYx/4iIpMhQO/xSuLccWPnEPrR901VQUztvzZHgBg2RFoIkxUbt4x0X/";
  };

  home-manager.users.user = import ./home.nix;
}
