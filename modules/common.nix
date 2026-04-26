# modules/common.nix
# ─────────────────────────────────────────────────────────────────────────────
# Settings and packages that apply to EVERY machine in the fleet.
# Machine-specific overrides belong in hosts/<hostname>/configuration.nix.
{ config, pkgs, lib, ... }:

{
  # ── Nix / Flakes ───────────────────────────────────────────────────────────
  nix = {
    settings = {
      experimental-features  = [ "nix-command" "flakes" ];
      auto-optimise-store    = true;
      # Trusted users can modify nix.conf on the fly (useful during development)
      trusted-users          = [ "root" "@wheel" ];
    };

    # Automatic garbage collection: keep last 14 days, run weekly
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 14d";
    };
  };

  # ── Bootloader ─────────────────────────────────────────────────────────────
  boot.loader = {
    systemd-boot.enable      = true;
    efi.canTouchEfiVariables = true;
  };

  # ── Locale & Time ──────────────────────────────────────────────────────────
  time.timeZone               = lib.mkDefault "Europe/Berlin";
  i18n.defaultLocale          = "en_US.UTF-8";
  console.keyMap              = lib.mkDefault "de";

  # ── Networking ─────────────────────────────────────────────────────────────
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable       = true;
      # KDE Connect / GNOME Network Displays – open if needed per-host
      # allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    };
  };

  # ── Audio (PipeWire) ───────────────────────────────────────────────────────
  # PipeWire replaces PulseAudio and integrates JACK natively.
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;  # required for 32-bit Steam / Wine audio
    pulse.enable      = true;
    jack.enable       = true;
  };
  # Disable legacy PulseAudio daemon (PipeWire exposes the PulseAudio socket)
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true; # real-time priority for PipeWire

  # ── Printing ───────────────────────────────────────────────────────────────
  services.printing.enable = true;
  services.avahi = {
    enable      = true;
    nssmdns4    = true;
    openFirewall = true;
  };

  # ── Users ──────────────────────────────────────────────────────────────────
  users.users.zerotens = {
    isNormalUser = true;
    description  = "NixOS User";
    extraGroups  = [ "wheel" "networkmanager" "video" "audio" "gamemode" ];
    # Set password with: passwd zerotens
    # Or use: hashedPassword = "...";
  };

  # ── Allow unfree packages (Chrome, Steam, etc.) ────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── Common CLI tools ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    curl
    wget
    htop
    btop
    ripgrep
    fd
    bat
    eza          # modern ls replacement
    unzip
    p7zip

    # Nix helpers
    nix-output-monitor   # pretty nix build output
    nvd                  # diff between two NixOS generations
    nh                   # convenient nix helper CLI
  ];

  # ── SSH ────────────────────────────────────────────────────────────────────
  services.openssh = {
    enable       = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin        = "no";
    };
  };

  # ── System state version (do NOT change after initial install) ─────────────
  system.stateVersion = "25.11";
}
