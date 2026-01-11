{...}: {
  imports = [
    ./modules/common.nix
    ./modules/hardware.nix
    ./modules/networking.nix
    ./modules/optimization.nix
    ./modules/services.nix
    ./modules/user.nix
  ];

  nix = {
    settings = {
      trusted-users = ["root" "admin"];
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  security.sudo.wheelNeedsPassword = true;

  programs.nix-ld.enable = true;

  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";
}
