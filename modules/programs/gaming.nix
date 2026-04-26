# modules/programs/gaming.nix
# ─────────────────────────────────────────────────────────────────────────────
# Steam with Wayland support, Proton/Wine compatibility, and GameMode.
{ config, pkgs, lib, ... }:

{
  # ── Steam ──────────────────────────────────────────────────────────────────
  programs.steam = {
    enable = true;

    # Open firewall ports for Steam Remote Play and In-Home Streaming
    remotePlay.openFirewall    = true;
    dedicatedServer.openFirewall = false; # flip to true if you host servers

    # Extra packages available inside the Steam runtime (32-bit compat layer)
    extraCompatPackages = with pkgs; [
      proton-ge-bin   # community GE-Proton build (better game compat than stock)
    ];

    # Packages injected into the Steam launch environment
    extraPackages = with pkgs; [
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
    ];
  };

  # ── Wayland / Gamescope ────────────────────────────────────────────────────
  # Gamescope is a Wayland compositor for games — gives you VRR, HDR, FSR upscaling.
  programs.gamescope = {
    enable     = true;
    capSysNice = true;  # allows gamescope to raise process priority
  };

  # ── GameMode ───────────────────────────────────────────────────────────────
  # Temporarily boosts CPU governor, scheduler, and GPU clocks while a game runs.
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice        = 10;
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device              = 0;
        amd_performance_level   = "high";  # safe to leave; no-op on non-AMD GPUs
      };
    };
  };

  # ── Proton / Wine dependencies ─────────────────────────────────────────────
  # 32-bit userland is required for most Windows games via Proton.
  hardware.graphics.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    # Launchers & helpers
    lutris          # multi-platform game manager (GOG, Epic, etc.)
    heroic          # Epic / GOG / Amazon launcher built on Electron + Wayland
    bottles         # Wine environment manager

    # In-game overlay (FPS, frametime, temps)
    mangohud

    # Utilities
    winetricks
    protontricks    # apply Winetricks verbs to Proton prefixes
    gamemode        # CLI client (gamemoderun <game>)

    # Controller support
    antimicrox       # map gamepad buttons to keyboard/mouse
  ];

  # ── udev rules for controllers ────────────────────────────────────────────
  # PlayStation, Xbox, and generic gamepad support without needing root.
  services.udev.packages = [
    pkgs.steam
    pkgs.game-devices-udev-rules
  ];

  # ── Optional: Sunshine game streaming server ──────────────────────────────
  # services.sunshine = {
  #   enable       = true;
  #   autoStart    = true;
  #   capSysAdmin  = true;  # required for virtual display / capture
  #   openFirewall = true;
  # };
}
