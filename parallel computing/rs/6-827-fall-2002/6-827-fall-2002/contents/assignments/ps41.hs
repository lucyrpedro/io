{- 6.827 Problem Set 4, Problem 1.

Replace these lines
with the names of your
team members

Please do not remove this initial comment or alter the first or last line. -}

module Main(main) where

-- Expressions

data Exp = IntConst Int 
         | BoolConst Bool
         | Var Ident
         | App Exp Exp
         | Lam Ident Exp
         | Cond Exp Exp Exp
         | Prim PrimId [Exp]
         | Let [(Ident, Exp)] Exp
	 deriving (Eq,Text)
data Ident = Varid Int deriving (Eq,Text)
data PrimId = Add | Sub | Mul | Div | Eq | Less | Greater 
              deriving (Eq,Text)


run :: Exp -> Exp
run = error "Please define your run function"

{- In this problem you're gradually going to refine a single
interpreter function.  The most important thing is that as you go the
older examples should continue to work. -}

pureExample = App (App (Lam a (Lam b (App (Var b) (Var a))))
		       (App (Lam x (Lam y (App (Var x) (App (Var x) (Var y)))))
			    (Lam u (Lam v (Var v)))))
		  (Lam z (Var z))
  where (a,b,u,v,x,y,z) = (Varid 0,Varid 1,Varid 2,Varid 3,Varid 4,Varid 5,Varid 6)


constExample = App (App (App (Lam a (Cond (Prim Eq [Prim Mul [Var a, three], nine])
				          (Lam b (Lam c (Var b)))
				          (Lam b (Lam c (Var c)))))
			     fourteen)
		        f)
                   t
  where (a,b,c) = (Varid 0, Varid 1, Varid 2)
	(t,f) = (BoolConst True, BoolConst False)
	(three, nine, fourteen) = (IntConst 3, IntConst 9, IntConst 14)

letExample = Let [(odd,  Lam x (Cond (Prim Eq [Var x, one])
				     (Var oddresult)
				     (App (Var even) (Prim Sub [Var x, one])))),
		  (even, Lam x (Cond (Prim Eq [Var x, zero])
				     (Var evenresult)
				     (App (Var odd) (Prim Sub [Var x, one])))),
		  (oddresult, Prim Add [IntConst 17, Prim Mul [IntConst 13, Var evenresult]]),
		  (evenresult, IntConst 43)]
		 (App (Var odd) (IntConst 327))
  where (odd, even, oddresult, evenresult, x) = (Varid 0,Varid 1,Varid 2,Varid 3,Varid 4)
	(zero, one) = (IntConst 0, IntConst 1)


main = print (run pureExample) >>
       print (run constExample) >>
       print (run letExample)
