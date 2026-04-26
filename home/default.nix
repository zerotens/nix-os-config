# home/default.nix
# ─────────────────────────────────────────────────────────────────────────────
# Home Manager entry point for zerotens.
# Only sets the mandatory identity fields and imports all category modules.
# Actual package/program declarations live in the sub-modules below.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, inputs, ... }:

{
  # ── Identity (required by Home Manager) ───────────────────────────────────
  home.username      = "zerotens";
  home.homeDirectory = "/home/zerotens";

  # Must match system.stateVersion in common.nix — do NOT bump after install.
  home.stateVersion  = "25.11";

  # ── Sub-module imports ─────────────────────────────────────────────────────
  imports = [
    # User-installed applications (the main focus of this file)
    ./apps/communication.nix
    ./apps/media.nix
    ./apps/productivity.nix
    ./apps/development.nix
    ./apps/utilities.nix

    # Shell environment
    ./shell/zsh.nix
    ./shell/starship.nix
    ./shell/tools.nix

    # GNOME desktop tweaks and XDG directories
    ./desktop/gnome-settings.nix
    ./desktop/xdg.nix

    # User-level background services
    ./services/git.nix
    ./services/syncthing.nix
  ];

  # Let Home Manager manage its own config symlink (~/.config/home-manager)
  programs.home-manager.enable = true;
}
