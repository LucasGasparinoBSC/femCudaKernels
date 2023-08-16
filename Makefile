CC=nvcc
CCFLAGS=-ccbin=/home/lucas/Apps/compilers/gnu/gcc/12.3.0/bin -std=c++17 -res-usage
CXXDEBUG=-g -G -DDEBUG

all: femKern.o main.o
	$(CC) $(CCFLAGS) $(CXXDEBUG) -o test.x main.o femKern.o -lnvToolsExt

main.o: main.cu
	$(CC) $(CCFLAGS) $(CXXDEBUG) -c main.cu

femKern.o: femKern.cu
	$(CC) $(CCFLAGS) $(CXXDEBUG) -c femKern.cu

clean:
	rm -f *.o *.x