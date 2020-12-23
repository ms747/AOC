INPUTS=input.txt

.PHONY: run
run: main $(INPUTS)
	./main $(INPUTS)

main: main.dart
	dart compile exe main.dart -o main
