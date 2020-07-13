################################################################################
##                                                                            ##
##                    System configuration for nixos-host                     ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  confkit = import ../../confkit;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";  # Did you read the comment?

  imports = with confkit.modules.system; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Configuration for the users.
    ./users

    # confkit modules
    environment
    nix
    tmux
    utilities
    vim
    zsh
  ];

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
      meslo-lg
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

    # TODO: Remove this line if you are not typing on BÉPO.
    tmux.useBepoKeybindings = true;
    vim.useBepoKeybindings = true;
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
      xkbVariant = "bepo";

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

  ############################################################################
  ##                          Custom configuration                          ##
  ############################################################################

  environment = {
    etc = {
      # TODO: Uncomment one of the following lines.
      # "ranger/rc.conf".source = confkit.file "ranger/rc.conf";
      # "ranger/rc.conf".source = confkit.file "ranger/bepo_rc.conf";
      "ranger/rc.conf".source = confkit.file "ranger/bepo_rc.conf";
      "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
    };

    # NOTE: This is not useful if you are using the default ranger configuration.
    variables = {
      # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
      RANGER_LOAD_DEFAULT_RC = "FALSE";
    };
  };
}
