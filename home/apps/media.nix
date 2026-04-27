# home/apps/media.nix
# ─────────────────────────────────────────────────────────────────────────────
# Media playback, streaming, and audio production tools.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # ── Video ─────────────────────────────────────────────────────────────
    celluloid         # GTK front-end for mpv — GNOME-native look
    vlc               # universal video/audio player
    makemkv           # Blu-ray / DVD ripping and MKV conversion (unfree)

    # ── Music / audio ─────────────────────────────────────────────────────
    spotify           # streaming (unfree; uses Electron + Wayland via OZONE_WL)
    strawberry        # local music player with scrobbling support
    playerctl         # MPRIS media-key control from CLI / scripts

    # ── Image viewing ─────────────────────────────────────────────────────
    loupe             # GNOME's modern image viewer (libadwaita)
    # gthumb          # heavier alternative with editing tools

    # ── Screen recording / casting ─────────────────────────────────────────
    obs-studio        # recording + streaming (Wayland PipeWire capture works natively)
    kooha             # simple GNOME screen recorder (PipeWire / Wayland)

    # ── Podcast / RSS ─────────────────────────────────────────────────────
    gnome-podcasts    # GNOME Podcasts (libadwaita)
  ];

  # ── mpv (Home Manager module — writes ~/.config/mpv/mpv.conf) ─────────────
  programs.mpv = {
    enable = true;
    config = {
      # Use VA-API hardware decoding (works with AMD, Intel, and NVIDIA NVDEC)
      hwdec          = "auto-safe";
      vo             = "gpu-next";       # modern Vulkan/OpenGL renderer
      gpu-api        = "vulkan";
      scale          = "ewa_lanczos";    # high-quality upscaling
      dscale         = "mitchell";
      video-sync     = "display-resample";
      interpolation  = true;
      tscale         = "oversample";
      sub-auto       = "fuzzy";          # load subtitles automatically
      sub-font-size  = 44;
      volume         = 80;
      save-position-on-quit = true;
    };
    bindings = {
      "l"  = "seek  5";
      "h"  = "seek -5";
      "j"  = "seek -60";
      "k"  = "seek  60";
      "J"  = "cycle sub";
      "a"  = "cycle audio";
    };
  };
}
