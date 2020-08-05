{- 6.827 Problem Set 2, Problem 5

Replace these lines
with the names of your
team members

Please do not remove this initial comment or alter the first or last line. -}

module Main(main) where

type Board = [Int]

queens :: Int -> [Board]

displayBoard :: Board -> String


-- Here's the main function and some utilities

printBoard = putStrLn . displayBoard

main = let queens8 = queens 8 
       in  print (length queens8) >>
	   print (sum (map sum queens8)) >>
	   printBoard [4,6,1,5,2,8,3,7] >>
	   printBoard [4,6,1,5,2,3]
