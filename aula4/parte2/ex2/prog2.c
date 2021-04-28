#include <detpic32.h>
void send2displays(unsigned int value);
void delay(int ms);

int main (void){
    unsigned int c = 0;
    TRISB = ( TRISB & 0x00FF);  // configure RB15-RD8 as outputs
    TRISD = (TRISD & 0xFF9F); // configure RD5-RD6 as outputs

    while (1)
    {
        delay(200);
        send2displays((c%64));
        c++;
    }
    return 0;
}


void send2displays(unsigned int value)
{
    static const char display7Scodes[] = {0x3F, // 0 -> 0011 1111
                        0x06, // 1 -> 0000 0110
                        0x5B, // 2 -> 0101 1011
                        0x4F, // 3-> 0100 1111
                        0x66, // 4 -> 0110 0110
                        0x6D, // 5 -> 0110 1101
                        0x7D, // 6 -> 0111 1101
                        0x07, // 7 -> 0000 0111
                        0x7F, // 8 -> 0111 1111
                        0x6F, // 9 -> 0110 1111
                        0x77, // a -> 0111 0111
                        0x7C, // b -> 0111 1100
                        0x39, // c -> 0011 1001
                        0x5E, // d -> 0101 1110
                        0x79, // e -> 0111 1001
                        0x71// f -> 0111 0001
                        };
    unsigned int dh,dl;

    LATD = (LATD & 0xFF9F) | 0x0040; // display high active, low inactive
    dh = value >> 4;
    LATB = (LATB & 0x00FF) | (display7Scodes[dh] << 8);

    LATD = (LATD & 0xFF9F) | 0x0020; // display low active, high inactive
    dl = value & 0x0F;
    LATB = (LATB & 0x00FF) | (display7Scodes[dl] << 8);
}

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}
