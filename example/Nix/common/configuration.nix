################################################################################
##                                                                            ##
##                        Common system configuration                         ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  confkit = import ../../confkit;
in

{
  imports = with confkit.modules; [
    environment
    nix
    tmux
    utilities
    zsh
  ];

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  time.timeZone = "Europe/Paris";

  i18n = {
    consoleFont = "Lat2-Terminus16";

    # TODO: Set your keyboard layout and locale.
    consoleKeyMap = "fr-bepo";
    defaultLocale = "fr_FR.UTF-8";
  };

  sound = {
    # Enable ALSA sound.
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.u2f.enable = true;

  ############################################################################
  ##                              Environment                               ##
  ############################################################################

  # NOTE: This is not useful if you are using the ranger configuration.
  environment.variables = {
    # Only use /etc/ranger/rc.conf and ~/.config/ranger/rc.conf
    RANGER_LOAD_DEFAULT_RC = "FALSE";
  };

  ############################################################################
  ##                                 Fonts                                  ##
  ############################################################################

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      meslo-lg
      opensans-ttf
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = { enable = true; autohint = false; };
      includeUserConf = false;
      penultimate.enable = true;
      ultimate.enable = false;
      useEmbeddedBitmaps = true;
    };
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    gnome3.gnome-session
    maim
    mpc_cli
    nix-prefetch-github
    wakelan
    xorg.xev

    # GNOME extensions
    gnomeExtensions.topicons-plus
  ];

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    ssh.startAgent = true;

    # TODO: Remove this line if you are not typing on BÉPO.
    vim.useBepoKeybindings = true;
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    ntp.enable = true;
    pcscd.enable = true;

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

      # Use GNOME 3 as desktop manager.
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
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

  # NOTE: This is only useful if your are typing on bepo.
  environment.etc = {
    "ranger/rc.conf".source = confkit.file "ranger/bepo_rc.conf";
    "ranger/scope.sh".source = "${pkgs.ranger}/share/doc/ranger/config/scope.sh";
  };
}
