.PHONY: run
run: main.jar
	java -jar main.jar input.txt

main.jar : main.kt
	kotlinc main.kt -include-runtime -d main.jar
