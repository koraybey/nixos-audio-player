{...}: {
  imports = [
    ./modules/cd-player
    ./modules/common.nix
    ./modules/hardware.nix
    ./modules/networking.nix
    ./modules/optimization.nix
    ./modules/services
    ./modules/user.nix
  ];

  nix = {
    settings = {
      trusted-users = ["root" "admin"];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  programs.nix-ld.enable = true;

  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";
}
