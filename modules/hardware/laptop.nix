# modules/hardware/laptop.nix
# ─────────────────────────────────────────────────────────────────────────────
# Laptop-specific tweaks: power management, backlight, touchpad, hibernate.
{ config, pkgs, lib, ... }:

{
  # ── Power management ───────────────────────────────────────────────────────
  services.power-profiles-daemon.enable = true; # GNOME power-profiles integration
  powerManagement.enable                = true;

  # TLP: fine-grained battery / CPU tuning (disable if using power-profiles-daemon)
  # services.tlp.enable = true;

  # ── Thermal management ─────────────────────────────────────────────────────
  services.thermald.enable = true;

  # ── Backlight control ──────────────────────────────────────────────────────
  programs.light.enable = true;         # brightnessctl / light CLI
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", \
      RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", \
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # ── Touchpad ──────────────────────────────────────────────────────────────
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping          = true;
      disableWhileTyping = true;
    };
  };

  # ── Suspend / Hibernate ────────────────────────────────────────────────────
  # Close lid → suspend; long-press power → hibernate (requires swap ≥ RAM size)
  services.logind.settings.Login = {
    HandleLidSwitch              = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandlePowerKey               = "hibernate";
    IdleAction                   = "suspend";
    IdleActionSec                = "10min";
  };

  # ── Laptop-specific packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    powertop      # diagnose power consumption
    acpi          # battery / AC status CLI
  ];
}
