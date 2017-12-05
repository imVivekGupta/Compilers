all: lexer parser

lexer : ass3_15CS10053_lexer.c lex.yy.c 
	gcc -o lexer ass3_15CS10053_lexer.c
                
parser : ass3_15CS10053_parser.c lex.yy.c ass3_15CS10053.tab.c
	gcc -o parser ass3_15CS10053_parser.c

lex.yy.c : ass3_15CS10053.l ass3_15CS10053.tab.c
	flex ass3_15CS10053.l

ass3_15CS10053.tab.c : ass3_15CS10053.y
	bison ass3_15CS10053.y
