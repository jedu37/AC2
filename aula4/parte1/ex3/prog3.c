#include <detpic32.h>

void delay(int ms);

int main(void){
    TRISB = (TRISB & 0x00FF);
    TRISD = (TRISD & 0xFF9F);

    LATD = ( LATD & 0xFF9F) | 0x0020;

    while(1){
        char c = getChar();
        switch(c){
            case 'a': LATB = (LATB ^ 0x0100);  //a -> RB8
                break;
                
            case 'b': LATB = (LATB ^ 0x0200); //b -> RB9
                break;
                
            case 'c': LATB = (LATB ^ 0x0400); //c -> RB10
                break;
                
            case 'd': LATB = (LATB ^ 0x0800); //d -> RB11
                break;
                
            case 'e': LATB = (LATB ^ 0x1000); //e -> RB12
                break;
                
            case 'f': LATB = (LATB ^ 0x2000);//f -> RB13
                break;
                
            case 'g': LATB = (LATB ^ 0x4000);//g -> RB14
                break;
            
            case 'A': LATB = (LATB ^ 0x0100);  //A -> RB8
                break;
                
            case 'B': LATB = (LATB ^ 0x0200); //B -> RB9
                break;
                
            case 'C': LATB = (LATB ^ 0x0400); //C -> RB10
                break;
                
            case 'D': LATB = (LATB ^ 0x0800); //D -> RB11
                break;
                
            case 'E': LATB = (LATB ^ 0x1000); //E -> RB12
                break;
                
            case 'F': LATB = (LATB ^ 0x2000);//F-> RB13
                break;
                
            case 'G': LATB = (LATB ^ 0x4000);//g -> RB14
                break;

            default: 
                break;
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
