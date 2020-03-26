#include <detpic32.h>
#include <stdbool.h>

void delay(unsigned int);

int main(void)
{   
    /* Configuração do port RE0 - LED */ 
    TRISE = (TRISE & 0xFFFE); //(TRISE and 1111 1111 1111 1110 )
    LATE = (LATE & 0xFFFE); //(LATB and 1111 1111 1111 1110 )

    /* Configuração dos Displays HEX - Segmento a-g -  e  Configuração dos Switches */
    TRISB = (TRISB & 0x00FC) | 0x0003; // (TRISB and 0000 0000 1111 1100 ) or 0000 0000 0000 0011
    LATB = (LATB & 0x00FF); //(LATB and 0000 0000 1111 1111 )

    /* Configuração dos Displays HEX - controlo */
    TRISD = (TRISD & 0xFF9F);
    LATD = (LATD & 0xFF9F)|0x0020; //(LATD and 1111 1111 1001 1111 ) or 0000 0000 0010 0000

    int displayMode0,displayMode1;
    int counter = 0;
    bool alt = true;
    bool dispAlt = true;
    int h,m,s;
    int d,u;
    unsigned int display7Scodes[] = { 0x3F00, 0x0600, 0x5B00, 0x4F00, 0x6600, 0x6D00, 0x7D00, 0x0700, 0x7F00, 0x6700};

    while(1){
        displayMode0 = PORTBbits.RB0;
        displayMode1 = PORTBbits.RB1;
        dispAlt = !dispAlt;

        h = (counter/100)/3600;
        m = ((counter/100)%3600)/60;
        s=  (((counter/100)%3600)%60);

        if(counter%50 == 0){
            LATE = (LATE ^ 0x0001);
            alt = !alt;

            printStr("\r");
            printInt(h, 10 | 2 << 16);
            printStr(":");
            printInt(m, 10 | 2 << 16);
            printStr(":");
            printInt(s, 10 | 2 << 16);
        }

        switch ((displayMode0 + displayMode1*2))
        {
            case 0://SS
                d = s/10;
                u = s%10;
                if(dispAlt){
                    LATB = (LATB & 0x00FF) | display7Scodes[u];
                    LATD = (LATD ^ 0x0060);
                }
                else{
                    LATB = (LATB & 0x00FF) | display7Scodes[d];
                    LATD = (LATD ^ 0x0060);
                }
                break;

            case 1://MM
                d = m/10;
                u = m%10;
                if(dispAlt){
                    LATB = (LATB & 0x00FF) | display7Scodes[u];
                    LATD = (LATD ^ 0x0060);
                }
                else{
                    LATB = (LATB & 0x00FF) | display7Scodes[d];
                    LATD = (LATD ^ 0x0060);
                }
                break;

            case 2://HH
                d = h/10;
                u = h%10;
                if(dispAlt){
                    LATB = (LATB & 0x00FF) | display7Scodes[u];
                    LATD = (LATD ^ 0x0060);
                }
                else{
                    LATB = (LATB & 0x00FF) | display7Scodes[d];
                    LATD = (LATD ^ 0x0060);
                }
                break;

            case 3://HH e MM
                if(alt){
                    d = m/10;
                    u = m%10;
                }
                else{
                    d = h/10;
                    u = h%10;
                }

                if(dispAlt){
                    LATB = (LATB & 0x00FF) | display7Scodes[u];
                    LATD = (LATD ^ 0x0060);
                }
                else{
                    LATB = (LATB & 0x00FF) | display7Scodes[d];
                    LATD = (LATD ^ 0x0060);
                }
                break;
            default:
                break;
        }

        counter = counter + 1;
        delay(10);
    }
}

void delay (unsigned int ms){
    resetCoreTimer();
    while( readCoreTimer() < ms*20000 );
}
