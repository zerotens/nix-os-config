# modules/home-manager.nix
# ─────────────────────────────────────────────────────────────────────────────
# Home Manager as a NixOS module.
#
# This single file is the ONLY place that imports home-manager and binds it to
# the nixuser account.  All per-category user config lives under home/ and is
# imported from here — nothing HM-related is scattered in flake.nix or host
# files.
#
# Layout of home/:
#   home/
#   ├── default.nix          ← top-level: sets username/stateVersion, imports all
#   ├── apps/
#   │   ├── communication.nix   Discord, Signal, Telegram, Thunderbird
#   │   ├── media.nix           mpv, Spotify, Playerctl, Pipewire extras
#   │   ├── productivity.nix    LibreOffice, KeePassXC, Obsidian, Zathura
#   │   ├── development.nix     VSCode, direnv, gh CLI, Docker tools
#   │   └── utilities.nix       file managers, archivers, misc GUI helpers
#   ├── shell/
#   │   ├── zsh.nix             Zsh + plugins + aliases
#   │   ├── starship.nix        Starship prompt
#   │   └── tools.nix           fzf, zoxide, bat, eza, tmux …
#   ├── desktop/
#   │   ├── gnome-settings.nix  dconf keys (theme, extensions, keybinds)
#   │   └── xdg.nix             XDG user directories
#   └── services/
#       ├── git.nix             Git identity + global config
#       └── syncthing.nix       optional file-sync service
# ─────────────────────────────────────────────────────────────────────────────
{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    # Re-use the system nixpkgs rather than a separate HM-managed instance.
    # This avoids downloading a second copy of nixpkgs and keeps versions in
    # sync with the system packages.
    useGlobalPkgs   = true;

    # Install user packages into the per-user profile
    # (~/.nix-profile) rather than /etc/profiles.
    useUserPackages = true;

    # Pass flake inputs into every HM module so modules can reach
    # pkgs.unstable (via the overlay) or other flake outputs.
    extraSpecialArgs = { inherit inputs; };

    # Load additional Home Manager modules for all users.
    sharedModules = [
    ];

    # ── User bindings ──────────────────────────────────────────────────────
    # Each entry maps a NixOS username → a Home Manager configuration file.
    # Add more users here as needed.
    users.zerotens = import ../home/default.nix;
  };
}
