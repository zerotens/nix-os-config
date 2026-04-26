# home/services/git.nix
# ─────────────────────────────────────────────────────────────────────────────
# Git identity, global config, delta pager, and signing setup.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  programs.git = {
    enable    = true;
    userName  = "Your Name";        # ← change me
    userEmail = "you@example.com";  # ← change me

    # ── Core settings ────────────────────────────────────────────────────
    extraConfig = {
      init.defaultBranch   = "main";
      pull.rebase          = false;
      push.autoSetupRemote = true;   # push new branches without -u flag
      fetch.prune          = true;   # remove stale remote-tracking branches
      merge.conflictstyle  = "zdiff3"; # cleaner 3-way conflict markers
      rerere.enabled       = true;   # remember conflict resolutions

      # ── delta pager ───────────────────────────────────────────────────
      core.pager           = "delta";
      interactive.diffFilter = "delta --color-only";

      delta = {
        navigate          = true;    # n/N to jump between diff hunks
        light             = false;   # dark background
        side-by-side      = false;
        line-numbers      = true;
        syntax-theme      = "Catppuccin-mocha";
        plus-style        = "syntax #1e4620";
        minus-style       = "syntax #4a1a1a";
      };

      # ── Signing (GPG) — uncomment and fill in your key ─────────────────
      # commit.gpgsign  = true;
      # user.signingkey = "YOUR_GPG_KEY_ID";
      # gpg.format      = "openpgp";

      # ── SSH signing (simpler alternative to GPG) ───────────────────────
      # commit.gpgsign  = true;
      # gpg.format      = "ssh";
      # user.signingkey = "~/.ssh/id_ed25519.pub";
    };

    # ── Global gitignore ─────────────────────────────────────────────────
    ignores = [
      # OS artefacts
      ".DS_Store"
      "Thumbs.db"
      # Editors
      ".vscode/"
      ".idea/"
      "*.swp"
      "*~"
      # Nix
      "result"
      "result-*"
      ".direnv/"
      # Env files
      ".env"
      ".env.local"
    ];

    # ── Useful aliases ────────────────────────────────────────────────────
    aliases = {
      lg    = "log --oneline --graph --decorate --all";
      st    = "status -sb";
      undo  = "reset HEAD~1 --mixed";
      wip   = "!git add -A && git commit -m 'WIP'";
      unwip = "!git log -n 1 | grep -q 'WIP' && git reset HEAD~1";
    };
  };

  # delta is the pager declared in extraConfig above
  home.packages = [ pkgs.delta ];
}
