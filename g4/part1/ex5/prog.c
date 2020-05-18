#include <detpic32.h> 

void delay(unsigned int);

int main(void){

    unsigned char segment; 
    int i;
    TRISB = (TRISB & 0x00FF);
    LATB = (LATB & 0x00FF);
    
    TRISD = (TRISD & 0xFF9F);
    LATD = (LATD & 0xFF9F)|0x0040; //(LATD and 1111 1111 1001 1111 ) or 0000 0000 0100 0000



    while (1)
    {
        //LATD = (LATD ^ 0x0060);
        //LATB = (LATB & 0x00FF);
        //delay(500);
        //LATB = (LATB |0x01FF);
        //delay(500);
        //LATB = (LATB |0x02FF);
        //delay(500);
        //LATB = (LATB |0x04FF);
        //delay(500);
        //LATB = (LATB |0x08FF);
        //delay(500);
        //LATB = (LATB |0x10FF);
        //delay(500);
        //LATB = (LATB |0x20FF);
        //delay(500);
        //LATB = (LATB |0x40FF);
        //delay(500);
        segment = 0x0100;

        for(i=0; i < 7; i++)
        {
            LATB = (LATB & 0x00FF);
            LATB = (LATB |(segment | 0x00FF));
            delay(500);
            segment = segment << 1;
        }
    }
}

void delay (unsigned int ms){
    resetCoreTimer();
    while( readCoreTimer() < ms*20000 );
}