# home/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri compositor user configuration via Home Manager.
{ ... }:

{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
  };
}
