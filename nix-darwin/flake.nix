{
  description = "nix-darwin configuration with rosetta-builder for Linux builds";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nix-darwin,
    nix-rosetta-builder,
    nixpkgs,
  }: {
    darwinConfigurations.builder = nix-darwin.lib.darwinSystem {
      modules = [
        nix-rosetta-builder.darwinModules.default
        {
          nix-rosetta-builder.onDemand = true;
        }

        {
          nixpkgs.hostPlatform = "aarch64-darwin";

          # Allow nix-darwin to manage nix configuration
          nix.settings.experimental-features = ["nix-command" "flakes"];
          nix.settings.download-buffer-size = 512 * 1024 * 1024; # 512MB

          # Automatic garbage collection to prevent disk space issues
          nix.gc = {
            automatic = true;
            interval = {
              Weekday = 0;
              Hour = 2;
              Minute = 0;
            }; # Sunday 2 AM
            options = "--delete-older-than 30d";
          };

          # Automatically free up space when running low
          nix.settings.min-free = 5 * 1024 * 1024 * 1024; # Start GC at 5GB free
          nix.settings.max-free = 10 * 1024 * 1024 * 1024; # Keep 10GB free

          # Development tools
          environment.systemPackages = with nixpkgs.legacyPackages.aarch64-darwin; [
            nixd # Nix LSP for IDE support
            alejandra # Nix code formatter
            nixos-rebuild # Remote NixOS deployment tool
          ];

          system.stateVersion = 5;

          # Use touch ID for sudo
          security.pam.services.sudo_local.touchIdAuth = true;
        }
      ];
    };
  };
}
