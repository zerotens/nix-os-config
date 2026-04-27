# modules/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri scrollable-tiling Wayland compositor with greetd display manager.
{ config, pkgs, lib, ... }:

{
  # ── Niri compositor ────────────────────────────────────────────────────────
  programs.niri.enable    = true;
  programs.xwayland.enable = true;

  programs.noctalia-shell = {
    enable  = true;
    package = pkgs.unstable.noctalia-shell;
  };

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

  environment.systemPackages = with pkgs; [
    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # ── Flatpak ────────────────────────────────────────────────────────────────
  services.flatpak.enable = true;

  # ── XDG portals (screen sharing, file chooser) ────────────────────────────
  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
