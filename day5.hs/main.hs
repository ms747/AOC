import System.IO
import System.Environment
import System.Exit

pivot :: Integer -> Integer -> Integer
pivot low high = (low + high) `div` 2

lower :: Integer -> Integer -> (Integer, Integer)
lower low high = (low, mid) where mid = pivot low high

higher :: Integer -> Integer -> (Integer, Integer)
higher low high = (mid + 1, high) where mid = pivot low high

partition :: Integer -> Integer -> Char -> (Integer, Integer)
partition low high char
  | char == 'F' || char == 'L' = lower low high
  | char == 'B' || char == 'R' = higher low high

calcid :: Integer -> Integer -> String -> Integer
calcid low high (x:xs) = calcid lowc highc xs where (lowc, highc) = partition low high x
calcid low high [] = low

seat :: String -> Integer
seat zones = (row * 8) + col
    where
        row = calcid 0 127 $ take 7 zones
        col = calcid 0 7 $ drop 7 zones

calculate :: String -> IO ()
calculate file = do
    file <- openFile file ReadMode
    fileContents <- hGetContents file
    let seats = map seat . lines $ fileContents
    let min = minimum seats
    let max = maximum seats
    let seat_id = head $ filter (`notElem` seats) [min..max]
    putStrLn $ "Part 1 : " ++ show max
    putStrLn $ "Part 2 : " ++ show seat_id

main :: IO ()
main = do
    args <- getArgs
    if length args /= 1
       then exitFailure
       else calculate (head args)
