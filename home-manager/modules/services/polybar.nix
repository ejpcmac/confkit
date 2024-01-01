####### Configuration for Polybar ##############################################
##                                                                            ##
## * One bar for the main monitor                                             ##
## * Integration with bspwm                                                   ##
## * ALSA volume, backlight, temperature, memory, CPU, network interfaces     ##
##   and date                                                                 ##
##                                                                            ##
################################################################################

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.confkit.services.polybar;
in

{
  options.confkit.services.polybar = {
    enable = mkEnableOption "whether to enable the Polybar status bar";
  };

  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;

      script = mkDefault "polybar main &";

      config = {
        colors = {
          background = mkDefault "#dd222222";
          background-alt = mkDefault "#dd444444";
          foreground = mkDefault "#ffffff";
          foreground-alt = mkDefault "#555555";
          icon = mkDefault "#aaaaaa";
          primary = mkDefault "#ffb52a";
          secondary = mkDefault "#e60053";
          alert = mkDefault "#bd2c40";
        };

        settings = {
          screenchange-reload = mkDefault true;
        };

        "bar/main" = {
          fixed-center = mkDefault false;

          width = mkDefault "100%";
          height = mkDefault 36;

          padding-left = mkDefault 0;
          padding-right = mkDefault 2;
          module-margin-left = mkDefault 1;
          module-margin-right = mkDefault 2;

          background = mkDefault "\${colors.background}";
          foreground = mkDefault "\${colors.foreground}";

          line-size = mkDefault 3;
          line-color = mkDefault "#f00";

          font-0 = mkDefault "NotoSansM NF:size=10:weight=bold;0";

          modules-left = mkDefault "bspwm";
          modules-right = mkDefault "alsa backlight temperature memory cpufreq cpu battery wlan eth date";

          locale = mkDefault "fr_FR.UTF-8";

          tray-position = mkDefault "right";
          tray-padding = mkDefault 2;

          wm-restack = mkDefault "bspwm";

          cursor-click = mkDefault "pointer";
          cursor-scroll = mkDefault "ns-resize";
        };

        "module/bspwm" = {
          type = mkDefault "internal/bspwm";

          format = mkDefault "<label-state> <label-mode>";

          label-focused-background = mkDefault "\${colors.background-alt}";
          label-focused-underline = mkDefault "\${colors.primary}";
          label-focused-padding = mkDefault 2;

          label-occupied-padding = mkDefault 2;

          label-urgent-background = mkDefault "\${colors.alert}";
          label-urgent-padding = mkDefault 2;

          label-empty-foreground = mkDefault "\${colors.foreground-alt}";
          label-empty-padding = mkDefault 2;

          label-monocle = mkDefault "󰖯";
          label-floating = mkDefault "󰖲";
          label-pseudotiled = mkDefault "P";
          label-locked = mkDefault "󰌾";
          label-locked-foreground = mkDefault "#bd2c40";
          label-sticky = mkDefault "󰛽";
          label-sticky-foreground = mkDefault "#fba922";
          label-private = mkDefault "";
          label-private-foreground = mkDefault "#bd2c40";
        };

        "module/date" = {
          type = mkDefault "internal/date";

          format-prefix = mkDefault "󰃰 ";
          format-prefix-foreground = mkDefault "\${colors.icon}";
          format-underline = mkDefault "#0a6cf5";

          label = mkDefault "%date% %time%";
          date = mkDefault "%Y-%m-%d";
          time = mkDefault "%H:%M:%S";
        };

        "module/eth" = {
          type = mkDefault "internal/network";
          interval = mkDefault 3;

          format-connected-prefix = mkDefault "󰈀 ";
          format-connected-prefix-foreground = mkDefault "\${colors.icon}";
          format-connected-underline = mkDefault "#55aa55";

          label-connected = mkDefault "%local_ip% %netspeed:9%";

          format-disconnected = mkDefault "";
          # format-disconnected = mkDefault "<label-disconnected>";
          # format-disconnected-underline = mkDefault "\${self.format-connected-underline}";
          # label-disconnected = mkDefault "%ifname% disconnected";
          # label-disconnected-foreground = mkDefault "\${colors.foreground-alt}";
        };

        "module/wlan" = {
          type = mkDefault "internal/network";
          interval = mkDefault 3;

          format-connected = mkDefault "<ramp-signal> <label-connected>";
          format-connected-underline = mkDefault "#9f78e1";

          ramp-signal-0 = mkDefault "󰤯";
          ramp-signal-1 = mkDefault "󰤟";
          ramp-signal-2 = mkDefault "󰤢";
          ramp-signal-3 = mkDefault "󰤥";
          ramp-signal-4 = mkDefault "󰤨";
          ramp-signal-foreground = mkDefault "\${colors.icon}";

          label-connected = mkDefault "%essid% %netspeed:9%";
        };

        "module/battery" = {
          type = mkDefault "internal/battery";
          full-at = mkDefault 100;

          format-charging = mkDefault "<animation-charging> <label-charging>";
          format-charging-underline = mkDefault "#45dd00";

          animation-charging-0 = mkDefault "󰢜";
          animation-charging-1 = mkDefault "󰂆";
          animation-charging-2 = mkDefault "󰂇";
          animation-charging-3 = mkDefault "󰂈";
          animation-charging-4 = mkDefault "󰢝";
          animation-charging-5 = mkDefault "󰂉";
          animation-charging-6 = mkDefault "󰢞";
          animation-charging-7 = mkDefault "󰂊";
          animation-charging-8 = mkDefault "󰂋";
          animation-charging-9 = mkDefault "󰂅";
          animation-charging-foreground = mkDefault "\${colors.icon}";
          animation-charging-framerate = mkDefault 750;

          label-charging = mkDefault "%percentage%% %consumption%W";

          format-full-prefix = mkDefault "󰂄 ";
          format-full-prefix-foreground = mkDefault "\${colors.icon}";
          format-full-underline = mkDefault "#45dd00";

          format-discharging = mkDefault "<ramp-capacity> <label-discharging>";
          format-discharging-underline = mkDefault "#ffb52a";

          ramp-capacity-0 = mkDefault "󰁺";
          ramp-capacity-1 = mkDefault "󰁻";
          ramp-capacity-2 = mkDefault "󰁼";
          ramp-capacity-3 = mkDefault "󰁽";
          ramp-capacity-4 = mkDefault "󰁾";
          ramp-capacity-5 = mkDefault "󰁿";
          ramp-capacity-6 = mkDefault "󰂀";
          ramp-capacity-7 = mkDefault "󰂁";
          ramp-capacity-8 = mkDefault "󰂂";
          ramp-capacity-9 = mkDefault "󰁹";
          ramp-capacity-foreground = mkDefault "\${colors.icon}";

          label-discharging = mkDefault "%percentage%% %consumption%W";
        };

        "module/cpu" = {
          type = mkDefault "internal/cpu";
          interval = mkDefault 1;

          format-prefix = mkDefault "󰘚 ";
          format-prefix-foreground = mkDefault "\${colors.icon}";
          format-underline = mkDefault "#f90000";

          label = mkDefault "%percentage-sum:3%%";
        };

        "module/cpufreq" = {
          type = mkDefault "custom/script";
          interval = mkDefault 1;
          format-underline = mkDefault "#f90000";
          exec = mkDefault ("printf '%8s' \"$("
            + "${pkgs.linuxPackages.cpupower}/bin/cpupower frequency-info -fm"
            + "| ${pkgs.gnugrep}/bin/grep -oP '(?<=frequency: )([^ ]+ [^ ]+)'"
            + ")\"");
        };

        "module/memory" = {
          type = mkDefault "internal/memory";
          interval = mkDefault "2";

          format-prefix = mkDefault " ";
          format-prefix-foreground = mkDefault "\${colors.icon}";
          format-underline = mkDefault "#4bffdc";

          label = mkDefault "%mb_used%";
        };

        "module/temperature" = {
          type = mkDefault "internal/temperature";

          thermal-zone = mkDefault 0;

          warn-temperature = mkDefault 60;

          format-underline = mkDefault "#f50a4d";
          format-warn-underline = mkDefault "\${self.format-underline}";

          label-warn-foreground = mkDefault "\${colors.secondary}";
        };

        "module/backlight" = {
          type = mkDefault "internal/backlight";
          card = mkDefault "intel_backlight";

          format-prefix = "󰖨 ";
          format-prefix-foreground = "\${colors.icon}";

          label = mkDefault "%percentage%%";
        };

        "module/alsa" = {
          type = mkDefault "internal/alsa";

          # master-mixer = mkDefault "PCM";
          master-soundcard = mkDefault "hw:0";

          mapped = mkDefault true;
          interval = mkDefault 5;

          format-volume = mkDefault "<label-volume> <bar-volume>";
          format-volume-prefix = "󰕾 ";
          format-volume-prefix-foreground = mkDefault "\${colors.icon}";

          label-volume = mkDefault "%percentage%%";

          bar-volume-width = mkDefault 10;
          bar-volume-foreground-0 = mkDefault "#55aa55";
          bar-volume-foreground-1 = mkDefault "#55aa55";
          bar-volume-foreground-2 = mkDefault "#55aa55";
          bar-volume-foreground-3 = mkDefault "#55aa55";
          bar-volume-foreground-4 = mkDefault "#55aa55";
          bar-volume-foreground-5 = mkDefault "#f5a70a";
          bar-volume-foreground-6 = mkDefault "#ff5555";
          bar-volume-gradient = mkDefault false;
          bar-volume-indicator = mkDefault "|";
          bar-volume-indicator-font = mkDefault 2;
          bar-volume-fill = mkDefault "─";
          bar-volume-fill-font = mkDefault 2;
          bar-volume-empty = mkDefault "─";
          bar-volume-empty-font = mkDefault 2;
          bar-volume-empty-foreground = mkDefault "\${colors.foreground-alt}";

          format-muted-prefix = mkDefault "󰖁 ";
          format-muted-foreground = mkDefault "\${colors.foreground-alt}";

          label-muted = mkDefault "sound muted";
        };
      };
    };
  };
}
