import re
import sys

Bags = {}

class Bag:
    def __init__(self, name, count):
        self.name = name
        self.count = count

def parse(line):
    temp = []
    result = re.findall("(\d)?\s?(\w+\s\w+)(?=\sbag)", line)
    for index, item in enumerate(result):
        if index != 0:
            if item[1] != "no other":
                temp.append(Bag(item[1], int(item[0])))

    return result[0][1], temp

def add(bags, bag, others):
    bags[bag] = others

def contains(bags, searchbag, otherbag):
    if searchbag == otherbag:
        return True

    if searchbag in bags:
        for bag in bags[searchbag]:
            result = contains(bags, bag.name, otherbag)
            if result == True:
                return True

    return False

def findbag(bags, colour):
    result = filter(lambda col : col != colour, bags)
    result = map(lambda bag : contains(bags, bag, colour), result)
    result = filter(lambda cond : cond == True, result)
    return len(list(result))

def countbags(allbags, targetbag):
    count = 0

    for bag in allbags[targetbag]:
        if bag.name in allbags:
            result = countbags(allbags, bag.name)
            count += result * bag.count + bag.count
        else:
            count += bag.count

    return count


if len(sys.argv) != 2:
    print("input.txt not provided")
    sys.exit(-1)

fileArg = sys.argv[1]

inputfile = open(fileArg, "r")
lines = inputfile.readlines()

for line in lines:
    x,y = parse(line)
    Bags[x] = y

containing_bags = findbag(Bags, "shiny gold")
print("Part 1 :", containing_bags)

bagscount = countbags(Bags, "shiny gold")
print("Part 2 :", bagscount)

inputfile.close()
