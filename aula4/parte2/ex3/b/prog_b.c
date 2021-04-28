#include <detpic32.h>
void send2displays(unsigned char value);
void delay(int ms);

int main (void){
    unsigned char c;
    TRISB = ( TRISB & 0x00FF);  // configure RB15-RD8 as outputs
    TRISD = (TRISD & 0xFF9F); // configure RD5-RD6 as outputs
    unsigned int i;

    c = 0;
    i = 0;
    while(1)
    {
        i++;
        send2displays(c);
        // wait 50 ms
        delay(50);

        if(i % 4 == 0){
            // increment counter
            c++;
        }
    }
    return 0; 

}


void send2displays(unsigned char value)
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
    static char displayFlag = 0;    // static variable: doesn't loose its
                                    // value between calls to function
    unsigned  int digit_low = value & 0x0F;
    unsigned  int digit_high = value >> 4;
    // if "displayFlag" is 0 then send digit_low to display_low
    if(displayFlag == 0){
        LATD = (LATD & 0xFF9F) | 0x0020; // display low active, high inactive
        LATB = (LATB & 0x00FF) | (display7Scodes[digit_low] << 8);
    }
    // else send digit_high to didplay_high
    else{
        LATD = (LATD & 0xFF9F) | 0x0040; // display high active, low inactive
        LATB = (LATB & 0x00FF) | (display7Scodes[digit_high] << 8);
    }
    // toggle "displayFlag" variable
    displayFlag = displayFlag ^ 0x01;
}

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}
