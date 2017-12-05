#include "lex.yy.c"

int main(int argc ,char *argv[]){
  //yydebug=1;
  int token;
  while(token=yylex()){
        switch(token){
                case ID         :       printf("<IDENTIFIER>\n");break;                
                case CONST      :       printf("<CONSTANT>\n"); break;
                case STRING     :       printf("<STRING_LITERAL>\n");break;
          
                case VOID       :       
                case CHAR       :
                case SHORT      :
                case INT        :
                case LONG       :
                case FLOAT      :
                case DOUBLE     :
                case MATRIX     :
                case SIGNED     :
                case UNSIGNED   :
                case BOOL       :
                case BREAK      :
                case CASE       :
                case DEFAULT    :
                case IF         :
                case ELSE       :
                case SWITCH     :
                case WHILE      :
                case DO         :
                case FOR        :
                case GOTO       :
                case CONTINUE   :
                case RETURN     :       printf("<KEYWORD>\n");break;
                
                case LP         :
                case RP         :        
                case LSQ        :
                case RSQ        :
                case LB         :
                case RB         :
                case SEMICOLON  :
                case COMMA      :
                case COLON      :
                case QUESTION   :
                case OR         :
                case AND        :
                case E          :
                case NE         :
                case L          :
                case LE         :
                case G          :
                case GE         :
                case EQ         :
                case SL         :
                case SR         :
                case INC        :        
                case DEC        :        
                case PLUS       :
                case MINUS      :
                case MUL        :
                case DIV        :
                case MOD        :
                case MULA       :
                case DIVA       :
                case PLUSA      :
                case MINUSA     :
                case SLA        :
                case SRA        :
                case ANDA       :
                case EXPA       :
                case ORA        :
                case MODA       :
                case DOT        :
                case DEREF      :
                case BITAND     :
                case BITOR      :
                case NOT        :
                case EXP        :
                case TILDE      :
                case HASH       :
                case APOST      :       printf("<PUNCTUATOR>\n");break;
                        
                case ERR        :       printf("Failed to read token\n");
        
        }
  }
  return 0;
}
