.PHONY: run
run: main sample.txt input.txt
	./main
main : main.go
	go build main.go

clean : main
	rm main
