# hosts/laptop/hardware-configuration.nix
# ─────────────────────────────────────────────────────────────────────────────
# !! PLACEHOLDER — replace with the output of `nixos-generate-config` !!
# ─────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules          = [];
  boot.kernelModules                 = [ "kvm-intel" ];
  boot.extraModulePackages           = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-ROOT-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device  = "/dev/disk/by-uuid/REPLACE-WITH-BOOT-UUID";
    fsType  = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
