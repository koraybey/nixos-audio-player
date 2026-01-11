{
  pkgs,
  lib,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi02w;
    supportedFilesystems.zfs = lib.mkForce false;
    # USB audio, USB HID, USB host controller
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "snd_usb_audio"];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    # Explicitly blacklist USB gadget Ethernet
    # Required for Waveshare Ethernet / USB HUB to work
    blacklistedKernelModules = ["g_ether"];
  };

  # Enable max USB current (1.2A) for USB audio interfaces
  # Pi Zero 2W default: 600mA, with max_usb_current=1: 1200mA
  # Appends to config.txt only if not already present
  system.activationScripts.maxUsbCurrent.text = ''
    if [ -f /boot/firmware/config.txt ]; then
      if ! grep -q "^max_usb_current=1$" /boot/firmware/config.txt; then
        echo "max_usb_current=1" >> /boot/firmware/config.txt
      fi
    fi
  '';

  hardware = {
    enableRedistributableFirmware = true;
    # Overlay for Ethernet / USB HUB (USB host mode for audio interfaces)
    deviceTree = {
      filter = "bcm2837-rpi-zero*.dtb";
      overlays = [
        {
          name = "dwc2-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            /{
              compatible = "brcm,bcm2837";

              fragment@0 {
                target = <&usb>;
                #address-cells = <1>;
                #size-cells = <1>;
                dwc2_usb: __overlay__ {
                  compatible = "brcm,bcm2835-usb";
                  dr_mode = "host";
                  g-np-tx-fifo-size = <32>;
                  g-rx-fifo-size = <558>;
                  g-tx-fifo-size = <512 512 512 512 512 256 256>;
                  status = "okay";
                };
              };

              __overrides__ {
                dr_mode = <&dwc2_usb>, "dr_mode";
                g-np-tx-fifo-size = <&dwc2_usb>,"g-np-tx-fifo-size:0";
                g-rx-fifo-size = <&dwc2_usb>,"g-rx-fifo-size:0";
              };
            };
          '';
        }
      ];
    };
  };
}
