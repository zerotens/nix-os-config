# home/shell/zsh.nix
# ─────────────────────────────────────────────────────────────────────────────
# Zsh shell configuration with plugins and aliases.
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable                    = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;
    enableCompletion          = true;
    history = {
      size       = 10000;
      save       = 50000;
      ignoreDups = true;
      share      = true;
    };

    initExtra = ''
      # ── zoxide smart cd ─────────────────────────────────────────────────
      eval "$(zoxide init zsh --cmd cd)"

      # ── fzf key bindings (Ctrl-R history, Ctrl-T file, Alt-C dir) ───────
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh

      # ── Better fzf defaults (use fd for file listing) ────────────────────
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

      # ── Nix shell integration (show active devShell in prompt) ───────────
      if [[ -n "$IN_NIX_SHELL" ]]; then
        export NIX_SHELL_ACTIVE="❄ $name"
      fi
    '';

    shellAliases = {
      # Modern replacements
      ls   = "eza --icons --group-directories-first";
      ll   = "eza -la --icons --group-directories-first --git";
      lt   = "eza --tree --icons --level=2";
      cat  = "bat --paging=never";
      grep = "rg";
      find = "fd";
      top  = "btop";
      df   = "duf";

      # NixOS workflow
      rebuild      = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname) |& nom";
      rebuild-test = "sudo nixos-rebuild test   --flake /etc/nixos#$(hostname) |& nom";
      rebuild-boot = "sudo nixos-rebuild boot   --flake /etc/nixos#$(hostname)";
      rebuild-dry  = "sudo nixos-rebuild dry-activate --flake /etc/nixos#$(hostname)";
      nix-gc       = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
      nix-diff     = "nvd diff /run/current-system $(ls -d /nix/var/nix/profiles/system-*-link | tail -1)";
      nix-update   = "nix flake update /etc/nixos";
      hm-switch    = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";

      # Git shortcuts (also see lazygit alias below)
      g    = "git";
      ga   = "git add";
      gc   = "git commit";
      gp   = "git push";
      gl   = "git pull";
      gst  = "git status";
      glog = "git log --oneline --graph --decorate";

      # Misc
      mkdir = "mkdir -p";
      ".."  = "cd ..";
      "..." = "cd ../..";
      lg    = "lazygit";
    };
  };
}
