####### Configuration for the file systems #####################################
##                                                                            ##
## * Complete system file system layout for ZFS and btrfs                     ##
## * Possibility to mount / on tmpfs, including file systems for applications ##
##   that need some persistence                                               ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (pkgs.lib.confkit) defaultFsOptions;

  mkFs = pkgs.lib.confkit.mkFs config;
  cfg = config.confkit.features.fileSystems;
in

{
  options = {
    confkit.features.fileSystems = {
      enable = mkEnableOption "configuration for file systems";

      fs = mkOption {
        type = types.enum [ "zfs" "btrfs" ];
        example = "zfs";
        description = "The filesystem to use for the OS.";
      };

      rootOnTmpfs = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Wether to mount / on tmpfs.";
      };

      tmpOnTmpfs = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Wether to mount /tmp on tmpfs. This has no effect if
          confkit.features.fileSystem.rootOnTmpfs is set to true.
        '';
      };

      bootPartition = mkOption {
        type = types.str;
        default = "/dev/disk/by-label/boot";
        example = "/dev/sda1";
        description = "The boot partition.";
      };

      zfs.zpool = mkOption {
        type = types.str;
        default = config.networking.hostName;
        example = "rpool";
        description = "The system zpool name.";
      };

      btrfs.device = mkOption {
        type = types.str;
        example = "/dev/disk/by-label/NixOS";
        description = "The system btrfs device.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (mkIf cfg.rootOnTmpfs {
        assertion = config.confkit.info.machineId != null;
        message = "You must set config.confkit.info.machineId when mounting / on tmpfs.";
      })
    ];

    ########################################################################
    ##                            File systems                            ##
    ########################################################################

    fileSystems = {
      #################################
      ## Always present file systems ##
      #################################

      "/" = if cfg.rootOnTmpfs then {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [ "mode=755" ];
      } else (mkFs {
        volumePath = "/system/ROOT";
        neededForBoot = true;
        options = [ "defaults" ];
      });

      "/boot" = {
        device = cfg.bootPartition;
        options = defaultFsOptions;
      };

      "/nix" = mkFs {
        volumePath = "/local/nix";
        neededForBoot = true;
        options = [ "defaults" ];
      };

      "/root" = mkFs {
        volumePath = "/system/root";
        options = [ "noatime" "nodev" "nosuid" ];
      };

      # NOTE: We don’t mount /home here when using ZFS as it is /currently/
      # meant to be automatically mounted by the ZFS subsystem.
      "/home" = mkIf (cfg.fs == "btrfs") (mkFs {
        volumePath = "/user/home";
      });

      ######################################
      ## File systems for persistent root ##
      ######################################

      "/tmp" = mkIf (!cfg.rootOnTmpfs && !cfg.tmpOnTmpfs) (mkFs {
        volumePath = "/local/tmp";
        neededForBoot = true;
        options = [ "defaults" ];
      });

      "/var" = mkIf (!cfg.rootOnTmpfs) (mkFs {
        volumePath = "/system/var";
        neededForBoot = true;
      });

      "/var/cache" = mkIf (!cfg.rootOnTmpfs) (mkFs {
        volumePath = "/system/var/cache";
        neededForBoot = true;
        options = [ "nodev" "noexec" "nosuid" ];
      });

      "/var/db" = mkIf (!cfg.rootOnTmpfs) (mkFs {
        volumePath = "/system/var/db";
        neededForBoot = true;
        options = [ "nodev" "noexec" "nosuid" ];
      });

      "/var/lib" = mkIf (!cfg.rootOnTmpfs) (mkFs {
        volumePath = "/system/var/lib";
        neededForBoot = true;
        options = [ "nodev" "noexec" "nosuid" ];
      });

      "/var/log" = mkIf (!cfg.rootOnTmpfs) (mkFs {
        volumePath = "/system/var/log";
        neededForBoot = true;
        options = [ "nodev" "noexec" "nosuid" ];
      });

      "/var/spool" = mkIf (!cfg.rootOnTmpfs) (mkFs {
        volumePath = "/system/var/spool";
        neededForBoot = true;
        options = [ "nodev" "noexec" "nosuid" ];
      });

      "/var/tmp" = mkIf (!cfg.rootOnTmpfs) (mkFs {
        volumePath = "/local/var/tmp";
        neededForBoot = true;
        options = [ "nodev" "noexec" "nosuid" ];
      });

      #################################################
      ## Persistance file systems when / is on tmpfs ##
      #################################################

      "/persist/systemd" = mkFs {
        volumePath = "/system/data/systemd";
        neededForBoot = true;
      };

      "/persist/utmp" = mkFs {
        volumePath = "/system/data/utmp";
        options = [ "nodev" "noexec" "nosuid" ];
      };

      "/var/log/journal" = mkFs {
        volumePath = "/system/data/journal";
        options = [ "nodev" "noexec" "nosuid" ];
        neededForBoot = true;
      };
    };

    ########################################################################
    ##                            Persistence                             ##
    ########################################################################

    # As / is mounted on tmpfs, some links have to be created to the persistent
    # filesystems on each boot.

    environment.etc = mkIf cfg.rootOnTmpfs {
      # Provide custom rules to link utmp files to /persist.
      "tmpfiles.d/var.conf".source = lib.mkForce ../../res/tmpfiles-var.conf;
    };

    ########################################################################
    ##                            Boot process                            ##
    ########################################################################

    boot = mkIf cfg.rootOnTmpfs {
      # Pre-boot filesystem setup.
      initrd.postMountCommands = ''
        # Setup the link to the systemd data directory.
        echo "linking /var/lib/systemd to /persist/systemd..."
        mkdir -p /mnt-root/var/lib
        ln -s /persist/systemd /mnt-root/var/lib/systemd
      '';
    };

    ########################################################################
    ##                        Other configuration                         ##
    ########################################################################

    # Avoid sudo lectures after each reboot.
    security.sudo.extraConfig = mkIf cfg.rootOnTmpfs ''
      Defaults lecture = never
    '';
  };
}
