#include <detpic32.h>
unsigned char toBcd(unsigned char value);
void send2displays(unsigned char value);

int main(void)
{
    // Configure all (digital I/O, analog input, A/D module)
    TRISB = ( TRISB & 0x00FF);  // configure RB15-RD8 as outputs
    TRISD = (TRISD & 0xFF9F); // configure RD5-RD6 as outputs
    // Configure the A/D module and port RB4 as analog input
    TRISBbits.TRISB4 = 1;       // RB4 digital output disconnected
    AD1PCFGbits.PCFG4= 0;       // RB4 configured as analog input (AN4)
    AD1CON1bits.SSRC = 7;       // Conversion trigger selection bits: in this
                                // mode an internal counter ends sampling and
                                // starts conversion
    AD1CON1bits.CLRASAM = 1;    // Stop conversions when the 1st A/D converter
                                // interrupt is generated. At the same time,
                                // hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16;      // Sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 3;       // Interrupt is generated after 4 samples
                                // (replace XX by the desired number of
                                // consecutive samples)
    AD1CHSbits.CH0SA = 4;       // replace x by the desired input
                                // analog channel (0 to 15)
    AD1CON1bits.ON = 1;         // Enable A/D converter
                                // This must the last command of the A/D
                                // configuration sequence 
    int i = 0;
    unsigned char value;
    while(1)
    {
        if(i++ % 25 == 0) // 0, 250ms, 500ms, 750ms, ...
        {
            // Convert analog input (4 samples)
            AD1CON1bits.ASAM = 1;               // Start conversion
            while(IFS1bits.AD1IF == 0);         // Wait while conversion not done (AD1IF == 0)
            int c = 0;
            int sum = 0;
            int *p = (int *)(&ADC1BUF0);
            for(c = 0; c < 4; c++ )
            {
                sum += p[c*4];
            } 
            IFS1bits.AD1IF = 0;                 // Reset AD1IF
            int VAL_AD = sum/4;                 // Calculate buffer average
            unsigned char V=(VAL_AD*33+511)/1023;         // Calculate voltage amplitude
            value = toBcd(V);// Convert voltage amplitude to decimal
        }
        send2displays(value);// Send voltage value to displays

        resetCoreTimer();
        while(readCoreTimer() < 200000);// Wait 10 ms (using the core timer)
    }
    return 0;
}

unsigned char toBcd(unsigned char value)
{
    return ((value / 10) << 4) + (value % 10);
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
