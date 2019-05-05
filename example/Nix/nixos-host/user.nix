################################################################################
##                                                                            ##
##                   Home configuration for user@nixos-host                   ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

{
  imports = [ ../common/home.nix ];

  home.packages = with pkgs; [
    # signal-desktop
  ];

  # Specific Git configuration
  programs.git = {
    extraConfig.credential.helper = "store";
  };
}
