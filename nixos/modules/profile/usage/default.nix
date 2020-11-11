{ config, lib, pkgs, ...}:

let
  inherit (lib) mkOption types;
  usages = [ "server" "workstation" ];
  additionalUsages = config.confkit.extensions.profile.additionalUsages;
  usage = types.enum (usages ++ additionalUsages);
in

{
  options.confkit.profile.usage = mkOption {
    type = types.listOf usage;
    default = [];
    example = [ "workstation" ];
    description = "The machine usage.";
  };

  options.confkit.extensions.profile.additionalUsages = mkOption {
    type = types.listOf types.str;
    default = [];
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
