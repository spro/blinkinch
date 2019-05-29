import sys

if len(sys.argv) < 3:
    print("Usage: python set_rgb.py R G B")
    sys.exit(0)

from device import set_rgb

rgb = map(int, sys.argv[1:])
set_rgb(rgb[0], rgb[1], rgb[2])
