#include <detpic32.h>

int main(void)
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
    // configure RB0 to RB3 as inputs and RB8 to RB14 to outputs
    TRISB = ( TRISB & 0x00F0) | 0X000F;
    // configure RD5 to RD6 as outputs
    TRISD = (TRISD & 0xFF9F); // configure RD5-RD6 as outputs
    // Select display low
    LATD = (LATD & 0xFF9F) | 0x0020; // display low active, high inactive
    while(1)
    {
    // read dip-switch
        unsigned int read = (0X000F & PORTB);
    // convert to 7 segments code
        unsigned int send = display7Scodes[read];
    // send to display
        LATB = (LATB & 0x00FF ) | ( send << 8 );
    }
    return 0; 
}