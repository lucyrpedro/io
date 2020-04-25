{- 6.827 Problem Set 2, Problem 6

Replace these lines
with the names of your
team members

Please do not remove this initial comment or alter the first or last line. -}

module Main(main) where

import Char
import List

-- part A

type Word = String

splitWord :: String -> (Word, String)

splitWords :: String -> [Word]

-- part B

type Line = [Word]

splitLine :: Int -> [Word] -> (Line,[Word])

splitLines :: Int -> [Word] -> [Line]

-- part C

fill :: Int -> String -> [Line]
joinLines :: [Line] -> String

-- part D

justify :: Int -> String -> [Line]
justifyLines :: [Line] -> String
-- You may need to change the type of one of the above functions,
-- in which case you should change the definition of justifier in main.


-- Here's the main function and some utilities
checkJustification :: Int -> String -> Bool
checkJustification n txt = all lineOK (init (lines txt))
  where lineOK ln = length ln == n && 
		    not (isSpace (head ln)) &&
		    not (isSpace (last ln)) 

passage :: String
passage =
 "In the chronicles of the ancient "++
 "        dynasty of the Sassanidae, "++
 "who reigned          for         about "++
 "               four hundred years, from Persia to the borders "++
 "of China, beyond the great river      Ganges itself, we read the praises "++
 "of       one of the kings of this race, who      was said to be the best "++
 "monarch of his time."

main = let filler n = joinLines . fill n
	   justifier n = justifyLines . justify n
	   fillPassage11 = filler 11 passage
	   fillPassage70 = filler 70 passage
	   justPassage11 = justifier 11 passage	-- can we cope with error?
	   justPassage70 = justifier 70 passage
       in  putStrLn fillPassage11 >>
	   putStrLn fillPassage70 >>
	   putStrLn (filler 70 justPassage11) >>
	   putStrLn (filler 70 justPassage70) >>
	   print (checkJustification 70 justPassage70)
