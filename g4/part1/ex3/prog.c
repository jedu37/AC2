#include <detpic32.h> 

int main(void){

    TRISB = (TRISB & 0x00FF);
    LATB = (LATB & 0x00FF);
    
    TRISD = (TRISD & 0xFF9F);
    LATD = (LATD & 0xFF9F)|0x0020; //(LATD and 1111 1111 1001 1111 ) or 0000 0000 0010 0000



    while (1)
    {
        char seg = getChar();
        switch (seg)
        {
        case 'a':
            LATB = (LATB ^ 0x0100);
            break;
        case 'b':
            LATB = (LATB ^ 0x0200);
            break;
        case 'c':
            LATB = (LATB ^ 0x0400);
            break;
        case 'd':
            LATB = (LATB ^ 0x0800);
            break;
        case 'e':
            LATB = (LATB ^ 0x1000);
            break;
        case 'f':
            LATB = (LATB ^ 0x2000);
            break;
        case 'g':
            LATB = (LATB ^ 0x4000);
            break;
        default:
            break;
        } 
        
    }
}