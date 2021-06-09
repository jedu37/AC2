#include<detpic32.h>

volatile unsigned char voltage = 0;
volatile unsigned char voltMin = 0x33;
volatile unsigned char voltMax = 0x00;

 void putc(char byte2send)
{
    while(U2STAbits.UTXBF == 1);                    //wait while UTXBF==1
    U2TXREG = byte2send;

}

 void puts(char *str)
 {
    // use putc() function to send each charater ('\0' should not
    // be sent)
    while(*str != '\0'){
        putc(*str);
        str++;
    }
 } 

void setPWM(unsigned int dutyCycle){
    // duty_cycle must be in the range [0, 100]
    //assert ((dutyCycle >= 0) && (dutyCycle <= 100));
    if((dutyCycle >= 0) && (dutyCycle <= 100)){
        OC1RS = ((49999+1)*dutyCycle)/1000;
    }
   
    // Evaluate OC1RS as a function of "dutyCycle"
}

void send2displays(unsigned char value) {
    static const char display7Scodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
    static char displayFlag = 1;
    unsigned char dh = display7Scodes[value >> 4];
    unsigned char dl = display7Scodes[value & 0x0F];

    if(displayFlag) {
        // send digit_high (dh) to display_high: dh = value >> 4
        LATDbits.LATD6 = 1;
        LATDbits.LATD5 = 0;
        LATB = (dh << 8) | (LATB & 0x00FF);
    }

    else {
        // send digit_low (dl) to display_low: dl = value & 0x0F
        LATDbits.LATD6 = 0;
        LATDbits.LATD5 = 1;
        LATB = (dl << 8) | (LATB & 0x00FF);
    }

    displayFlag = !displayFlag;
}
void _int_(32) isr_uart2(void){
    if(U2RXREG == 'L'){
        // Send "voltMin" and "voltMax" to the serial port UART1
        puts("Minimum registered voltage: ");
        char up = 0x30 | ((voltMin & 0xF0) >> 4);
        putc(up);
        putc('.');
        char down = 0x30 | (voltMin & 0x0F);
        putc(down);
        putc('\n');
        puts("Maximum registered voltage: ");
        up = 0x30 | ((voltMax & 0xF0) >> 4);
        putc(up);
        putc('.');
        down = 0x30 | (voltMax & 0x0F);
        putc(down);
        putc('\n');
        putc('\n');
        putc('\n');
        putc('\n');
        IFS1bits.U2RXIF = 0;

    }
    // Clear UART1 rx interrupt flag 
}
void _int_(27) isr_adc(void){
    int soma = 0;
    int average = 0;
    int volt = 0;
    int q = 0;
    int r = 0;
    // Calculate buffer average (8 samples)
    int *p = (int *) (&ADC1BUF0);
    int i = 0;
    for (i = 0; i < 8; i++){
        soma += p[i*4];
    }

    average = soma / 8;
    
    // Calculate voltage amplitude
    volt = (average*33)/1023;
    // Convert voltage amplitude to decimal. Assign it to "voltage"
    q = volt / 10;
    r = volt % 10;

    voltage = (q << 4 | r);

    if (voltage > voltMax){
        voltMax = voltage;
    }
    else if (voltage < voltMin){
        voltMin = voltage;
    }
    // Reset AD1IF flag
    IFS1bits.AD1IF = 0;
}

void _int_(4) isr_T1(void) {
    AD1CON1bits.ASAM = 1;       // Start conversion
    IFS0bits.T1IF = 0;
} 

void _int_(12) isr_T3(void) {
    send2displays(voltage);
    IFS0bits.T3IF = 0;          // Reset timer T3 interrupt flag
} 
void configureAll(){
    // hexDisp configs
    LATB = LATB & 0x00FF;
    TRISB = TRISB & 0x00FF;
    TRISDbits.TRISD5 = 0;
    TRISDbits.TRISD6 = 0;

    LATEbits.LATE1 = 0;
    TRISEbits.TRISE1 = 0;


    // ADC
    TRISBbits.TRISB4 = 1;
    AD1PCFGbits.PCFG4 = 0;
    AD1CON1bits.SSRC = 7;
    AD1CON1bits.CLRASAM = 1;
    AD1CHSbits.CH0SA = 4;
    AD1CON2bits.SMPI = 7;
    AD1CON3bits.SAMC = 16;
    AD1CON1bits.ON = 1;
    IPC6bits.AD1IP = 2;
    IEC1bits.AD1IE = 1;
    IFS1bits.AD1IF = 0;

    // Timer 1 configs
    T1CONbits.TCKPS = 7;
    PR1 = 19530;
    TMR1 = 0;
    T1CONbits.TON = 1;
    IPC1bits.T1IP = 2;
    IFS0bits.T1IF = 0;

    // Timer 3 configs
    T3CONbits.TCKPS = 2;
    PR3 = 49999;
    TMR3 = 0;
    T3CONbits.TON = 1;
    IPC3bits.T3IP = 2;
    IEC0bits.T3IE = 1;
    IFS0bits.T3IF = 0;

    // PWM configs
    OC1CONbits.OCM = 6;
    OC1CONbits.OCTSEL = 1;
    OC1CONbits.ON = 1;

}
void configUart(unsigned int baud, char parity, unsigned int stopbits)
 {

    if(baud < 600 || baud > 115200)
        baud = 115200;
    if(parity!='N' || parity!='E' || parity!='O')
        parity = 'N';
    if(stopbits!=1 || stopbits!=2)
        stopbits = 1;

    // Configure BaudRate Generator
    U2BRG = ((PBCLK + 8*baud)/(16*baud))-1;
    U2MODEbits.BRGH = 0;                            //16x baud clock enabled
    // Configure number of data bits (8), parity and number of stop bits
    switch (parity)
    {
    case 'E':
        U2MODEbits.PDSEL = 1;                       //8bits, even parity
        break;
    case 'O':
        U2MODEbits.PDSEL = 2;                       //8bits, odd parity
        break;
    default:
        U2MODEbits.PDSEL = 0;                       //8bits, no parity
        break;
    }

    switch (stopbits)
    {
    case 2:
        U2MODEbits.STSEL = 1;                           //2 stop bits
        break;
    
    default:
        U2MODEbits.STSEL = 0;                           //1 stop bit
        break;
    }
    
    // Enable the trasmitter and receiver modules
    U2STAbits.UTXEN = 1;                            //UART2 transmiter is enabled
    U2STAbits.URXEN = 1;                            //UART2 receiver is enabled
    // Enable UART2
    U2MODEbits.ON = 1;                              //UART2 enabled
 } 

int main(void){
    int dutyCycle;
    configUart(115200,'N',1);
    configureAll();
    EnableInterrupts(); // Global Interrupt Enable
    while(1){
        LATEbits.LATE1 = 1;
        // Read RB1, RB0 to the variable "portVal"
        int portVal = PORTB & 0x00003;
        switch(portVal){
            case 0: // Measure input voltage
                // Enable T1 interrupts
                IEC0bits.T1IE = 1;
                setPWM(0); // LED OFF
                break;
            case 1: // Freeze
                // Disable T1 interrupts
                IEC0bits.T1IE = 1;
                setPWM(100); // LED ON (maximum bright)
                break;
            default: // LED brigthness control
                // Enable T1 interrupts
                IEC0bits.T1IE = 1;
                dutyCycle = voltage * 3;
                setPWM(dutyCycle);
                break;
        }
    }

    return 0;
}