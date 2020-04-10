int main(void)
{
    char c;
    do
    {
        while( (c = inkey()) == 0 );
        if( c != '\n' )
        putChar( c );
    }while( c != '\n' );
    
    return 0;
 }