{pkgs, ...}: {
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

  # Signal chain
  # Source (Mac/iPhone)
  #    ↓ AirPlay 1 ALAC codec (Apple Lossless)
  # shairport-sync
  #    ↓ Decodes to PCM
  #    ↓ 96 kHz, 24-bit
  # ALSA dmix
  #    ↓ S32_LE @ 96 kHz
  # MOTU M4
  #    ↓ 96 kHz, 24-bit DAC
  # Speakers

  # ALSA configuration - 96kHz S32_LE stereo
  # MOTU M4 supports: 44.1/48/88.2/96/176.4/192kHz @ S32_LE
  # Force 2 channels (stereo) to reduce CPU/bandwidth by 50%
  # dmix allows mixing AirPlay + local FLAC playback
  environment.etc."asound.conf".text = ''
    pcm.!default {
        type plug
        slave.pcm {
            type dmix
            ipc_key 1024
            slave {
                pcm "hw:0"
                format S24
                rate 48000
                channels 2
            }
        }
    }
    ctl.!default {
        type hw
        card 0
    }
  '';

  # Shairport-sync configuration file
  # Config syntax: https://github.com/mikebrady/shairport-sync/blob/master/scripts/shairport-sync.conf
  environment.etc."shairport-sync.conf".text = ''
    general = {
      name = "NixOS Audio Player";
      port = 7000;
      // Larger buffer helps prevent underruns on USB DACs
      audio_backend_buffer_desired_length_in_seconds = 0.5;
      // Allow some drift before forcing resync (prevents cracks from aggressive correction)
      drift_tolerance_in_seconds = 0.05;
    };

    alsa = {
      output_device = "default";
    };
  '';

  # NixOS built-in shairport-sync service with AirPlay 1 (classic) for lossless ALAC
  services.shairport-sync = {
    enable = true;
    package = pkgs.shairport-sync;
    arguments = "-v -c /etc/shairport-sync.conf";
  };
}
