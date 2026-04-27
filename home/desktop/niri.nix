# home/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri compositor user configuration via sodiboo/niri-flake Home Manager module.
{ pkgs, ... }:

{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "${pkgs.unstable.noctalia-shell}/bin/noctalia-shell" ]; }
    ];
  };
}
