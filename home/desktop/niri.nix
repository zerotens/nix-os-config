# home/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri compositor user configuration via sodiboo/niri-flake Home Manager module.
{ ... }:

{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
  };
}
