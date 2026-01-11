{...}: {
  networking = {
    # WiFi networks are configured at runtime using:
    # sudo nmcli device wifi connect "SSID" password "PASSWORD"
    hostName = "nixos-audio-player";
    networkmanager.enable = true;
    wireless.enable = false;
    firewall = {
      allowedTCPPorts = [
        3689
        5353
        5000
      ];
      allowedUDPPorts = [
        5353
      ];
      allowedTCPPortRanges = [
        {
          from = 7000;
          to = 7001;
        }
        {
          from = 32768;
          to = 60999;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 319;
          to = 320;
        }
        {
          from = 6000;
          to = 6009;
        }
        {
          from = 32768;
          to = 60999;
        }
      ];
    };
  };
}
