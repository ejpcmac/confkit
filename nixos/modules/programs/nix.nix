####### Configuration for Nix ##################################################
##                                                                            ##
## * Enable store optimisation and sandboxing on non-Darwin hosts             ##
## * Keep derivations and build outputs (good for developers)                 ##
## * Use all the cores to build deviravions                                   ##
## * Automatically delete generations older than 30 days every day at 21:00   ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkDefault optionalString;
  inherit (pkgs) stdenv;

  cfg = config.confkit.programs.nix;
in

{
  options.confkit.programs.nix = {
    enable = mkEnableOption "the confkit configuration for Nix";
  };

  config = mkIf cfg.enable {
    nix = {
      # TODO: Enable on Darwin when it is available.
      useSandbox = mkDefault (! stdenv.isDarwin);
      buildCores = mkDefault 0;

      # TODO: Enable everywhere once there is no race conditions.
      extraOptions = mkDefault (''
        keep-derivations = true
        keep-outputs = true
      '' + optionalString (! stdenv.isDarwin) "auto-optimise-store = true");

      gc = let gc-common = {
        automatic = mkDefault true;
        options = mkDefault "--delete-older-than 30d";
      }; in
      if stdenv.isDarwin then gc-common // {
        interval = mkDefault { Hour = 21; Minute = 0; };
      } else gc-common // {
        dates = mkDefault "21:00";
      };
    };
  };
}
