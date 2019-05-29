#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>
#include <avr/eeprom.h>
#include <avr/pgmspace.h>
#include <util/delay.h>

#include "usbdrv.h"

uchar n_modes = 8;
uchar mode = 0;
uchar current = 0;
uchar max_value = 16;

// USB Setup
// -----------------------------------------------------------------------------

#define USB_SET_RGB 0

static uchar reportBuf[16];
static uchar replyBuf[16] = "Hello there";

uchar color_r = 0;
uchar color_g = 0;
uchar color_b = 0;

uchar usbFunctionSetup(uchar data[8]) {
    usbRequest_t *rq = (void *)data;
    int val;

    switch(rq->bRequest) {
        case USB_SET_RGB:
            // TODO: Get mode from data
            val = rq->wValue.bytes[0];
            color_r = (val & (1 << 0)) >> 0;
            color_g = (val & (1 << 1)) >> 1;
            color_b = (val & (1 << 2)) >> 2;
            show_color();
            return 0;
        default:
            return USB_NO_MSG;
    }

	return 0;
}

uchar usbFunctionRead(uchar *data, uchar len) {
    data[0] = 0xf3;
    return len;
}

void usbFunctionWriteOut(uchar * data, uchar len) {

}

void usbEventResetReady(void) {
    setCalibration();
}

#define BLINK_MS 100
#define R_PIN 0
#define G_PIN 1
#define B_PIN 4

void show_color() {
    if (color_r)
        PORTB |= (1 << R_PIN);
    else
        PORTB &= ~(1 << R_PIN);
    if (color_g)
        PORTB |= (1 << G_PIN);
    else
        PORTB &= ~(1 << G_PIN);
    if (color_b)
        PORTB |= (1 << B_PIN);
    else
        PORTB &= ~(1 << B_PIN);
}

void blink() {
    PORTB |= (1 << R_PIN);
    _delay_ms(BLINK_MS);
    PORTB &= ~(1 << R_PIN);
    _delay_ms(BLINK_MS);
}

uint32_t recovering = 0;
#define DEBOUNCE   10000
int next = 0;

int main() {
    wdt_disable();
	
    readCalibration();

	DDRB |= (1 << R_PIN) | (1 << B_PIN) | (1 << G_PIN);
    blink();

    // Reconnection cycle
    usbDeviceDisconnect();
    uchar i;
    for(i=0;i<60;i++){  /* 500 ms disconnect */
        wdt_reset();
        _delay_ms(15);
    }
    usbDeviceConnect();

    wdt_enable(WDTO_1S);
    usbInit();

    //sei();

    blink();
    blink();

    uchar keydown = 0;

    int trying = 0;

    while(1) {
        wdt_reset(); // keep the watchdog happy
        usbPoll();
    }

    return 0;
}
