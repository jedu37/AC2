#include<detpic32.h>
enum Parity{N=0, E=1, O=2};

void configUart(unsigned int baud, char parity, unsigned int stopbits)
{
    if((baud>=600 & baud<=115200) & (parity == N | parity == E | parity == O) & (stopbits == 1 | stopbits == 2 ) ){
        // Configure BaudRate Generator
        U2BRG = ((PBCLK + 8 * baud) / (16 * baud)) - 1;
        U2MODEbits.BRGH = 0;
        // Configure number of data bits (8), parity and number of stop bits
        enum Parity par = parity;
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