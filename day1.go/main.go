package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"reflect"
	"strconv"
	"strings"
)

func main() {
	file, err := os.Open("./sample.txt")

	if err != nil {
		panic("file not found")
	}

	defer file.Close()

	reader := bufio.NewReader(file)

	nmap := make(map[int]bool)

	for {
		line, err := reader.ReadString('\n')
		if err != nil && err != io.EOF {
			break
		}
		number, numerr := strconv.Atoi(strings.TrimSpace(line))

		if numerr == nil {
			nmap[number] = true
		}

		if err != nil {
			break
		}

	}

	// PART 1
	keys := reflect.ValueOf(nmap).MapKeys()
	for i := range keys {
		firstNumber := int(keys[i].Int())
		secondNum := 2020 - firstNumber
		if nmap[secondNum] == true {
			answer := firstNumber * secondNum
			fmt.Println("Part 1")
			fmt.Printf("%d + %d = 2020; %d * %d = %d\n",
				firstNumber, secondNum, firstNumber, secondNum, answer)
			break
		}
	}

	// PART 2
	found := false
	for i := range keys {
		if found {
			break
		}
		firstNumber := int(keys[i].Int())
		for j := range keys {
			secondNum := int(keys[j].Int())
			thirdNumber := 2020 - firstNumber - secondNum
			if nmap[thirdNumber] == true {
				answer := firstNumber * secondNum * thirdNumber
				fmt.Println("Part 2")
				fmt.Printf("%d + %d + %d = 2020; %d * %d * %d = %d\n",
					firstNumber, secondNum, thirdNumber,
					firstNumber, secondNum, thirdNumber,
					answer,
				)
				found = true
				break
			}
		}
	}

}
