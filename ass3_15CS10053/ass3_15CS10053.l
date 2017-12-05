%{        
        #include "ass3_15CS10053.tab.c"       
%}

/*regular definitions*/
delim   [ \t\n\r]
ws      {delim}+ 
digit   [0-9]
letter  [_a-zA-Z]
id      {letter}({digit}|{letter})*
dig_seq {digit}+
exp     [eE][+-]?{dig_seq}
fr      ({dig_seq}?\.{dig_seq})|({dig_seq}\.)       
flt     ({dig_seq}{exp})|({fr}{exp}?) 
esc     (\\a|\\b|\\n|\\'|\\\"|\\\?|\\\\) 
char_const '({esc}|[^'\n\\])+'  
const   ({char_const}|{flt}|"0"|[1-9]+{digit}*)
string  \"({esc}|[^'\n\\])*\"

%%
{ws}            {}
"break"         {return BREAK;} 
"case"          {return CASE;} 
"default"       {return DEFAULT;}        
"if"            {return IF;}         
"else"          {return ELSE;} 
"switch"        {return SWITCH;}         
"while"         {return WHILE;} 
"do"            {return DO;} 
"for"           {return FOR;} 
"goto"          {return GOTO;} 
"continue"      {return CONTINUE;}          
"return"        {return RETURN;}        
"void"          {return VOID;} 
"char"          {return CHAR;} 
"short"         {return SHORT;} 
"int"           {return INT;} 
"float"         {return FLOAT;} 
"double"        {return DOUBLE;} 
"Matrix"        {return MATRIX;} 
"signed"        {return SIGNED;} 
"unsigned"      {return UNSIGNED;} 
"Bool"          {return BOOL;} 
".'"            {return APOST;}
"*="            {return MULA;}
"/="            {return DIVA;}
"+="            {return PLUSA;}
"-="            {return MINUSA;}
"<<="           {return SLA;}
">>="           {return SRA;}
"&="            {return ANDA;}
"^="            {return EXPA;}
"|="            {return ORA;}
"%="            {return MODA;}
"("             {return LP;}         
")"             {return RP;}
"["             {return LSQ;}
"]"             {return RSQ;}
"{"             {return LB;}
"}"             {return RB;}
";"             {return SEMICOLON;}
","             {return COMMA;}
":"             {return COLON;}
"?"             {return QUESTION;}
"=="            {return E;}
"!="            {return NE;}
"||"            {return OR;}
"&&"            {return AND;}
"<="            {return LE;}
">="            {return GE;}
"<<"            {return SL;}
">>"            {return SR;}
"++"            {return INC;}
"--"            {return DEC;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return MUL;}
"/"             {return DIV;}
"<"             {return L;}
">"             {return G;}
"="             {return EQ;}
"%"             {return MOD;}

"."             {return DOT;}
"->"            {return DEREF;}
"&"             {return BITAND;}
"|"             {return BITOR;}
"!"             {return NOT;}
"^"             {return EXP;}
"~"             {return TILDE;}
"#"             {return HASH;}

\/\/.*          {}
\/\*([^\*]|(\*)+[^\/])*\*\/ {}

{id}      {return ID;}          
{const}   {return CONST;}       
{string}  {return STRING;}      

.         {return ERR;}
%%

int yywrap()   { return 1;}
