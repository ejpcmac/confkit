{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
  baseTypes = [ "physical" "virtual" "container" "laptop" ];
  additionalTypes = config.confkit.extensions.profile.additionalTypes;
  type = types.enum (baseTypes ++ additionalTypes);
in

{
  options.confkit.profile.type = mkOption {
    type = types.listOf type;
    default = [];
    example = [ "physical" "laptop" ];
    description = "The machine type.";
  };

  options.confkit.extensions.profile.additionalTypes = mkOption {
    type = types.listOf types.str;
    default = [];
    example = [ "mainframe" ];
    description = ''
      Additional machine types to accept in confkit.

      This option can be used to extend confkit with you custom machine types.
    '';
  };

  imports = [
    ./physical.nix
    ./laptop.nix
  ];
}
