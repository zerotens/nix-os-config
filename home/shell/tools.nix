# home/shell/tools.nix
# ─────────────────────────────────────────────────────────────────────────────
# CLI quality-of-life tools — installed + configured via Home Manager programs.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  # ── Programs with HM module support ───────────────────────────────────────

  programs.fzf = {
    enable            = true;
    enableZshIntegration = true;
    defaultOptions    = [ "--height 40%" "--layout=reverse" "--border" "--info=inline" ];
    colors = {
      bg      = "#1e1e2e";
      "bg+"   = "#313244";
      fg      = "#cdd6f4";
      "fg+"   = "#cdd6f4";
      header  = "#f38ba8";
      hl      = "#f38ba8";
      "hl+"   = "#f38ba8";
      info    = "#cba6f7";
      marker  = "#f5e0dc";
      pointer = "#f5e0dc";
      prompt  = "#cba6f7";
      spinner = "#f5e0dc";
    };
  };

  programs.zoxide = {
    enable               = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme  = "Catppuccin-mocha";
      style  = "numbers,changes,header";
      pager  = "less -FR";
    };
    themes = {
      Catppuccin-mocha = {
        src  = pkgs.fetchFromGitHub {
          owner  = "catppuccin";
          repo   = "bat";
          rev    = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };

  programs.tmux = {
    enable        = true;
    shell         = "${pkgs.zsh}/bin/zsh";
    terminal      = "tmux-256color";
    historyLimit  = 10000;
    keyMode       = "vi";
    prefix        = "C-a";          # easier than C-b
    escapeTime    = 0;
    baseIndex     = 1;
    extraConfig   = ''
      # ── Pane splitting ─────────────────────────────────────────────────
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # ── Vim-style pane navigation ─────────────────────────────────────
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # ── Mouse support ─────────────────────────────────────────────────
      set -g mouse on

      # ── Status bar ────────────────────────────────────────────────────
      set -g status-position bottom
      set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
      set -g status-left  "#[fg=#89b4fa,bold] #S "
      set -g status-right "#[fg=#a6e3a1] %H:%M #[fg=#89dceb] %d %b "
      set -g window-status-current-format "#[fg=#f38ba8,bold] #I:#W "
      set -g window-status-format         "#[fg=#6c7086] #I:#W "

      # ── True colour ───────────────────────────────────────────────────
      set -as terminal-overrides ",*:Tc"
    '';
  };

  # ── Extra CLI packages (no HM program module needed) ──────────────────────
  home.packages = with pkgs; [
    eza          # modern ls
    duf          # modern df
    dust         # du alternative (Rust)
    procs        # modern ps
    sd           # sed alternative
    choose       # cut/awk alternative
    hyperfine    # command benchmarking
    jq           # JSON processor
    yq           # YAML/TOML processor
    xh           # HTTPie-compatible HTTP client (Rust, faster)
    tldr         # community man-page summaries
    navi         # interactive cheatsheet browser
  ];
}
