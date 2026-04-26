# hosts/desktop/configuration.nix
# ─────────────────────────────────────────────────────────────────────────────
# Desktop-specific overrides.
# Run `nixos-generate-config` on the real machine to produce
# hardware-configuration.nix, then commit it alongside this file.
{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos-desktop";

  # ── GPU drivers ────────────────────────────────────────────────────────────
  # Uncomment the block that matches your GPU.

  # NVIDIA (proprietary — required for CUDA, best rasterization perf)
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia = {
  #   modesetting.enable  = true;
  #   open               = false;  # open kernel module (Turing+ only)
  #   nvidiaSettings     = true;
  #   package            = config.boot.kernelPackages.nvidiaPackages.stable;
  #   powerManagement.enable = false;
  # };
  # environment.sessionVariables.GBM_BACKEND   = "nvidia-drm";
  # environment.sessionVariables.__GLX_VENDOR_LIBRARY_NAME = "nvidia";

  # AMD (open kernel driver — recommended for RX 5000+)
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk          # AMD Vulkan driver
    rocmPackages.clr # ROCm OpenCL runtime (for GPU compute)
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  # Intel (integrated graphics — works out of the box, add VA-API packages)
  # hardware.opengl.extraPackages = with pkgs; [ intel-media-driver libva-vdpau-driver ];

  # ── Desktop-specific packages ──────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Creative / productivity
    gimp
    inkscape
    libreoffice-fresh
    vlc

    # Development
    vscode
    docker-compose
  ];

  # Docker for desktop development
  virtualisation.docker = {
    enable            = true;
    rootless.enable   = true;
    rootless.setSocketVariable = true;
  };
  users.users.zerotens.extraGroups = [ "docker" ];
}
