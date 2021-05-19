#include <detpic32.h>
void send2displays(unsigned char value);
volatile unsigned char voltage = 0; // Global variable

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

unsigned char toBcd(unsigned char value)
{
    return ((value / 10) << 4) + (value % 10);
} 


int main(void)
{
    unsigned int cnt = 0;
    // Configure all (digital I/O, analog input, A/D module, interrupts)
    // Configure all (digital I/O, analog input, A/D module)
    TRISB = ( TRISB & 0x00FF);  // configure RB15-RD8 as outputs
    TRISD = (TRISD & 0xFF9F); // configure RD5-RD6 as outputs
    TRISBbits.TRISB4 = 1;       // RB4 digital output disconnected
    AD1PCFGbits.PCFG4= 0;       // RB4 configured as analog input (AN4)
    AD1CON1bits.SSRC = 7;       // Conversion trigger selection bits: in this
                                // mode an internal counter ends sampling and
                                // starts conversion
    AD1CON1bits.CLRASAM = 1;    // Stop conversions when the 1st A/D converter
                                // interrupt is generated. At the same time,
                                // hardware clears the ASAM bit
    AD1CON3bits.SAMC = 16;      // Sample time is 16 TAD (TAD = 100 ns)
    AD1CON2bits.SMPI = 7;       // Interrupt is generated after 4 samples
                                // (replace XX by the desired number of
                                // consecutive samples)
    AD1CHSbits.CH0SA = 4;       // replace x by the desired input
                                // analog channel (0 to 15)
    AD1CON1bits.ON = 1;         // Enable A/D converter
                                // This must the last command of the A/D
                                // configuration sequence
    // Configure interrupt system
    IPC6bits.AD1IP = 2; // configure priority of A/D interrupts
    IEC1bits.AD1IE = 1; // enable A/D interrupts
    IFS1bits.AD1IF = 0; // clear A/D interrupt flag 
    
    EnableInterrupts(); // Global Interrupt Enable
    while(1)
    {
        if(cnt % 25 == 0) // 250 ms (4 samples/second)
        {
            // Start A/D conversion
            AD1CON1bits.ASAM = 1;  
        }
        // Send "voltage" variable to displays
        send2displays(toBcd(voltage&0xFF));
        cnt++;
        // Wait 10 ms
        delay(10);
    }
    return 0;
}

void _int_(27) isr_adc(void)
{   
    int sum = 0;
    // Calculate buffer average (8 samples)
    int *p = (int *)(&ADC1BUF0);
    for(;p<= (int *)(&ADC1BUFF);p+=4){
        sum += *p;
    }
    // Calculate voltage amplitude
    double ave = (double)sum/8.0;// Calculate buffer average
    // Convert voltage amplitude to decimal. Assign it to "voltage"
    voltage = (char)((ave * 33)/1023);
    IFS1bits.AD1IF = 0; // Reset AD1IF flag
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