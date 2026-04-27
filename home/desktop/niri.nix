# home/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri compositor user configuration (~/.config/niri/config.kdl).
{ ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "noctalia-shell"
  '';
}
