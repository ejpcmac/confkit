let
  inherit (builtins) elem;
  defaultFsOptions = [ "noatime" "nodev" "noexec" "nosuid" ];
in

{
  ## Generates a ZFS or btrfs file system mount.
  mkFs = config:
    { volumePath
    , options ? defaultFsOptions
    , neededForBoot ? false
    }:

    let
      cfg = config.confkit.features.fileSystems;
    in

    if (cfg.fs == "zfs") then {
      device = "${cfg.zfs.zpool}${volumePath}";
      fsType = "zfs";
      inherit options neededForBoot;
    } else if (cfg.fs == "btrfs") then {
      device = cfg.btrfs.device;
      fsType = "btrfs";
      options = [ "subvol=${volumePath}" "compress=zstd" ] ++ options;
      inherit neededForBoot;
    } else { };

  ## Default file system options.
  inherit defaultFsOptions;
}
