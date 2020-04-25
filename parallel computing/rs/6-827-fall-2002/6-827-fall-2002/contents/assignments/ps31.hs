{- 6.827 Problem Set 3, Problem 1.

Replace these lines
with the names of your
team members

Please do not remove this initial comment or alter the first or last line. -}

module Main(main) where

import Array

data Bit   = L | R deriving (Text)
type HCode = [Bit]
type Table = Array Char HCode 
data Tree  = Leaf Char Int | Node Int Tree Tree deriving (Text)

strictWriteFile :: String -> String -> IO ()
strictWriteFile path contents =
  openFile path WriteMode >>= \ handle ->
  hPutStr handle contents >>
  hClose handle

encodeFile :: FilePath -> FilePath -> IO ()
encodeFile fin fout = 
    readFile fin >>= \s ->
    let (tree,code) = encode s
    in  strictWriteFile fout ((show tree) ++ code)

decodeFile :: FilePath -> FilePath -> IO ()
decodeFile fin fout =
    readFile fin >>= \s ->
    let [(tree,rest)] = reads s
    in  strictWriteFile fout (decode (tree,rest))

-- Part A

encodeData :: Table -> String -> HCode

decodeData :: Tree -> HCode -> String


-- Part B

countChars :: String -> Array Char Int

makeCodingTree :: Array Char Int -> Tree

makeCodeTable :: Tree -> Table


-- Part C

hCodeToString :: HCode -> String

stringToHCode :: String -> HCode


-- Part D

encode :: String -> (Tree,String)

decode :: (Tree,String) -> String



main = encodeFile "/mit/6.827/ps-data/ps4-sample1" "ps4-sample1.huff" >>
       encodeFile "/mit/6.827/ps-data/ps4-sample2" "ps4-sample2.huff" >>
       encodeFile "/mit/6.827/ps-data/ps4-sample3" "ps4-sample3.huff"
