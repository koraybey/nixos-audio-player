# NixOS Audio Player

A NixOS-based audio streaming system for Raspberry Pi Zero 2 W with AirPlay 1
and CD playback support

## Hardware Requirements

### Required

- Raspberry Pi Zero 2 W
- USB hub or hat (for multiple USB devices)
- USB audio interface with 2+ output channels
- Ethernet adapter or WiFi for network access

### Optional

- USB optical drive for CD playback

### Tested With

- **Output**: [MOTU M4](https://motu.com/en-us/products/m-series/m4/)
- **Hub**: [Waveshare Ethernet / USB HUB HAT](https://www.waveshare.com/eth-usb-hub-hat.htm)

## Building

### Prerequisites

On macOS, set up the build environment first:

```bash
# Install nix-darwin with rosetta-builder for cross-compilation
# Project includes an example flake in `nix-darwin` directory
mkdir -p ~/.config
ln -s $(pwd)/nix-darwin ~/.config/nix-darwin
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- \
  switch --flake ~/.config/nix-darwin#builder
```

### Configuration

`services/asound.conf` and `services/shairport-sync.conf` depends on your USB
audio interface and signal chain configuration. Refer to
[ALSA configuration examples](https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture/Configuration_examples)
and
[shairport-sync Advanced Topics](https://github.com/mikebrady/shairport-sync/tree/master/ADVANCED%20TOPICS)
for details.

Make sure to add your public key to `modules/user.nix`. Password authentication
is disabled.

### Build SD Card Image

```bash
nix build .#nixosConfigurations.nixos-audio-player.config.system.build.sdImage
```

The image will be at `result/sd-image/nixos-sd-image-*.img.zst`.

### Flash to SD Card

```bash
# Decompress
zstd -d result/sd-image/nixos-sd-image-*.img.zst -o nixos-audio-player.img

# Flash (replace diskX with your SD card)
sudo dd if=nixos-audio-player.img of=/dev/rdiskX bs=4m status=progress
```

## Installation

1. Insert SD card into Raspberry Pi
2. Connect USB audio interface to USB hub
3. Connect optical drive to USB hub
4. Connect Ethernet for initial setup
5. Power on the Raspberry Pi
6. Find IP address via router DHCP leases or `nmap -sn 192.168.1.0/24`
7. SSH into device: `ssh admin@<ip-address>`
8. Connect WiFi (Optional): `sudo nmcli device wifi connect "YourSSID" password "YourPassword"`

### Verify Audio Detection

Check that your audio device was detected:

```bash
# List playback hardware devices
aplay -l

# View generated ALSA config
cat /etc/asound.conf

# Check current ALSA playback format and rate
cat /proc/asound/card0/stream0

# Check service status
systemctl status shairport-sync
```

## Updating Running Devices

Deploy configuration changes to a running device:

```bash
nixos-rebuild --target-host admin@ nixos-rebuild --target-host admin@<device-ip>
--use-remote-sudo switch --flake .#nixos-audio-player
```

## Using the CD Player

The CD player interface is simple, only two commands around
[cvlc](https://manpages.ubuntu.com/manpages/trusty/en/man1/cvlc.1.html). You can
either play the entire CD or a specific track. This deliberate design decision
is because I enjoy the continuous playback experience similar to vinyl records.

## Caveats and Tradeoffs

### All sources share the same output channels

AirPlay and CD output to the same two channels with existing configuration. If
you play multiple sources simultaneously, they will mix together. Feel free to
tweak `services/asound.conf` and `services/shairport-sync.conf` to split to
signal to dedicated channels.

## License

GPL3
