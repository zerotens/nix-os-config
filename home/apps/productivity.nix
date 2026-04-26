# home/apps/productivity.nix
# ─────────────────────────────────────────────────────────────────────────────
# Office suite, notes, password management, PDF/document tools.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # ── Office suite ──────────────────────────────────────────────────────
    libreoffice-fresh     # Writer, Calc, Impress, Draw, Base, Math
    hunspell              # spell-check engine used by LibreOffice
    hunspellDicts.en_US   # English US dictionary
    hunspellDicts.de_DE   # German dictionary (adjust to taste)

    # ── Notes & knowledge base ────────────────────────────────────────────
    obsidian              # Markdown-based knowledge graph (unfree Electron)
    gnome-notes           # Bijiben: quick sticky notes in GNOME

    # ── Password management ───────────────────────────────────────────────
    keepassxc             # offline KeePass-compatible vault with browser integration

    # ── PDF & documents ───────────────────────────────────────────────────
    zathura               # minimal Vim-key PDF/DJVU reader
    evince                # GNOME Documents — full-featured PDF + multi-format viewer

    # ── Calendar & tasks ──────────────────────────────────────────────────
    gnome-calendar        # GNOME Calendar (links to GNOME Online Accounts)
    endeavour             # GNOME To Do (task manager, .ics + GOA sync)

    # ── Finance ───────────────────────────────────────────────────────────
    # gnucash             # uncomment if you want double-entry bookkeeping
  ];

  # ── Zathura config (writes ~/.config/zathura/zathurarc) ───────────────────
  programs.zathura = {
    enable  = true;
    options = {
      selection-clipboard = "clipboard";
      recolor             = true;           # dark-mode recolour by default
      recolor-keephue     = false;
      default-bg          = "#1e1e2e";      # Catppuccin Mocha palette
      default-fg          = "#cdd6f4";
      statusbar-bg        = "#313244";
      inputbar-bg         = "#1e1e2e";
      inputbar-fg         = "#cdd6f4";
      highlight-color     = "#f5c2e7";
    };
  };
}
