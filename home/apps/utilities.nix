# home/apps/utilities.nix
# ─────────────────────────────────────────────────────────────────────────────
# GUI utility apps: file managers, archivers, system monitors, misc helpers.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # ── File management ───────────────────────────────────────────────────
    # nautilus is the GNOME default; install extras for power use
    nautilus-open-any-terminal   # right-click "Open in Terminal"
    gnome-sushi                  # spacebar quick-look in Nautilus
    file-roller                  # GNOME archive manager (zip/tar/7z GUI)

    # ── System monitoring ─────────────────────────────────────────────────
    mission-center       # modern GNOME process / resource monitor (libadwaita)
    # resources          # alternative GPU + network monitor
    nvtopPackages.full   # GPU usage overlay (NVIDIA + AMD + Intel)

    # ── Disk & storage ────────────────────────────────────────────────────
    gnome-disk-utility   # partition editor + disk health (GNOME Disks)
    gdu                  # fast terminal disk-usage visualiser
    dua                  # interactive TUI du replacement

    # ── Screenshots & screen tools ────────────────────────────────────────
    flameshot            # annotate + copy + upload screenshots
    # gnome-screenshot   # simpler alternative (already in GNOME by default)

    # ── Clipboard ─────────────────────────────────────────────────────────
    wl-clipboard         # wl-copy / wl-paste CLI (Wayland native)
    cliphist             # Wayland clipboard history manager

    # ── Network ───────────────────────────────────────────────────────────
    wireshark            # packet capture (adds user to wireshark group)
    networkmanagerapplet # nm-applet systray for quick WiFi switching

    # ── Fonts & theming ───────────────────────────────────────────────────
    gnome-font-viewer    # preview installed fonts
    dconf-editor         # advanced GNOME settings editor (use with care)

    # ── Misc helpers ──────────────────────────────────────────────────────
    # android-tools      # adb/fastboot for phone dev (uncomment if needed)
    # ventoy-bin-full    # bootable USB multi-ISO tool
    gparted              # GUI partition editor (requires polkit elevation)
  ];

  # ── Wireshark: add user to the capture group ──────────────────────────────
  # The NixOS option programs.wireshark.enable = true (in common.nix) creates
  # the wireshark group; we just ensure nixuser is a member.
  # (Group membership is set in common.nix via users.users.nixuser.extraGroups)
}
