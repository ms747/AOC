CFLAGS=-Wall -Wpedantic -Wextra
.PHONY: run
run: main.c sample.txt input.txt
	$(CC) $(CFLAGS) main.c -o main
	./main input.txt
