# home/desktop/xdg.nix
# ─────────────────────────────────────────────────────────────────────────────
# XDG user directories and MIME-type default application associations.
# ─────────────────────────────────────────────────────────────────────────────
{ config, ... }:

{
  # ── XDG user directories ────────────────────────────────────────────────────
  xdg.userDirs = {
    enable            = true;
    createDirectories = true;
    desktop    = "${config.home.homeDirectory}/Desktop";
    documents  = "${config.home.homeDirectory}/Documents";
    download   = "${config.home.homeDirectory}/Downloads";
    music      = "${config.home.homeDirectory}/Music";
    pictures   = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates  = "${config.home.homeDirectory}/Templates";
    videos     = "${config.home.homeDirectory}/Videos";
  };

  # ── MIME default applications ──────────────────────────────────────────────
  # Maps file types to the desktop application that opens them.
  # Find MIME types with: xdg-mime query filetype <file>
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web
      "text/html"                  = [ "firefox.desktop" ];
      "x-scheme-handler/http"      = [ "firefox.desktop" ];
      "x-scheme-handler/https"     = [ "firefox.desktop" ];
      "x-scheme-handler/about"     = [ "firefox.desktop" ];
      "x-scheme-handler/unknown"   = [ "firefox.desktop" ];

      # Documents
      "application/pdf"            = [ "org.gnome.Evince.desktop" ];
      "application/vnd.oasis.opendocument.text"         = [ "writer.desktop" ];
      "application/vnd.oasis.opendocument.spreadsheet"  = [ "calc.desktop" ];
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"       = [ "calc.desktop" ];

      # Images
      "image/jpeg"                 = [ "org.gnome.Loupe.desktop" ];
      "image/png"                  = [ "org.gnome.Loupe.desktop" ];
      "image/gif"                  = [ "org.gnome.Loupe.desktop" ];
      "image/webp"                 = [ "org.gnome.Loupe.desktop" ];
      "image/svg+xml"              = [ "org.gnome.Loupe.desktop" ];

      # Video
      "video/mp4"                  = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/x-matroska"           = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/webm"                 = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "video/x-msvideo"            = [ "io.github.celluloid_player.Celluloid.desktop" ];

      # Audio
      "audio/mpeg"                 = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "audio/flac"                 = [ "io.github.celluloid_player.Celluloid.desktop" ];
      "audio/ogg"                  = [ "io.github.celluloid_player.Celluloid.desktop" ];

      # Text / code
      "text/plain"                 = [ "code.desktop" ];
      "text/x-python"              = [ "code.desktop" ];
      "application/json"           = [ "code.desktop" ];
      "application/x-yaml"         = [ "code.desktop" ];

      # Archives
      "application/zip"            = [ "org.gnome.FileRoller.desktop" ];
      "application/x-tar"          = [ "org.gnome.FileRoller.desktop" ];
      "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];

      # Directories / file manager
      "inode/directory"            = [ "org.gnome.Nautilus.desktop" ];
    };
  };
}
