# home/desktop/gnome-settings.nix
# ─────────────────────────────────────────────────────────────────────────────
# User-level GNOME configuration via dconf.
# Run `dconf watch /` while changing a setting in GNOME to find the key path.
# ─────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  dconf.settings = {
    # ── Appearance ─────────────────────────────────────────────────────────
    "org/gnome/desktop/interface" = {
      color-scheme         = "prefer-dark";
      gtk-theme            = "adw-gtk3-dark";
      icon-theme           = "Papirus-Dark";
      cursor-theme         = "Adwaita";
      clock-show-weekday   = true;
      clock-show-seconds   = false;
      font-name            = "Noto Sans 11";
      document-font-name   = "Noto Sans 11";
      monospace-font-name  = "JetBrainsMono Nerd Font 11";
      font-antialiasing    = "rgba";
      font-hinting         = "slight";
      show-battery-percentage = true;
      text-scaling-factor  = 1.0;
    };

    # ── Window manager ─────────────────────────────────────────────────────
    "org/gnome/desktop/wm/preferences" = {
      button-layout    = "appmenu:minimize,maximize,close";
      focus-mode       = "click";
      num-workspaces   = 4;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces       = false;
      workspaces-only-on-primary = true;
      # Enable fractional scaling (useful for HiDPI)
      experimental-features    = [ "scale-monitor-framebuffer" ];
    };

    # ── Shell extensions ───────────────────────────────────────────────────
    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "gsconnect@andyholmes.github.io"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "chromium-browser.desktop"
        "alacritty.desktop"
        "code.desktop"
        "steam.desktop"
      ];
    };

    # ── Dash-to-Dock settings ──────────────────────────────────────────────
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position          = "BOTTOM";
      dock-fixed             = true;
      extend-height          = false;
      autohide               = true;
      intellihide            = true;
      dash-max-icon-size     = 48;
      show-trash             = false;
      show-mounts            = false;
      background-opacity     = 0.8;
    };

    # ── Blur-my-shell settings ─────────────────────────────────────────────
    "org/gnome/shell/extensions/blur-my-shell" = {
      sigma  = 30;
      brightness = 0.6;
    };

    # ── Touchpad ──────────────────────────────────────────────────────────
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll             = true;
      tap-to-click               = true;
      two-finger-scrolling-enabled = true;
      disable-while-typing       = true;
      speed                      = 0.2;
    };

    # ── Power ─────────────────────────────────────────────────────────────
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout  = 1800;   # 30 min on AC
      sleep-inactive-ac-type     = "nothing";
      sleep-inactive-battery-timeout = 600; # 10 min on battery
      sleep-inactive-battery-type    = "suspend";
      power-button-action        = "suspend";
    };

    # ── Keyboard shortcuts ─────────────────────────────────────────────────
    "org/gnome/settings-daemon/plugins/media-keys" = {
      # Custom keybindings list
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name    = "Terminal";
      command = "alacritty";
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name    = "Files";
      command = "nautilus";
      binding = "<Super>e";
    };

    # ── Privacy ───────────────────────────────────────────────────────────
    "org/gnome/desktop/privacy" = {
      report-technical-problems = false;
      send-software-usage-stats = false;
      remove-old-trash-files    = true;
      remove-old-temp-files     = true;
      old-files-age             = 30;
    };

    # ── Night Light ───────────────────────────────────────────────────────
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled     = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 20.0;   # 20:00
      night-light-schedule-to   = 7.0;    # 07:00
      night-light-temperature   = 4000;   # Kelvin (3000 = warm amber, 6500 = daylight)
    };

    # ── Screenshots ───────────────────────────────────────────────────────
    "org/gnome/gnome-screenshot" = {
      auto-save-directory = "file:///home/nixuser/Pictures/Screenshots";
    };
  };
}
