#include <detpic32.h>

void delay(int ms);

int main(void){
    int cnt1 = 0;
    int cnt5 = 0;
    int cnt10 = 0;
    int s = 0;
    int flag = 0;

    while(1)
    {
        if(s == 0){
            delay(100);
        }
        else if(s == 1){
            delay(50);
        }

        putChar('\r');
        printInt(cnt1,0x00050002);
        putChar(' ');
        printInt(cnt5,0x00050002);
        putChar(' ');
        printInt(cnt10,0x00050002);

        if(flag == 0){
            cnt10++;

            if(cnt10%2==0){
                cnt5++;
            }

            if(cnt10%10==0){
                cnt1++;
            }
        }

        char c = inkey();

        if(c == 'a'){
            s = 1;
        }

        if(c == 'n'){
            s = 0;
        }

        if(c == 's'){
            flag = 1;
        }

        if(c == 'r'){
            flag = 0;
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