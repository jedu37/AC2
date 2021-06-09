#include<detpic32.h>

void configUart(unsigned int baud, char parity, unsigned int stopbits)
{
    if(((baud>=600) & (baud<=115200)) & ((parity == 'N') | (parity == 'E') | (parity == 'O')) & ((stopbits == 1) | (stopbits == 2) ) ){
        // Configure BaudRate Generator
        U2BRG = ((PBCLK + 8 * baud) / (16 * baud)) - 1;
        U2MODEbits.BRGH = 0;
        // Configure number of data bits (8), parity and number of stop bits
        int par;
        if(parity == 'N'){par = 0;}
        if(parity == 'E'){par = 1;}
        if(parity == 'O'){par = 2;}
        else{par = 0;}
        U2MODEbits.PDSEL = par;
        U2MODEbits.STSEL = stopbits-1;
    }else{
        // Configure BaudRate Generator
        U2BRG = ((PBCLK + 8 * 115200) / (16 * 115200)) - 1;
        U2MODEbits.BRGH = 0;
        // 2 – Configure number of data bits, parity and number of stop bits
        // (see U1MODE register)
        U2MODEbits.PDSEL = 0;
        U2MODEbits.STSEL = 1;
        // 3 – Enable the trasmitter and receiver modules (see register U1STA)
        U2STAbits.UTXEN = 1;
        U2STAbits.URXEN = 1;
        // 4 – Enable UART2 (see register U1MODE)
        U2MODEbits.ON = 1;
    }
    // 3 – Enable the trasmitter and receiver modules (see register U1STA)
    U2STAbits.UTXEN = 1;
    U2STAbits.URXEN = 1;
    // 4 – Enable UART2 (see register U1MODE)
    U2MODEbits.ON = 1;
} 

void delay(int ms)
{
    for(; ms > 0; ms--)
    {
        resetCoreTimer();
        while(readCoreTimer() < 20000);
    }
}

void putc(char byte2send)
{
    // wait while UTXBF == 1
    while (U2STAbits.UTXBF == 1);
    // Copy byte2send to the UxTXREG register
    U2TXREG = byte2send;
}

void puts(char *str)
{
    // use putc() function to send each charater ('\0' should not
    // be sent)
    char* s;
    for (s=&str[0]; *s != '\0'; s++ )
    {
        putc(*s);
    }
} 

int main(void)
{
    configUart(115200,'N',1); //default "pterm" parameters (8 data bits)
    // configUart(57600,'N',1); // Ex7
    // configUart(19200,'N',1); // Ex7
    TRISBbits.TRISB6 = 0;// config RB6 as output
    LATBbits.LATB6 = 0;
    while(1)
    {
        // Wait until TRMT == 1
        while(U2STAbits.TRMT != 1); // Ex8 - Comment this line
        // Set RB6
        LATBbits.LATB6 = 1;

        puts("12345");
        //puts("123456789");
        //puts("123456789A");
        //puts("123456789AB");
        puts("12345");
        // Reset RB6
        LATBbits.LATB6 = 0;
    }
} 