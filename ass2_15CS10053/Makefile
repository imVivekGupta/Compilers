a.out: main.o libass2_15CS10053.a
	gcc main.o -L. -lass2_15CS10053
main.o: main.c myl.h
	gcc -Wall -c main.c
libass2_15CS10053.a: ass2_15CS10053.o
	ar -rcs libass2_15CS10053.a ass2_15CS10053.o
ass2_15CS10053.o: ass2_15CS10053.c myl.h
	gcc -Wall -c ass2_15CS10053.c
clean:
	rm a.out main.o libass2_15CS10053.a ass2_15CS10053.o
