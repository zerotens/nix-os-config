# modules/programs/browsers.nix
# ─────────────────────────────────────────────────────────────────────────────
# Firefox (libre) and Chromium (unfree Google Chrome or open Chromium).
# Both are configured to launch with the Wayland backend by default.
{ config, pkgs, lib, ... }:

{
  # ── Firefox ────────────────────────────────────────────────────────────────
  programs.firefox = {
    enable = true;

    # System-wide policies (applied to all users, cannot be overridden in-browser)
    policies = {
      DisableTelemetry             = true;
      DisableFirefoxStudies        = true;
      DisablePocket                = true;
      DisableFormHistory           = false;
      OfferToSaveLogins            = false;   # use a password manager instead
      EnableTrackingProtection     = {
        Value              = true;
        Locked             = false;
        Cryptomining       = true;
        Fingerprinting     = true;
      };
      # Force Wayland backend for hardware acceleration
      # (also set via env var in gnome.nix, belt-and-suspenders)
      Preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "media.hardware-video-decoding.force-enabled" = true;
      };
    };

    # Pre-install extensions for all users (policy-managed, cannot be removed)
    # Find IDs at: https://addons.mozilla.org  → extension page URL contains the ID
    # policies.ExtensionSettings = { ... };  # uncomment to pin extensions
  };

  # ── Chromium ───────────────────────────────────────────────────────────────
  # Use pkgs.chromium for the open-source build or pkgs.google-chrome (unfree).
  # Swap the package name below to switch.
  environment.systemPackages = with pkgs; [
    # Open-source Chromium (no Google account sync)
    (chromium.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"   # auto-select Wayland when available
        "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"  # VA-API HW decode
        "--use-gl=egl"
      ];
    })

    # Uncomment for Google Chrome (requires allowUnfree = true, set in common.nix)
    # (google-chrome.override {
    #   commandLineArgs = [
    #     "--ozone-platform-hint=auto"
    #     "--enable-features=VaapiVideoDecoder"
    #   ];
    # })
  ];

  # ── VA-API / hardware video decoding ──────────────────────────────────────
  # Needed for smooth 4K/HDR in both browsers.
  # The correct driver depends on your GPU — see hardware/<host>.nix.
  hardware.graphics.enable = true;
}
