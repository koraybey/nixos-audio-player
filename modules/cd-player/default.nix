{pkgs, ...}: let
  cdplayScript = pkgs.substituteAll {
    src = ./cdplay.sh;
    isExecutable = true;
    dir = "bin";
    name = "cdplay";
    eject = "${pkgs.eject}/bin/eject";
    vlc = "${pkgs.vlc}/bin/cvlc";
  };
in {
  environment.systemPackages = [
    pkgs.vlc
    pkgs.eject
    cdplayScript
  ];

  boot.kernelModules = ["sr_mod" "cdrom"];
  boot.kernelParams = ["usbcore.autosuspend=-1"];

  services.udisks2.enable = false;
  services.smartd.enable = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="block", KERNEL=="sr[0-9]*", ENV{UDISKS_IGNORE}="1"
  '';
}
