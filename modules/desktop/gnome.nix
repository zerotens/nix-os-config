# modules/desktop/gnome.nix
# ─────────────────────────────────────────────────────────────────────────────
# GNOME desktop environment running on Wayland (GDM display manager).
# XWayland is kept enabled for legacy X11 apps (e.g., older Steam titles).
{ config, pkgs, lib, ... }:

{
  # ── Display server & compositor ────────────────────────────────────────────
  services.xserver = {
    enable = true;

    # GNOME display manager (Wayland session is the default since GNOME 40)
    displayManager.gdm = {
      enable  = true;
      wayland = true;   # explicitly prefer Wayland sessions in GDM
    };

    desktopManager.gnome.enable = true;
  };

  # XWayland — runs X11 apps inside the Wayland compositor
  # Set to false only if you never need legacy X11 apps.
  programs.xwayland.enable = true;

  # ── Wayland environment variables ──────────────────────────────────────────
  # These propagate to all sessions so every toolkit uses Wayland natively.
  environment.sessionVariables = {
    # Hint Electron apps to use the Wayland backend
    NIXOS_OZONE_WL          = "1";
    # Force GTK apps to the Wayland backend
    GDK_BACKEND             = "wayland,x11";
    # Force Qt apps to the Wayland backend (fallback to xcb if needed)
    QT_QPA_PLATFORM         = "wayland;xcb";
    # SDL2 games / apps prefer Wayland
    SDL_VIDEODRIVER         = "wayland";
    # Clutter (GNOME internals) on Wayland
    CLUTTER_BACKEND         = "wayland";
    # Use the Wayland EGL platform for hardware rendering
    EGL_PLATFORM            = "wayland";
  };

  # ── GNOME extras ───────────────────────────────────────────────────────────
  # Exclude the bulky default GNOME applications you likely don't want.
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-tour
  ] ++ (with pkgs; [
    gnome-weather
    gnome-maps
    gnome-contacts
    gnome-music
    epiphany       # GNOME Web (we install Firefox/Chromium instead)
    totem          # GNOME Videos
    yelp           # help browser
  ]);

  environment.systemPackages = with pkgs; [
    # GNOME Shell extensions manager (GUI)
    gnome-tweaks
    gnome-extension-manager

    # Popular shell extensions
    gnomeExtensions.appindicator      # systray icons (needed by many apps)
    gnomeExtensions.dash-to-dock      # macOS-style dock
    gnomeExtensions.blur-my-shell     # frosted-glass blur effects
    gnomeExtensions.gsconnect         # KDE Connect integration

    # Theming
    adw-gtk3          # libadwaita GTK3 theme for visual consistency
    papirus-icon-theme

    # File manager extras
    nautilus-open-any-terminal

    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Enable the udev rules shipped with GNOME (needed by gnome-settings-daemon)
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # ── Flatpak (optional sandboxed app distribution) ──────────────────────────
  services.flatpak.enable = true;
  # After first boot run: flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  # ── Portals (screen sharing, file chooser over Wayland) ───────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
}
