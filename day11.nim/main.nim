import sequtils, os

proc occupiedSeats(row, col, maxRow, maxCol: int, array: seq[string]): int =
  for drow in -1..1:
    for dcol in -1..1:
      if drow != 0 or dcol != 0:
        var rowId = row + drow
        var colId = col + dcol
        if (rowId >= 0 and rowId < maxRow) and (colId >= 0 and colId < maxCol):
          if array[rowId][colId] == '#':
            result += 1

proc totalOccupiedSeats(maxRow, maxCol: int, array: seq[string]): int =
  for i in countup(0, maxRow - 1):
    for j in countup(0, maxCol - 1):
      if array[i][j] == '#':
        result += 1


proc part1(maxRow, maxCol: int, array: seq[string]) : (int, seq[string]) =
  var newSeats : seq[string] = @[]
  var changeCount = 0
  for i in countup(0, maxRow - 1):
    var inner : string = ""
    for j in countup(0, maxCol - 1):
      if array[i][j] == '.':
        inner.add('.')

      if array[i][j] == 'L':
        if occupiedSeats(i, j, maxRow, maxCol, array) == 0:
          inner.add('#')
          changeCount += 1
        else:
          inner.add('L')

      if array[i][j] == '#':
        if occupiedSeats(i, j, maxRow, maxCol, array) >= 4:
          inner.add('L')
          changeCount += 1
        else:
          inner.add('#')

    newSeats.add(inner)
  (changeCount, newSeats)

proc occupiedSeats2(row, col, maxRow, maxCol: int, array: seq[string]): int =
  for drow in -1..1:
    for dcol in -1..1:
      if drow != 0 or dcol != 0:
        var rowId = row + drow
        var colId = col + dcol
        while (0 <= rowId and rowId < maxRow) and (0 <= colId and colId < maxCol):
          case array[rowId][colId]
          of '#':
            result += 1
            break
          of 'L':
            break
          else:
            rowId += drow
            colId += dcol

proc part2(maxRow, maxCol: int, array: seq[string]) : (int, seq[string]) =
  var newSeats : seq[string] = @[]
  var changeCount = 0
  for i in countup(0, maxRow - 1):
    var inner : string = ""
    for j in countup(0, maxCol - 1):
      if array[i][j] == '.':
        inner.add('.')

      if array[i][j] == 'L':
        if occupiedSeats2(i, j, maxRow, maxCol, array) == 0:
          inner.add('#')
          changeCount += 1
        else:
          inner.add('L')

      if array[i][j] == '#':
        if occupiedSeats2(i, j, maxRow, maxCol, array) >= 5:
          inner.add('L')
          changeCount += 1
        else:
          inner.add('#')

    newSeats.add(inner)
  (changeCount, newSeats)


proc solvePart1(maxRow, maxCol: int, seats: seq[string]) =
  var newSeats = seats
  var count = -1
  while count != 0:
    (count, newSeats) = part1(maxRow, maxCol, newSeats)
  echo "Part 1 ", totalOccupiedSeats(maxRow, maxCol, newSeats)

proc solvePart2(maxRow, maxCol: int, seats: seq[string]) =
  var newSeats = seats
  var count = -1
  while count != 0:
    (count, newSeats) = part2(maxRow, maxCol, newSeats)
  echo "Part 2 ", totalOccupiedSeats(maxRow, maxCol, newSeats)


proc solve(file: string) =
  var seats : seq[string] = @[]
  for line in file.lines:
    seats.add(line)
  let maxRow = seats.len
  let maxCol = seats[0].len
  solvePart1(maxRow, maxCol, seats)
  solvePart2(maxRow, maxCol, seats)

proc main() =
  for i in 1..paramCount():
    solve(paramStr(i))

main()
