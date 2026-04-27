# home/desktop/niri.nix
# ─────────────────────────────────────────────────────────────────────────────
# Niri session services.
{ ... }:

{
  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell";
      After       = [ "graphical-session.target" ];
      PartOf      = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "noctalia-shell";
      Restart   = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
