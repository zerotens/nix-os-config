# home/shell/starship.nix
# ─────────────────────────────────────────────────────────────────────────────
# Starship cross-shell prompt.
# ─────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      scan_timeout = 30;

      format = lib: ''
        $os$username$hostname$directory$git_branch$git_status$nix_shell$python$rust$golang$nodejs$docker_context
        $character'';

      character = {
        success_symbol = "[❄](bold cyan)";
        error_symbol   = "[✗](bold red)";
        vimcmd_symbol  = "[](bold green)";
      };

      directory = {
        style            = "bold blue";
        truncation_length = 4;
        truncate_to_repo = true;
        read_only        = " 󰌾";
      };

      git_branch = {
        symbol = " ";
        style  = "bold purple";
      };

      git_status = {
        style    = "bold yellow";
        ahead    = "⇡\${count}";
        behind   = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        modified = "!";
        staged   = "+";
        untracked = "?";
      };

      nix_shell = {
        symbol   = " ";
        style    = "bold blue";
        format   = "[$symbol$state( \\($name\\))]($style) ";
        heuristic = true;  # detect nix shells without $IN_NIX_SHELL
      };

      python = { symbol = " "; };
      rust   = { symbol = " "; };
      golang = { symbol = " "; };
      nodejs = { symbol = " "; };

      docker_context = {
        symbol = " ";
        style  = "blue bold";
        only_with_files = true;
      };

      os = {
        disabled = false;
        symbols.NixOS = " ";
      };
    };
  };
}
