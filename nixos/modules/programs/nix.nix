####### Configuration for Nix ##################################################
##                                                                            ##
## * Enable store optimisation and sandboxing on non-Darwin hosts             ##
## * Keep derivations and build outputs (good for developers)                 ##
## * Use all the cores to build deviravions                                   ##
## * Automatically delete generations older than 30 days every day at 21:00   ##
## * Optionally enable `nh` for both system operations and garbage collection ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf mkOption;
  inherit (lib.types) bool;
  inherit (pkgs) stdenv;

  cfg = config.confkit.programs.nix;
in

{
  options.confkit.programs.nix = {
    enable = mkEnableOption "the confkit configuration for Nix";

    nh.enable = mkOption {
      type = bool;
      default = false;
      example = true;
      description = ''
        Whether to enable nh.

        If nh is enabled, the system flake is automatically selected and
        `nh clean all` is used for garbage collection instead of
        `nix-collect-garbage`.
      '';
    };
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        cores = mkDefault 0;
        # TODO: Enable on Darwin when it is available.
        sandbox = mkDefault (! stdenv.isDarwin);

        # TODO: Enable everywhere once there is no race conditions.
        auto-optimise-store = mkDefault (! stdenv.isDarwin);
        keep-derivations = mkDefault true;
        keep-outputs = mkDefault true;
      };

      # Garbage-collect at the end of each month.
      #
      # NOTE: On Darwin, this is actually on the beginning of each month since I
      # don’t know how to set the last day of the month with launchd intervals.
      gc = mkIf (!cfg.nh.enable) (
        let
          gc-common = {
            automatic = mkDefault true;
            options = mkDefault "--delete-older-than 30d";
          };
        in
        if stdenv.isDarwin then gc-common // {
          interval = mkDefault { Day = 1; Hour = 0; Minute = 0; };
        } else gc-common // {
          dates = mkDefault "*-*~01 21:00";
        }
      );
    };

    programs.nh = mkIf cfg.nh.enable {
      enable = true;
      flake = mkDefault "/config/Nix/${config.networking.hostName}";

      # Garbage-collect at the end of each month.
      clean = {
        enable = mkDefault true;
        dates = mkDefault "*-*~01 21:00";
        extraArgs = mkDefault "--nogcroots --keep-since 1M";
      };
    };
  };
}
