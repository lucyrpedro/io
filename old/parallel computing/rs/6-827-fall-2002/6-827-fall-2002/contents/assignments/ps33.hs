{- 6.827 Problem Set 3, Problem 3.

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
         | Func Ident Exp
         | Cond Exp Exp Exp
         | Prim PrimId [Exp]
         | Let [(Ident, Exp)] Exp
	 deriving (Eq,Text)
data Ident = Varid Int deriving (Eq,Text)
data PrimId = Add | Sub | Mul | Div | Eq | Less | Greater 
              deriving (Eq,Text)

-- Type Expressions

data Type = TVar TIdent | TConst BaseType | Arrow Type Type   deriving (Eq,Text)
data TIdent = TName Int  deriving (Eq,Text)
data BaseType = IntType | BoolType  deriving (Eq,Text)


-- Type Schemes

data TScheme = TScheme [TIdent] Type deriving (Eq,Text)

-- Type Environments

type TEnv = [(Ident,TScheme)] 

-- Substitutions

type Subst = [(TIdent,Type)]


-- Part A

extendEnv :: TEnv -> Ident -> TScheme -> TEnv
-- This function extends the environment with the 
-- (variable, type scheme) pair.

getEnv :: TEnv -> Ident -> TScheme
-- This function looks up the environment for the variable, generates
-- an error if it is not present.

emptyEnv :: TEnv
-- used below to kick off algorithm w.

-- Part B

freeVars :: Type -> [TIdent]
-- Returns free variables of a type.
    
freeVarsScheme :: TScheme -> [TIdent]
-- Returns free variables of a type scheme.
    
freeVarsEnv :: TEnv -> [TIdent]
-- Returns free variables of a type environment.
    
newTypeVar :: NameSupply -> TIdent
-- Generates a new type variable, not used anywhere before.  


-- Part C

applySubToT :: Type -> Subst -> Type
-- Apply a substitution to a type.
    
applySubToScheme :: TScheme -> Subst -> TScheme
-- Apply a substitution to a type scheme. Be careful to avoid
-- variable capture!
    
applySubToEnv :: TEnv -> Subst -> TEnv
-- Apply a substitution to a type environment.
    
combine :: Subst -> Subst -> Subst
-- Combine two substitutions. Note that (combine s2 s1) 
-- is the substitution which applies s1 first and then s2.


-- Part D

instantiate :: TScheme -> Type
-- This function instantiates the type scheme, i.e. it replaces
-- the generalized type variables by new type variables.
    
generalize :: TEnv -> Type -> TScheme
-- This function generalizes (or closes) a type to generate a type
-- scheme.


-- Part E

unify :: Type -> Type -> Maybe Subst
-- This function returns a substitution which unifies the argument
-- types. If the types are not unifiable, it should return "Nothing".


-- Part F

w :: TEnv -> Exp -> Maybe (Subst,Type)
-- This implements the inference algorithm.  It should return "Nothing"
-- if type inference fails.


test1 = Let [(k, Lam x (Lam y (Var x)))]
	    (App (App (Var k) one) (App (App (Var k) t) two))
  where (k,x,y) = (Varid 0,Varid 1,Varid 2)
	(one,two) = (IntConst 1, IntConst 2)
	(t,f) = (BoolConst True, BoolConst False)

test2 = Lam k (App (App (Var k) one) (App (App (Var k) t) two))
  where (k,x,y) = (Varid 0,Varid 1,Varid 2)
	(one,two) = (IntConst 1, IntConst 2)
	(t,f) = (BoolConst True, BoolConst False)

test3 = Lam k (Let [(k1, (Var k))]
		   (App (App (Var k1) one) (App (App (Var k1) t) two)))
  where (k,x,y,k1) = (Varid 0, Varid 1, Varid 2, Varid 3)
	(one,two) = (IntConst 1, IntConst 2)
	(t,f) = (BoolConst True, BoolConst False)

test4 = Lam x (Lam y (Prim Add (Var x) (Var y)))
  where (k,x,y) = (Varid 0,Varid 1,Varid 2)

letExample = Let [(odd,  Lam x (Cond (Prim Eq (Var x) one)
				     (Var oddresult)
				     (App (Var even) (Prim Sub (Var x) one)))),
		  (even, Lam x (Cond (Prim Eq (Var x) zero)
				     (Var evenresult)
				     (App (Var odd) (Prim Sub (Var x) one)))),
		  (oddresult, Prim Add (IntConst 17) (Prim Mul (IntConst 13) (Var evenresult))),
		  (evenresult, IntConst 43)]
		 (App (Var odd) (IntConst 327))
  where (odd, even, oddresult, evenresult, x) = (Varid 0,Varid 1,Varid 2,Varid 3,Varid 4,Varid 5)
	(zero, one) = (IntConst 0, IntConst 1)



main = 
  let Just (s1,t1) = w emptyEnv test1
      Nothing      = w emptyEnv test2
      Nothing      = w emptyEnv test3
      Just (s2,t2) = w emptyEnv test4
      Just (s3,t3) = w emptyEnv letExample
  in  print t1 >>
      print s1 >>
      print t2 >>
      print s2 >>
      print t3 >>
      print s3
