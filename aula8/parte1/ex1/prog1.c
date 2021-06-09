#include <detpic32.h>

int main(void)
{
    // Configure UART2:
    // 1 - Configure BaudRate Generator
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

    return 0;
} 
