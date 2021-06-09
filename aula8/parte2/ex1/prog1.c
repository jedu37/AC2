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

    IPC8bits.U2IP = 2;   //priority 2
    IEC1bits.U2RXIE = 1; //interrupts enabled
    IFS1bits.U2RXIF = 0; //clear reception interrupts fla
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

void _int_(32) isr_uart2(void)
{
    putc(U2RXREG);
    // Clear UART2 rx interrupt flag
    IFS1bits.U2RXIF = 0;
}

int main(void)
{
    configUart(115200,'N',1); // default "pterm" parameters
    // with RX interrupt enabled
    EnableInterrupts();
    while(1);
}