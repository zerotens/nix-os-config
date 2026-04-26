# home/services/syncthing.nix
# ─────────────────────────────────────────────────────────────────────────────
# Syncthing: continuous peer-to-peer file synchronisation.
# Runs as a user-level systemd service (no root required).
#
# After first deploy, open http://localhost:8384 to add devices and folders.
# ─────────────────────────────────────────────────────────────────────────────
{ config, ... }:

{
  services.syncthing = {
    enable = false;

    # ── Web GUI ─────────────────────────────────────────────────────────────
    # Bind to localhost only (reverse-proxy or SSH tunnel for remote access).
    # Override per-host if you need LAN access.
    tray.enable = false;   # set to true to show a systray icon (requires tray support)
  };

  # ── Firewall note ──────────────────────────────────────────────────────────
  # Syncthing uses TCP/UDP 22000 for sync and UDP 21027 for discovery.
  # Open them in hosts/<hostname>/configuration.nix if needed:
  #
  #   networking.firewall.allowedTCPPorts = [ 22000 ];
  #   networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
