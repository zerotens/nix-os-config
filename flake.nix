{
  description = "NixOS Multi-Machine Configuration";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      mkHost = { hostname, extraModules ? [] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ({ ... }: { nixpkgs.overlays = [ overlay-unstable ]; })

            # ── System modules ──────────────────────────────────────────────
            ./modules/common.nix
            ./modules/desktop/gnome.nix
            ./modules/programs/browsers.nix
            ./modules/programs/gaming.nix

            # ── Home Manager NixOS module ───────────────────────────────────
            # All Home Manager wiring lives in one place; no HM config
            # scattered across flake.nix.
            ./modules/home-manager.nix

            # ── Per-host overrides ──────────────────────────────────────────
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost { hostname = "desktop"; };

        laptop  = mkHost {
          hostname     = "laptop";
          extraModules = [ ./modules/hardware/laptop.nix ];
        };
      };
    };
}
