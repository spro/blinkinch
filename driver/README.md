# blink(inch) Python USB driver

Requires [pyusb](https://github.com/walac/pyusb)

# Troubleshooting

If you see `usb.core.USBError: [Errno 13] Access denied (insufficient permissions)`, give yourself the correct permissions by creating a udev rule.

Create a group for the device and add yourself to it:

```bash
sudo groupadd blinkinch
sudo gpasswd -a myself blinkinch
```

Create a udev rule to give the group full permission to the device:

```bash
/lib/udev/rules.d/50-blinkinch.rules:
SUBSYSTEMS=="usb", ATTRS{idVendor}=="7372", ATTRS{idProduct}=="6b74", MODE="666", GROUP="blinkinch"
```

Unplug it, then re-trigger the udev rules:

```bash
sudo udevadm trigger
```
