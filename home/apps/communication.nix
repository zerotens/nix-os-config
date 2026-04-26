# home/apps/communication.nix
# ─────────────────────────────────────────────────────────────────────────────
# Messaging, email, and video-call applications managed by Home Manager.
# All packages are installed into the user profile (~/.nix-profile/bin).
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # ── Instant messaging ──────────────────────────────────────────────────
    #discord           # voice + text + screen-share (unfree)
    #signal-desktop    # end-to-end encrypted messaging
    #telegram-desktop  # Telegram (MTProto encrypted)
    #element-desktop   # Matrix protocol client (open federated chat)

    # ── Email ─────────────────────────────────────────────────────────────
    #thunderbird       # full-featured email + calendar client

    # ── Voice chat ────────────────────────────────────────────────────────
    teamspeak6-client # TeamSpeak 6 voice communication client

    # ── Video conferencing ─────────────────────────────────────────────────
    #zoom-us           # Zoom (unfree)
    # teams-for-linux # uncomment for Microsoft Teams (community wrapper)
  ];

  # ── Thunderbird profile via Home Manager ───────────────────────────────────
  # Home Manager can manage a minimal Thunderbird profile so your default
  # settings survive rebuilds.  Accounts still need to be added manually or
  # via secrets management (e.g. agenix).
  programs.thunderbird = {
    enable   = true;
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "mail.spam.manualMark"              = true;
          "mailnews.default_sort_order"       = 2;   # newest first
          "mail.compose.default_to_html"      = false;
          "privacy.donottrackheader.enabled"  = true;
        };
      };
    };
  };
}
