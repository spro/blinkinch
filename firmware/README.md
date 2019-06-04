# Credits

This is based on the source code from the AVR ATtiny USB HID Tutorial by Joonas Pihlajamaa, published at Code and Life blog, http://codeandlife.com

http://codeandlife.com/2012/02/11/v-usb-tutorial-continued-hid-mouse/

# Prerequisites

 * GNU C compiler (cross compiler for avr)
 * Standard C library for Atmel AVR development

# How to compile

```bash
# Debian Stretch
apt update
apt upgrade -y
apt install -y git build-essentials gcc-avr avr-libc
d=`mktemp -d`
cd $d
git clone https://github.com/spro/blinkinch.git
cd blinkinch/firmware
make
ls -al main.hex
```

