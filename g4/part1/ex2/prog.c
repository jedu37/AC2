#include <detpic32.h> 

int main(void){

    int counter = 0;
    TRISE = (TRISE & 0xFFF0);
    LATE = (LATE & 0xFFF0);


    while (1)
    {
        resetCoreTimer();
        while(readCoreTimer()<5000000);
        LATE = (LATE & 0xFFF0) | (counter % 16);
        counter = counter +1;
        
    }
}
