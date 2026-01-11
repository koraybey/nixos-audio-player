let
  username = "admin";
  homeDir = "/home/${username}";
in {
  _module.args = {
    userConfig = {
      inherit username homeDir;
      # "audio" group grants audio device access
      # "cdrom" group grants optical drive access
      # "input" grants HID device access (for future controls)
      # "wheel" adds system privileges
      groups = ["audio" "cdrom" "wheel" "input"];
    };
  };
}
