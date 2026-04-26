# home/apps/development.nix
# ─────────────────────────────────────────────────────────────────────────────
# Developer tools managed by Home Manager.
# Language runtimes that need system-level integration (e.g., Docker daemon)
# stay in the host configuration.nix — only user-space tooling lives here.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # ── Editors ───────────────────────────────────────────────────────────
    vscode                # VS Code (unfree; Wayland via NIXOS_OZONE_WL=1)
    # vscodium            # open-source VS Code build (no Microsoft telemetry)

    # ── Terminals ─────────────────────────────────────────────────────────
    alacritty             # GPU-accelerated, Wayland-native terminal
    # kitty               # alternative GPU terminal with tiling + image proto

    # ── Version control ───────────────────────────────────────────────────
    gh                    # GitHub CLI (pr, issue, repo, codespace …)
    lazygit               # terminal UI for git
    delta                 # syntax-highlighting git diff pager

    # ── Container / cloud tooling ─────────────────────────────────────────
    docker-compose        # multi-container orchestration
    dive                  # explore Docker image layers
    kubectl               # Kubernetes CLI
    k9s                   # terminal Kubernetes dashboard
    # awscli2             # uncomment for AWS CLI v2
    # google-cloud-sdk    # uncomment for gcloud

    # ── Language toolchains (user-space; pin versions in shell.nix per-project)
    nodejs_22             # Node.js LTS
    python3               # Python 3 interpreter
    rustup                # Rust toolchain manager
    go                    # Go toolchain
    jdk21                 # OpenJDK 21 LTS

    # ── API & network dev ─────────────────────────────────────────────────
    insomnia              # REST / GraphQL / gRPC client (Electron + Wayland)
    # postman             # alternative (unfree)
    httpie                # user-friendly HTTP CLI
    websocat              # WebSocket tester

    # ── Database ──────────────────────────────────────────────────────────
    dbeaver-bin           # multi-database GUI (unfree)
    # beekeeper-studio    # lighter SQL GUI (unfree community edition)
    sqlite                # embedded DB CLI

    # ── Infrastructure ────────────────────────────────────────────────────
    terraform             # IaC (unfree Business Source Licence)
    ansible               # agentless IT automation
  ];

  # ── VS Code (Home Manager module — writes settings.json) ──────────────────
  programs.vscode = {
    enable = true;
    # Extensions are declared here so they survive profile rebuilds.
    extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
      # Git
      eamodio.gitlens
      # Language support
      ms-python.python
      ms-python.vscode-pylance
      rust-lang.rust-analyzer
      golang.go
      # Containers
      ms-azuretools.vscode-docker
      # Theming
      catppuccin.catppuccin-vsc
      pkief.material-icon-theme
      # Productivity
      esbenp.prettier-vscode
      ms-vscode.makefile-tools
      usernamehw.errorlens
    ];
    userSettings = {
      "editor.fontFamily"            = "'JetBrainsMono Nerd Font', monospace";
      "editor.fontSize"              = 14;
      "editor.lineHeight"            = 1.6;
      "editor.fontLigatures"         = true;
      "editor.formatOnSave"          = true;
      "editor.tabSize"               = 2;
      "editor.rulers"                = [ 80 120 ];
      "editor.minimap.enabled"       = false;
      "editor.bracketPairColorization.enabled" = true;
      "workbench.colorTheme"         = "Catppuccin Mocha";
      "workbench.iconTheme"          = "material-icon-theme";
      "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
      "terminal.integrated.fontSize" = 13;
      "window.titleBarStyle"         = "custom";   # Wayland: use client-side decorations
      "telemetry.telemetryLevel"     = "off";
      "files.autoSave"               = "afterDelay";
      "nix.enableLanguageServer"     = true;
      "nix.serverPath"               = "nil";
      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
    };
  };

  # ── Alacritty terminal config ──────────────────────────────────────────────
  programs.alacritty = {
    enable   = true;
    settings = {
      window = {
        padding         = { x = 12; y = 12; };
        decorations     = "none";        # borderless on Wayland / GNOME
        opacity         = 0.95;
        dynamic_padding = true;
      };
      font = {
        normal.family  = "JetBrainsMono Nerd Font";
        normal.style   = "Regular";
        bold.style     = "Bold";
        italic.style   = "Italic";
        size           = 13.0;
      };
      # Catppuccin Mocha colour scheme
      colors = {
        primary  = { background = "#1e1e2e"; foreground = "#cdd6f4"; };
        cursor   = { text       = "#1e1e2e"; cursor      = "#f5e0dc"; };
        normal   = {
          black   = "#45475a"; red    = "#f38ba8"; green  = "#a6e3a1"; yellow = "#f9e2af";
          blue    = "#89b4fa"; magenta = "#f5c2e7"; cyan  = "#94e2d5"; white  = "#bac2de";
        };
        bright   = {
          black   = "#585b70"; red    = "#f38ba8"; green  = "#a6e3a1"; yellow = "#f9e2af";
          blue    = "#89b4fa"; magenta = "#f5c2e7"; cyan  = "#94e2d5"; white  = "#a6adc8";
        };
      };
    };
  };

  # ── direnv — auto-load per-project .envrc / shell.nix ─────────────────────
  programs.direnv = {
    enable            = true;
    nix-direnv.enable = true;   # fast nix-shell integration via cached-nix-shell
  };
}
