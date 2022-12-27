################################################################################
##                                                                            ##
##                    System configuration for nixos-host                     ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "22.11";  # Did you read the comment?

  imports = [
    # Import the confkit NixOS module to get ready-to-use configurations for
    # several tools.
    ../../confkit/nixos

    # Import the home-manager NixOS module to handle user configurations
    # declaratively.
    ../../home-manager/nixos

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Configuration for the users.
    ./users/root
    ./users/user
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    info = {
      name = "nixos-host";
      machineId = "c6dc57dbf4e9384215c6d0e6616d2ff2";
      location = "kerguelen";
    };

    profile = {
      type = [ "physical" "laptop" ];
      usage = [ "workstation" ];
    };

    features = {
      base.enable = true;
      fonts.enable = true;
      intel.enable = true;
      shell.enable = true;
      utilities.enable = true;
      zfs.enable = true;

      bootloader = {
        enable = true;
        platform = "uefi";
        program = "systemd-boot";
      };

      fileSystems = {
        enable = true;
        fs = "zfs";
        rootOnTmpfs = true;
      };
    };

    programs = {
      nix.enable = true;
      ranger.enable = true;
      tmux.enable = true;
      vim.enable = true;
      zsh.enable = true;
    };

    # If you are typing on a BÉPO keyboard, you might want to enable this
    # option. It will automatically enable BÉPO-optimised keybindings for
    # ranger, Tmux and Vim.
    # keyboard.layout = "bépo";
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  # TODO: Set your timezone, locale, console keymap and location.

  time.timeZone = "Indian/Kerguelen";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  location = {
    latitude = -49.35;
    longitude = 70.22;
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    avahi = { enable = true; nssmdns = true; };

    redshift = {
      enable = true;
      temperature = { day = 5500; night = 2800; };
      brightness = { day = "1.0"; night = "1.0"; };
    };

    xserver = {
      # TODO: Configure.
      # Configure the keyboard layout.
      layout = "fr";
      # xkbVariant = "bepo";

      # Use Plasma 5 as desktop manager.
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
    };
  };

  systemd.services = {
    # Disable ModemManager to avoid it messing with serial communications.
    modem-manager.enable = false;

    # Currently, we also need to disable this service to avoid ModemManager to
    # be respawn after rebooting.
    "dbus-org.freedesktop.ModemManager1".enable = false;
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    ssh.startAgent = true;
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    openssl
    pandoc
    redshift-plasma-applet
    wine

    # TeXLive can be useful for tools like Pandoc or Org.
    texlive.combined.scheme-full

    # Applications
    firefox
    gimp
    gwenview
    kate
    keepassx2
    konversation
    libreoffice
    mpv
    okular
    thunderbird
  ];
}
