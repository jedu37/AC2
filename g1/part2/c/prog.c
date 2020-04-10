int main(void)
{
    int value;
    while(1)
    {
        printStr("\nIntroduza um numero (sinal e módulo): ");
        value = readInt10();
        printStr("\nValor lido, em base 2: ");
        printInt(value, 2);
        printStr("\nValor lido, em base 16: ");
        printInt(value, 16);
        printStr("\nValor lido, em base 10 (unsigned): ");
        printInt(value, 10);
        printStr("\nValor lido, em base 10 (signed): ");
        printInt10(value);
    }
    return 0;
 } 
