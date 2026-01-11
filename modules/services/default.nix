{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.alsa-utils
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.userServices = true;
  };

  # ALSA configuration
  environment.etc."asound.conf".source = ./asound.conf;

  # Shairport-sync configuration file
  # Config syntax: https://github.com/mikebrady/shairport-sync/blob/master/scripts/shairport-sync.conf
  environment.etc."shairport-sync.conf".source = ./shairport-sync.conf;

  # NixOS built-in shairport-sync service with AirPlay 1 (classic) for lossless ALAC
  services.shairport-sync = {
    enable = true;
    package = pkgs.shairport-sync;
    arguments = "-v -c /etc/shairport-sync.conf";
  };
}
