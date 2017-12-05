#include "myl.h"
#define SYS_READ 0
#define STDIN_FILENO 0

//Function to print string to standard output
int printStr(char* str){

	int i=0;
	while(str[i++]!='\0');	
	i--;
	//write(1,str,i-1);
	
	//display the string to output
	__asm__ __volatile__ (
        "movl $1, %%eax\n\t"
        "movq $1, %%rdi\n\t"
        "syscall\n\t"
        :
        :"S"(str), "d"(i)
        ) ; // $4: write, $1: on stdin
        return i;     //returns number of characters printed
}

//Function to read an integer from standard input
int readInt(int *n){
        char buff[100];                
        int charsread;
        int i,num,flag=0;
        
        asm volatile("syscall" /* Make the syscall. */
      : "=a" (charsread) 
      : "0" (SYS_READ), "D" (STDIN_FILENO), "S" (buff), "d" (sizeof(buff))
      : "rcx", "r11", "memory", "cc");

    buff[--charsread] = 0x0;
    i=charsread-1;
    while(i>=0 && buff[i--]==' ');      //Removing trailing spaces 
    buff[i+2]=0x0;
    charsread = i+2;
    i=-1;
    while(buff[++i]==' ');              //Removing leading spaces
    if(buff[i]=='-'){i++;flag=1;}       //Check if positive or negative number and set flag accordingly
    if(buff[i]>='0' && buff[i]<='9'){num=buff[i]-'0';i++;}
    else return ERR;
    
    for(;i<charsread;i++){              //Converting buffer into an integer
        if(!(buff[i]>='0' && buff[i]<='9'))return ERR;
        num = num*10 + (buff[i]-'0');
    }  
      
    if(flag)num=-num;                   //If flag is one, negate the number computed
    *n=num;                             //store address of num in n
    return OK;                          

}

//Function to print integer to output
int printInt(int n){
        
        if(n==0)
        {printStr("0");
                return 1;}
        
	long y = 1;
	int i,m, s;
	char msg[32];
	if(n<0)                 //check if number is negative
		m=-n;
	else 
		m=n;
	
    for (s = 0; y < m; s++)     //Number of digits stored in s
        y *= 10;

    i=s;
    msg[s--] = 0x0;
    while(s>0)                  //remove digits from the right and store in correct order
    {
            msg[s--] = '0' + (m % 10);
            m /= 10;
    }
    msg[0] = '0' + m;           //first digit

    if(n<0){                    //if number was negative, add a minus sign and shift characters one place right
	for(s=i;s>=0;s--)
		msg[s+1]=msg[s];
	msg[0]='-';
	i++;
	}		
   
    printStr(msg);
    return i;                   //return number of characters printed
}

//Function to read float values from input
int readFlt(float *f){
        char buff[100];                
        int charsread;
        int i,inte=0,flag=0,f2=0;
        float fac=0.1,dec=0,ans;
        
        asm volatile("syscall" /* Make the syscall. */
      : "=a" (charsread) 
      : "0" (SYS_READ), "D" (STDIN_FILENO), "S" (buff), "d" (sizeof(buff))
      : "rcx", "r11", "memory", "cc");

        
    buff[--charsread] = 0x0;
    i=charsread-1;
    while(i>=0 && buff[i--]==' ');              //Removing trailing spaces 
    buff[i+2]=0x0;
    charsread = i+2;
    i=-1;
    while(buff[++i]==' ');                      //Removing leading spaces 
    if(buff[i]=='-'){i++;flag=1;}               //Check if positive or negative number and set flag accordingly
    if(buff[i]>='0' && buff[i]<='9'){inte=buff[i]-'0';i++;}
    else if(buff[i]=='.'){f2=1;i++;}            //check for decimal point
    else return ERR;
    
    for(;i<charsread;i++){                      
        if(buff[i]=='.'){               //check for decimal point
                if(f2==1)return ERR;    //reads 2 decimal points, returns error
                f2=1;
                continue;
        }
        else if(!(buff[i]>='0' && buff[i]<='9'))return ERR;     //if something other than digit is read, return error
        else if(f2){
                dec = dec + fac*(buff[i]-'0');                  //calculate fractional part
                fac = fac*0.1;
        }else{
                inte = inte*10+ (buff[i]-'0');                  //calculate integral part
        }
    }  
            
    ans = inte+dec;    
    if(flag)ans=-ans;                                           //negate if number was negative
    *f=ans;                                                     //store result
    return OK;
}

//Function to print float number to output
int printFlt(float f){
    int ipart = (int)f;
    int i=1,len=7;
    float fpart = f - (float)ipart;
    char fpartstr[20];
        
        
    if(ipart==0 && f<0)printStr("-");           //If negative number,then - is printed
    len += printInt(ipart);                     //len (initially 7 for decimal point and 6 decimal digits) stores number of characters printed which is the return value     
    
    if(fpart<0)fpart=-fpart;                    
    fpartstr[0]='.';    

    while(fpart>0  && i<=6){                    //compute fractional part as string
        fpart = fpart*10;
        ipart = (int)fpart;
        fpartstr[i++] = ipart + '0';
        fpart = fpart - ipart;
    }

    while(i<=6)                                 //string computed till 6 decimal points
        fpartstr[i++]='0';

    fpartstr[i]='\0';
    printStr(fpartstr); 
    return len; 
}

