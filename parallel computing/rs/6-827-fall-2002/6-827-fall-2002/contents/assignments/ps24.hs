{- 6.827 Problem Set 2, Problem 4

Replace these lines
with the names of your
team members

Please do not remove this initial comment or alter the first or last line. -}

module Main(main) where

type Poly = [(Int,Int)]

-- Part A
addPoly :: Poly -> Poly -> Poly


-- Part B
mulPoly :: Poly -> Poly -> Poly


-- Part C
evalPoly :: Poly -> Int -> Int


-- Test code and useful utilities
showPoly :: Poly -> String
showPoly [] = "0"
showPoly xs = foldr1 plusGlue (map showTerm xs) ""
  where plusGlue as bs r = as $ showString " + " $ bs r
	showTerm (c,n) r = shows c $ showExp n r
	showExp 0 r = r
	showExp 1 r = showString "x" r
	showExp n r = showString "x^" $ shows n r

x :: Poly
nx :: Poly
xPlus1 :: Poly
xLess1 :: Poly
xPlus2 :: Poly
nxLess1 :: Poly

x = [(1,1)]
nx = [(-1,1)]
xPlus1 = (1,0):x
xLess1 = (-1,0):x
xPlus2 = (2,0):x
nxLess1 = (-1,0):nx

main = 
  let 
    zero    = addPoly x nx
    one     = addPoly nx xPlus1
    p2xp3   = addPoly xPlus1 xPlus2
    x2p2xp1 = mulPoly xPlus1 xPlus1
    x2p1    = mulPoly xPlus1 xLess1
    nx2m2xm1= mulPoly xPlus1 nxLess1
    x3p3x2p3xp1 = mulPoly x2p2xp1 xPlus1
    zero'   = addPoly x2p2xp1 nx2m2xm1
    zero''  = mulPoly zero' x3p3x2p3xp1
    printPoly = putStrLn . showPoly
  in
    print zero >>
    printPoly one >>
    printPoly p2xp3 >>
    printPoly x2p2xp1 >>
    printPoly x2p1 >>
    printPoly nx2m2xm1 >>
    printPoly x3p3x2p3xp1 >>
    printPoly zero' >>
    printPoly zero''>>
    print (evalPoly zero 17) >>
    print (evalPoly p2xp3 (-1)) >>
    print (evalPoly x3p3x2p3xp1 (-1))
