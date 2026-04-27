# ❄️ NixOS Multi-Machine Configuration

Flake-based NixOS configuration managing multiple machines with a shared
baseline and per-host overrides. Every machine gets **GNOME on Wayland**,
**Firefox**, **Chromium**, and **Steam**.

---

## Repository Layout

```
nixos-config/
├── flake.nix                   # Entry point — defines all machines
├── modules/
│   ├── common.nix              # Shared settings (Nix config, audio, users…)
│   ├── desktop/
│   │   └── gnome.nix           # GNOME + Wayland + XDG portals
│   ├── programs/
│   │   ├── browsers.nix        # Firefox (system) + Chromium
│   │   └── gaming.nix          # Steam, Proton, GameMode, MangoHUD
│   └── hardware/
│       └── laptop.nix          # Power management, backlight, touchpad
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix   # Desktop GPU, Docker, extra apps
│   │   └── hardware-configuration.nix   # !! Generate on real hardware !!
│   └── laptop/
│       ├── configuration.nix   # Optimus PRIME, Bluetooth, wireless
│       └── hardware-configuration.nix
└── home/
    └── default.nix             # Home Manager — dotfiles, user packages
```

---

## Quick Start

### 1 — Clone the repo

```bash
git clone https://github.com/YOUR_USER/nixos-config /etc/nixos
cd /etc/nixos
```

### 2 — Generate hardware config for each machine

On each target machine run:

```bash
sudo nixos-generate-config --show-hardware-config \
  > hosts/<hostname>/hardware-configuration.nix
```

Replace `<hostname>` with `desktop` or `laptop` (or add a new host).

### 3 — Edit `hosts/<hostname>/configuration.nix`

- Set `networking.hostName`
- Uncomment the correct GPU driver block (AMD / NVIDIA / Intel)
- Adjust disk UUIDs in `hardware-configuration.nix`

### 4 — Edit `home/default.nix`

Update `programs.git.userName` and `programs.git.userEmail`.

### 5 — Apply the configuration

```bash
# First install (from NixOS live ISO, after mounting disks):
sudo nixos-install --flake /path/to/nixos-config#desktop

# Subsequent updates (on the running machine):
sudo nixos-rebuild switch --flake /etc/nixos#desktop
# or use the shell alias:
rebuild
```

---

## Adding a New Machine

1. Create `hosts/<new-host>/` with `configuration.nix` + `hardware-configuration.nix`
2. Add an entry in `flake.nix` under `nixosConfigurations`:

```nix
new-host = mkHost { hostname = "new-host"; };
```

3. Commit and run `nixos-rebuild switch --flake /etc/nixos#new-host`

---

## Useful Commands

| Task | Command |
|---|---|
| Rebuild + switch | `sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)` |
| Test without booting | `sudo nixos-rebuild test --flake /etc/nixos#$(hostname)` |
| Build without applying | `nix build /etc/nixos#nixosConfigurations.desktop.config.system.build.toplevel` |
| Garbage collect | `sudo nix-collect-garbage -d` |
| Diff generations | `nvd diff /run/current-system /nix/var/nix/profiles/system` |
| Update all inputs | `nix flake update` |
| Update one input | `nix flake lock --update-input nixpkgs` |

---

## Wayland Notes

- **Session**: GDM defaults to the GNOME Wayland session.
- **Firefox**: Runs natively on Wayland via `MOZ_ENABLE_WAYLAND=1` (set automatically by the Firefox NixOS module).
- **Chromium**: Launched with `--ozone-platform-hint=auto` for automatic Wayland detection.
- **Steam / Proton**: XWayland is kept enabled for games that don't support Wayland natively. Use **Gamescope** for VRR/HDR/FSR on a per-game basis.
- **Electron apps**: `NIXOS_OZONE_WL=1` (set in `gnome.nix`) hints all Electron apps to use the Wayland backend.

---

## Secrets Management

For SSH keys, API tokens, and passwords, consider:
- **[agenix](https://github.com/ryantm/agenix)** — age-encrypted secrets checked into the repo
- **[sops-nix](https://github.com/Mic92/sops-nix)** — SOPS + age/GPG

Never commit plain-text secrets. The `.gitignore` excludes `secrets/` and `*.age` by default.
