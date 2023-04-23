{ config, lib, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) enum listOf str;

  baseTypes = [ "physical" "virtual" "container" "laptop" ];
  additionalTypes = config.confkit.extensions.profile.additionalTypes;
  type = enum (baseTypes ++ additionalTypes);
in

{
  options.confkit.profile.type = mkOption {
    type = listOf type;
    default = [ ];
    example = [ "physical" "laptop" ];
    description = "The machine type.";
  };

  options.confkit.extensions.profile.additionalTypes = mkOption {
    type = listOf str;
    default = [ ];
    example = [ "mainframe" ];
    description = ''
      Additional machine to accept in confkit.

      This option can be used to extend confkit with you custom machine
    '';
  };

  imports = [
    ./physical.nix
    ./laptop.nix
  ];
}
