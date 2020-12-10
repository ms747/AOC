require 'set'

def count(question)
  set = Hash.new()
  question.split('').each { |c| set[c] = true }
  return set.length
end

def part1(file)
  input = File.read(file).split(/\n\n/).reduce(0) { |sum,line|
    line = line.gsub(/\n/,'')
    line = count(line)
    sum += line
    sum
  }
  puts "Part 1 : #{input}"
end

def part2(file)
  input = File.read(file).split(/\n\n/)
  input = input.map{ |line| line.split(/\n/).map{ |array| Set.new(array.split('')) } }
  input = input.map{ |setarray| setarray.reduce(setarray[0]) { |acc,i| acc = acc & i } }
    .reduce(0){ |sum,i| sum += i.length }
  puts "Part 2 : #{input}"
end

def main
  args = ARGV
  if args.length() != 1
    puts "input.txt not provided"
    exit -1
  end
  file = args[0]
  part1(file)
  part2(file)
end

main
