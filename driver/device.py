import usb

dev = usb.core.find(idVendor=0x7372)
print("Connecting...")
while (not dev): continue
print("Connected to %s %s" % (hex(dev.idVendor), hex(dev.idProduct)))

def set_rgb(r, g, b):
    color = (r << 0) | (g << 1) | (b << 2)
    dev.ctrl_transfer(0xc0, 0, color)

