function valid_password_part1(policy)
    count = 0
    _,_,min,max,char,line = string.find(policy, "(%d+)-(%d+)%s*(%w+):%s(%w+)")

    for c in line:gmatch"." do
        if c == char then
            count = count + 1
        end
    end

    if (count >= tonumber(min) and count <= tonumber(max)) then
        return true
    else
        return false
    end
end

function valid_password_part2(policy)
    _,_,pos1,pos2,char,line = string.find(policy, "(%d+)-(%d+)%s*(%w+):%s(%w+)")

    count = 0

    if (line:sub(pos1, pos1) == char) then
        count = count + 1
    end

    if (line:sub(pos2, pos2) == char) then
        count = count + 1
    end

    if count == 1 then
        return true
    else
        return false
    end
end

valid_password_part1_count = 0
valid_password_part2_count = 0

if (arg[1] == nil) then
    print("input.txt not provided")
    os.exit(-1)
end

for line in io.lines(arg[1]) do
    if valid_password_part1(line) then
        valid_password_part1_count = valid_password_part1_count + 1
    end
    if valid_password_part2(line) then
        valid_password_part2_count = valid_password_part2_count + 1
    end
end

print("Part 1")
io.write(string.format("Valid Passwords : %d\n", valid_password_part1_count))

print("Part 2")
io.write(string.format("Valid Passwords : %d\n", valid_password_part2_count))
