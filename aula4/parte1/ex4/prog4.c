#include <detpic32.h>

void delay(int ms);

int main(void)
{
    unsigned char segment;
    int i;
    TRISB = (TRISB & 0x00FF); // configure RB8-RB14 as outputs
    TRISD = (TRISD & 0xFF9F); // configure RD5-RD6 as outputs
    LATDbits.LATD6 = 1; // display high active
    LATDbits.LATD5 = 0; // display low inactive

    while(1)
    {
        LATDbits.LATD6 = !LATDbits.LATD6; //
        LATDbits.LATD5 = !LATDbits.LATD5; // toggle display selection
        segment = 1;

        for(i=0; i < 7; i++)
        {
            unsigned int sendable = segment << 8; 
            LATB = (LATB && 0x00FF) | sendable;// send "segment" value to display
            delay(500);// wait 0.5 second
            segment = segment << 1;
        }
    }
    return 0;
} 

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}
