#include <detpic32.h>

void delay(int ms);

int main(void)
{
    unsigned char segment;
    int i;
    TRISB = (TRISB & 0x00FF); // configure RB8-RB14 as outputs
    TRISD = (TRISD & 0xFF9F); // configure RD5-RD6 as outputs
    LATD = (LATD & 0xFF9F) | 0x0040; // display high active, low inactive

    while(1)
    {
        LATD = LATD ^ 0x0060; // toggle display selection
        segment = 1;

        for(i=0; i < 7; i++)
        {
            unsigned int sendable = segment << 8; 
            LATB = (LATB && 0x00FF) | sendable;// send "segment" value to display
            delay(10);// wait 0.5 second
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
