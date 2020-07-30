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
  system.stateVersion = "20.03";  # Did you read the comment?

  imports = [
    # Import the confkit NixOS module to get ready-to-use configurations for
    # several tools.
    ../../confkit/nixos

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Configuration for the users.
    ./users
  ];

  ############################################################################
  ##                                confkit                                 ##
  ############################################################################

  confkit = {
    nix.enable = true;
    ranger.enable = true;
    shell.enable = true;
    tmux.enable = true;
    utilities.enable = true;
    vim.enable = true;
    zsh.enable = true;

    # If you are typing on a BÉPO keyboard, you might want to enable this
    # option. It will automatically enable BÉPO-optimised keybindings for
    # ranger, Tmux and Vim.
    # keyboard.bepo = true;
  };

  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot = {
    loader = {
      # TODO: Uncomment this line if you are using a legacy BIOS system.
      # grub.device = "/dev/sda";

      # TODO: Uncomment this block if you are using an EFI system.
      # # Use the systemd-boot EFI boot loader.
      # systemd-boot.enable = true;
      # efi.canTouchEfiVariables = true;
      # efi.efiSysMountPoint = "/boot";

      timeout = 1;
    };

    cleanTmpDir = true;
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  ############################################################################
  ##                                Hardware                                ##
  ############################################################################

  hardware = {
    brightnessctl.enable = true;
    cpu.intel.updateMicrocode = true;
    pulseaudio.enable = true;
    u2f.enable = true;
  };

  sound = {
    # Enable ALSA sound.
    enable = true;
    mediaKeys.enable = true;
  };

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  # TODO: Set your timezone, locale, location and console keymap.

  time.timeZone = "Indian/Kerguelen";
  i18n.defaultLocale = "fr_FR.UTF-8";

  location = {
    latitude = -49.35;
    longitude = 70.22;
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  networking = {
    hostName = "nixos-host";
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    ntfs3g
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

  ############################################################################
  ##                                 Fonts                                  ##
  ############################################################################

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      carlito # Compatible with Calibri.
      fira-code
      inconsolata
      lato
      opensans-ttf
      symbola
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = { enable = true; autohint = false; };
      includeUserConf = false;
      penultimate.enable = true;
      useEmbeddedBitmaps = true;
    };
  };

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    ssh.startAgent = true;
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    ntp.enable = true;
    pcscd.enable = true;
    printing.enable = true;
    tlp.enable = true;

    avahi = { enable = true; nssmdns = true; };
    smartd = { enable = true; notifications.x11.enable = true; };

    redshift = {
      enable = true;
      temperature = { day = 5500; night = 2800; };
      brightness = { day = "1.0"; night = "1.0"; };
    };

    xserver = {
      enable = true;

      # TODO: Configure.
      # Configure the keyboard layout.
      layout = "fr";
      # xkbVariant = "bepo";

      # Enable touchpad support with natural scrolling.
      libinput = {
        enable = true;
        naturalScrolling = true;
      };

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
}
