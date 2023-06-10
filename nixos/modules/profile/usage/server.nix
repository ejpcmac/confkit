####### Configuration profile for servers ######################################
##                                                                            ##
## * Enable OpenSSH with password authentication disabled                     ##
## * Enable mosh                                                              ##
## * Install lzop and mbuffer (to make them available for a remote syncoid)   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkIf;
  fs = config.confkit.features.fileSystems;
  zfs = config.confkit.features.zfs;
  mkFs = pkgs.lib.confkit.mkFs config;
in

{
  config = mkIf (builtins.elem "server" config.confkit.profile.usage) {

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = mkIf (fs.enable && fs.rootOnTmpfs) {
      "/persist/ssh" = mkFs { volumePath = "/system/data/ssh"; };
    };

    ########################################################################
    ##                              Services                              ##
    ########################################################################

    services = {
      openssh = {
        enable = mkDefault true;
        hostKeys = mkIf fs.rootOnTmpfs (mkDefault [
          { path = "/persist/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
          { path = "/persist/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
        ]);
      } // (if lib.trivial.release == "22.11" then {
        passwordAuthentication = mkDefault false;
      } else {
        settings = {
          PasswordAuthentication = mkDefault false;
        };
      });
    };

    ########################################################################
    ##                               Programs                             ##
    ########################################################################

    programs = {
      mosh.enable = mkDefault true;
    };

    ########################################################################
    ##                          System packages                           ##
    ########################################################################

    environment.systemPackages = with pkgs; mkIf zfs.enable [
      # Syncoid expect these tools to be in PATH for remote accesses.
      lzop
      mbuffer
    ];
  };
}
