# hosts/desktop/hardware-configuration.nix
# ─────────────────────────────────────────────────────────────────────────────
# !! PLACEHOLDER — replace with the output of `nixos-generate-config` !!
#
# On the target machine run:
#   sudo nixos-generate-config --show-hardware-config > \
#     /path/to/nixos-config/hosts/desktop/hardware-configuration.nix
#
# Then commit the file to the repository.
# ─────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── Example values — overwrite with real values from nixos-generate-config ──
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules          = [];
  boot.kernelModules                 = [ "kvm-amd" ];   # or kvm-intel
  boot.extraModulePackages           = [];

  # Root filesystem (replace UUID with your real disk UUID from `blkid`)
  fileSystems."/" = {
    device  = "/dev/disk/by-uuid/REPLACE-WITH-ROOT-UUID";
    fsType  = "ext4";
  };

  fileSystems."/boot" = {
    device  = "/dev/disk/by-uuid/REPLACE-WITH-BOOT-UUID";
    fsType  = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # Swap (optional — use swapfile for easier resizing)
  # swapDevices = [{ device = "/dev/disk/by-uuid/REPLACE-WITH-SWAP-UUID"; }];
  swapDevices = [];

  # Swap file example (4 GiB):
  # swapDevices = [{ device = "/var/lib/swapfile"; size = 4 * 1024; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
