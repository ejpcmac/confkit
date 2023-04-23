{ config, lib, ... }:

let
  inherit (lib) mkOption;
  inherit (lib.types) enum listOf str;

  usages = [ "server" "workstation" ];
  additionalUsages = config.confkit.extensions.profile.additionalUsages;
  usage = enum (usages ++ additionalUsages);
in

{
  options.confkit.profile.usage = mkOption {
    type = listOf usage;
    default = [ ];
    example = [ "workstation" ];
    description = "The machine usage.";
  };

  options.confkit.extensions.profile.additionalUsages = mkOption {
    type = listOf str;
    default = [ ];
    example = [ "home" ];
    description = ''
      Additional usages to accept in confkit.

      This option can be used to extend confkit with you custom usages.
    '';
  };

  imports = [
    ./server.nix
    ./workstation.nix
  ];
}
