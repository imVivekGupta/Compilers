a.out: y.tab.o lex.yy.o ass5_15CS10053_translator.o ass5_15CS10053_target_translator.o
	g++ -g ass5_15CS10053_translator.o ass5_15CS10053_target_translator.o lex.yy.o y.tab.o -lfl
	#make run to generate the output
	#make clean to clear all the system generated files
lex.yy.c: ass5_15CS10053.l
	flex ass5_15CS10053.l
y.tab.c: ass5_15CS10053.y
	yacc -dtv ass5_15CS10053.y
ass5_15CS10053_target_translator.o: ass5_15CS10053_target_translator.cxx
	g++ -g -c ass5_15CS10053_target_translator.cxx
ass5_15CS10053_translator.o: ass5_15CS10053_translator.cxx
	g++ -g -c ass5_15CS10053_translator.cxx
lex.yy.o: lex.yy.c
	g++ -g -c lex.yy.c
y.tab.o:    y.tab.c
	g++ -g -DYYDEBUG -c y.tab.c

libass2_15CS10053.a: ass2_15CS10053.o
	ar -rcs libass2_15CS10053.a ass2_15CS10053.o

ass2_15CS10053.o: ass2_15CS10053.c myl.h
	gcc -Wall  -c ass2_15CS10053.c

clean:
	rm lex.yy.c y.tab.h y.output y.tab.c lex.yy.o y.tab.o ass5_15CS10053_translator.o a.out

test1: ass5_15CS10053_test1.o libass2_15CS10053.a
	gcc -g ass5_15CS10053_test1.o -o test1 -L. -lass2_15CS10053

ass5_15CS10053_test1.o: ass5_15CS10053_test1.s myl.h
	gcc -g -Wall  -c ass5_15CS10053_test1.s -o ass5_15CS10053_test1.o

test2: ass5_15CS10053_test2.o libass2_15CS10053.a
	gcc -g ass5_15CS10053_test2.o -o test2 -L. -lass2_15CS10053

ass5_15CS10053_test2.o: ass5_15CS10053_test2.s myl.h
	gcc -g -Wall  -c ass5_15CS10053_test2.s -o ass5_15CS10053_test2.o

test3: ass5_15CS10053_test3.o libass2_15CS10053.a
	gcc -g ass5_15CS10053_test3.o -o test3 -L. -lass2_15CS10053

ass5_15CS10053_test3.o: ass5_15CS10053_test3.s myl.h
	gcc -g -Wall  -c ass5_15CS10053_test3.s -o ass5_15CS10053_test3.o

test4: ass5_15CS10053_test4.o libass2_15CS10053.a
	gcc -g ass5_15CS10053_test4.o -o test4 -L. -lass2_15CS10053

ass5_15CS10053_test4.o: ass5_15CS10053_test4.s myl.h
	gcc -g -Wall  -c ass5_15CS10053_test4.s -o ass5_15CS10053_test4.o

test5: ass5_15CS10053_test5.o libass2_15CS10053.a
	gcc -g ass5_15CS10053_test5.o -o test5 -L. -lass2_15CS10053

ass5_15CS10053_test5.o: ass5_15CS10053_test5.s myl.h
	gcc -g -Wall  -c ass5_15CS10053_test5.s -o ass5_15CS10053_test5.o


run: 
	
	./a.out < ass5_15CS10053_test1.mm > ass5_15CS10053_quads1.out
	./a.out < ass5_15CS10053_test2.mm > ass5_15CS10053_quads2.out
	./a.out < ass5_15CS10053_test3.mm > ass5_15CS10053_quads3.out
	./a.out < ass5_15CS10053_test4.mm > ass5_15CS10053_quads4.out
	./a.out < ass5_15CS10053_test5.mm > ass5_15CS10053_quads5.out

	./a.out < ass5_15CS10053_test1.mm 
	mv output.s ass5_15CS10053_test1.s
	make test1

	./a.out < ass5_15CS10053_test2.mm 
	mv output.s ass5_15CS10053_test2.s
	make test2

	./a.out < ass5_15CS10053_test3.mm 
	mv output.s ass5_15CS10053_test3.s
	make test3

	./a.out < ass5_15CS10053_test4.mm 
	mv output.s ass5_15CS10053_test4.s
	make test4

	./a.out < ass5_15CS10053_test5.mm 
	make test5
	