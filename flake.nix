{
  description = "A NixOS-based audio streaming system for Raspberry Pi Zero 2 W with AirPlay 1 and CD playback support";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11-small";
  };

  outputs = {nixpkgs, ...}: {
    nixosConfigurations.nixos-audio-player = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./configuration.nix
        ({
          lib,
          config,
          ...
        }: {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              # Some packages, for example, ahci, fails when using Raspberry Pi kernels. This overray configuration bypasses that.
              # https://github.com/NixOS/nixpkgs/issues/154163
              # https://discourse.nixos.org/t/does-pkgs-linuxpackages-rpi3-build-all-required-kernel-modules/42509
              makeModulesClosure = x:
                prev.makeModulesClosure (x // {allowMissing = true;});
            })
          ];
          sdImage = {
            compressImage = false;
            imageBaseName = "nixos-audio-player";
          };
          fileSystems = lib.mkForce {
            "/boot/firmware" = {
              device = "/dev/disk/by-label/${config.sdImage.firmwarePartitionName}";
              fsType = "vfat";
              options = ["nofail"];
              neededForBoot = true;
            };
            "/" = {
              device = "/dev/disk/by-label/NIXOS_SD";
              fsType = "ext4";
            };
          };
        })
      ];
    };
  };
}
