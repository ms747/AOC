INPUTS=sample.txt input.txt
.PHONY: run
run: main #(INPUTS)
	./main $(INPUTS)

main: main.nim
	nim c main.nim
