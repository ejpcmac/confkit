####### General information about the machine ##################################
##                                                                            ##
## * Provide options to configure the machine name, ID and location           ##
## * Set networking.hostName to the machine name if specified                 ##
## * Set networking.hostId to the firt 8 characters of machineId if specified ##
## * Set /etc/machine-id to machineId if specified                            ##
##                                                                            ##
################################################################################

{ config, lib, ... }:

let
  inherit (lib) mkDefault mkIf mkOption;
  inherit (lib.types) nullOr str;
  cfg = config.confkit.info;
  machineId = cfg.machineId;
in

{
  options.confkit.info = {
    name = mkOption {
      type = nullOr str;
      default = null;
      example = "nixos";
      description = "The machine name";
    };

    machineId = mkOption {
      type = nullOr str;
      default = null;
      description = "The systemd machine ID";
    };

    location = mkOption {
      type = nullOr str;
      default = null;
      example = "kerguelen";
      description = "The machine location";
    };
  };

  config = {
    environment.etc = {
      "machine-id" = mkIf (machineId != null) { text = "${machineId}\n"; };
    };

    networking = {
      hostName = mkIf (cfg.name != null) (mkDefault cfg.name);
      hostId = mkIf (machineId != null) (mkDefault (builtins.substring 0 8 machineId));
    };
  };
}
