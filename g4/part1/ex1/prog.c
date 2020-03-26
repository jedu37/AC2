#include <detpic32.h> 

int main(void){
    TRISE = (TRISE & 0xFFFE);
    LATE = (LATE & 0xFFFE);


    while (1)
    {
        resetCoreTimer();
        while(readCoreTimer()<20000000);
        LATE = (LATE ^ 0x0001);

        
    }
    
}

