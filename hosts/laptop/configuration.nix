# hosts/laptop/configuration.nix
# ─────────────────────────────────────────────────────────────────────────────
# Laptop-specific overrides (hardware module loaded via flake.nix extraModules).
{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos-laptop";

  # ── GPU: Intel integrated + NVIDIA Optimus (common laptop combo) ───────────
  # For a pure Intel laptop, remove the nvidia block entirely.
  # For AMD+AMD, use the amdgpu driver and amdvlk packages.

  # Intel iGPU (VA-API for hardware video decode)
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver   # iHD driver (Gen 8+)
    vaapiVdpau
    libvdpau-va-gl
  ];

  # NVIDIA dGPU via PRIME offloading (run demanding apps on the dGPU on demand)
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   prime = {
  #     offload.enable = true;
  #     offload.enableOffloadCmd = true;  # adds `nvidia-offload` helper
  #     # Find Bus IDs with: lspci | grep -E 'VGA|3D'
  #     intelBusId  = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };
  # };

  # ── Wireless ────────────────────────────────────────────────────────────────
  networking.wireless.iwd.enable = true;
  # If your card needs firmware, add it here:
  # hardware.firmware = [ pkgs.linux-firmware ];

  # ── Bluetooth ──────────────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # battery level reporting
  };
  services.blueman.enable = true;

  # ── Laptop-specific packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Note-taking / productivity
    obsidian
    libreoffice-fresh

    # Development
    vscode
  ];
}
