#include "myl.h"

int main(){
        int ch,n;
        float f;
        while(1){
                printStr("\n1.read int\n");
                printStr("2.print int\n");
                printStr("3.read float\n");
                printStr("4.print float\n");
                printStr("0.Exit\n");
                printStr("Enter choice\n");
                if(readInt(&ch)==ERR){
                        printStr("Invalid choice, re-enter\n");
                        continue;
                }
                if(ch==0)break;
                switch(ch){
                        case 1:printStr("Enter int\n");
                               if(readInt(&n)==ERR)printStr("Invalid Integer\n");
                               else printStr("Integer read.\n");
                               break;
                        case 2:printInt(n);
                               break;
                        case 3:printStr("Enter float\n");
                               if(readFlt(&f)==ERR)printStr("Invalid Float\n");
                               else printStr("Float read.\n");
                               break;
                        case 4:printFlt(f);
                               break;                      
                
                }
        }
        return 0;
}
