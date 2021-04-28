#include <detpic32.h>

void delay(int ms);

int main(void){
    int c = 0;
    TRISE = (TRISE & 0xFFF0); //Colocação dos portos RE3,RE2,RE1,RE0 em modo de output

    while(1){
        int r = c % 16; //Calculo do valor do contador de em 16

        LATE = (LATE & 0xFFF0) | r; //Colocação do valor do contador nos portos RE3,RE2,RE1,RE0

        delay(250);
        c++; //Aumentar o contador
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
