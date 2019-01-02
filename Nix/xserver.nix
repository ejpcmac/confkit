####### X configuration ########################################################
##                                                                            ##
## * Use GNOME 3                                                              ##
## * Enable natural scrolling                                                 ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  services.xserver = {
    enable = true;

    # Enable touchpad support with natural scrolling.
    libinput = {
      enable = mkDefault true;
      naturalScrolling = mkDefault true;
    };

    # Use GNOME 3 as desktop manager.
    displayManager.gdm.enable = mkDefault true;
    desktopManager.gnome3.enable = mkDefault true;
  };
}
