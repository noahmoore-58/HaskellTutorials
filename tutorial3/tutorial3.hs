-- Informatics 1 - Functional Programming
-- Tutorial 3
--
-- Week 5 - Due: 16/17 Oct.

import Data.Char
import Data.List
import Test.QuickCheck



-- 1. Map
-- a.
uppers :: String -> String
uppers str = map toUpper str

-- b.
doubles :: [Int] -> [Int]
doubles xs = map (* 2) xs

-- c.
penceToPounds :: (Num a, Fractional a) => [a] -> [a]
penceToPounds xs = map (/100) xs
-- penceToPounds :: [Int] -> [Float]
-- penceToPounds xs = map ((/100).(fromIntegral)) xs

-- d.
uppers' :: String -> String
uppers' str = [ toUpper s | s <- str ]

prop_uppers :: String -> Bool
prop_uppers str = (uppers str) == (uppers' str)



-- 2. Filter
-- a.
alphas :: String -> String
alphas str = filter isAlpha str

-- b.
rmChar ::  Char -> String -> String
rmChar ch str = filter (/= ch) str

-- c.
above :: Int -> [Int] -> [Int]
above lt xs = filter (>= lt) xs

-- d.
unequals :: [(Int,Int)] -> [(Int,Int)]
unequals xs = filter equals xs
  where equals (x,y) = x == y

-- e.
rmCharComp :: Char -> String -> String
rmCharComp ch str = [ s | s <- str, s /= ch ]

prop_rmChar :: Char -> String -> Bool
prop_rmChar ch str = (rmChar ch str) == (rmCharComp ch str)



-- 3. Comprehensions vs. map & filter
-- a.
upperChars :: String -> String
upperChars s = [toUpper c | c <- s, isAlpha c]

upperChars' :: String -> String
upperChars' s = map toUpper (filter isAlpha s)

prop_upperChars :: String -> Bool
prop_upperChars s = upperChars s == upperChars' s

-- b.
largeDoubles :: [Int] -> [Int]
largeDoubles xs = [2 * x | x <- xs, x > 3]

largeDoubles' :: [Int] -> [Int]
largeDoubles' xs = map (2 *) (filter (>3) xs)

prop_largeDoubles :: [Int] -> Bool
prop_largeDoubles xs = largeDoubles xs == largeDoubles' xs

-- c.
reverseEven :: [String] -> [String]
reverseEven strs = [reverse s | s <- strs, even (length s)]

reverseEven' :: [String] -> [String]
reverseEven' strs = map reverse (filter even' strs)
  where even' str = even (length str)

prop_reverseEven :: [String] -> Bool
prop_reverseEven strs = reverseEven strs == reverseEven' strs



-- 4. Foldr
-- a.
productRec :: [Int] -> Int
productRec []     = 1
productRec (x:xs) = x * productRec xs

productFold :: [Int] -> Int
productFold xs = foldr (*) 1 xs

prop_product :: [Int] -> Bool
prop_product xs = productRec xs == productFold xs

-- b.
andRec :: [Bool] -> Bool
andRec [] = True
andRec (x:xs) = x && andRec xs

andFold :: [Bool] -> Bool
andFold xs = foldr (&&) True xs

prop_and :: [Bool] -> Bool
prop_and xs = andRec xs == andFold xs

-- c.
concatRec :: [[a]] -> [a]
concatRec [] = []
concatRec (x:xs) = x ++ concatRec xs

concatFold :: [[a]] -> [a]
concatFold xs = foldr (++) [] xs

prop_concat :: [String] -> Bool
prop_concat strs = concatRec strs == concatFold strs

-- d.
rmCharsRec :: String -> String -> String
rmCharsRec xs [] = []
rmCharsRec xs (y:ys)
  | xs `has` y = rmCharsRec xs ys
  | otherwise  = y : rmCharsRec xs ys
  where
    has :: String -> Char -> Bool
    has [] ch = False
    has (s:str) ch
      | ch == s   = True || has str ch
      | otherwise = has str ch

-- rmCharsRec [] ys = ys
-- rmCharsRec (x:xs) ys = rmCharsRec xs (rmChar x ys)

rmCharsFold :: [Char] -> String -> String
rmCharsFold xs ys = foldr (rmChar) ys xs

prop_rmChars :: String -> String -> Bool
prop_rmChars chars str = rmCharsRec chars str == rmCharsFold chars str



type Matrix = [[Int]]


-- 5
-- a.
uniform :: [Int] -> Bool
uniform [] = True
uniform xs = all (== (head xs)) (tail xs)
-- all' (a -> Bool) -> [a] -> Bool
-- all' f list = foldr (&&) True (map f list)

-- b.
valid :: Matrix -> Bool
valid xs = uniform (map length xs) && all (>0) (map length xs)

-- 6.
-- a.
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' f xs ys = [ x `f` y | (x,y) <- zip xs ys ]

-- b.
zipWith'' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith'' f xs ys = map (uncurry f) (zip xs ys)


-- 7.
plusM :: Matrix -> Matrix -> Matrix
plusM [] _ = []
plusM _ [] = []
plusM m n
  | valid m && valid n && height m == height n && width m == width n = zipWith (zipWith (+)) m n
  | otherwise = error "Invalid matrices"
  where
    height xs = length xs
    width xs  = length (head xs)

-- 8.
timesM :: Matrix -> Matrix -> Matrix
timesM m n = undefined
  -- | valid m && valid n && width m == height n = [[dot m col | col <- (transpose n) ], [dot n row | row <- m]]
  -- | otherwise = error "Invalid matrices"
  -- where
  --   height xs = length xs
  --   width xs  = length (head xs)
  --   dot :: [Int] -> [Int] -> Int
  --   dot as bs = sum (foldr (*) as bs)

-- Optional material
-- 9.
