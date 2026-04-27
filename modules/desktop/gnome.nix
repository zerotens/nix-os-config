# modules/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri scrollable-tiling Wayland compositor with greetd display manager.
{ unstable-pkgs, config, pkgs, lib, ... }:

{
  # ── Niri compositor ────────────────────────────────────────────────────────
  programs.niri.enable    = true;
  programs.xwayland.enable = true;

  # ── Display manager (greetd + tuigreet) ───────────────────────────────────
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
    };
  };

  # ── Wayland environment variables ──────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL  = "1";
    GDK_BACKEND     = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    EGL_PLATFORM    = "wayland";
  };

  environment.systemPackages = [
    # Fonts
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-color-emoji
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.fira-code
    unstable-pkgs.noctalia-shell
  ];

  _module.args.unstable-pkgs = import <nixos-unstable> {};

  # ── Flatpak ────────────────────────────────────────────────────────────────
  services.flatpak.enable = true;

  # ── XDG portals (screen sharing, file chooser) ────────────────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
