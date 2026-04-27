# home/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri compositor user configuration via sodiboo/niri-flake Home Manager module.
{ pkgs, inputs, ... }:

{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell" ]; }
    ];
  };
}
