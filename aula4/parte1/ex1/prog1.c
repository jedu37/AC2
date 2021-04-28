#include <detpic32.h>

void delay(int ms);

int main(void)
{
    LATCbits.LATC14 = 0;    // The initial value should be set
                            // before configuring the port as output
    TRISCbits.TRISC14 = 0;  // RC14 configured as output

    while(1)
    {
        delay(500); // half period = 0.5s
        LATCbits.LATC14 = !LATCbits.LATC14;
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
