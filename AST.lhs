{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

> module AST (
>   Program,
>   Variable,
>   Definition(..),
>   Expr(..),
>   fvs,
>   cas
> ) where
  
    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
  
>   import Data.List (union)
>   import Types

    {----------------------------------------------------------------------}
    {-- Abstract Syntax Tree                                              -}
    {----------------------------------------------------------------------}

>   type Program = [Definition]
>   type Variable = String
    
>   data Definition = Def String Expr 
>                   deriving Show
    
>   data Expr = Val Int
>             | Var Variable
>             | Abs Variable Type Expr
>             | Succ Expr
>             | Pred Expr
>             | IsZero Expr
>             | Fix Expr 
>             | App Expr Expr 
>             | Cond Expr Expr Expr
>             deriving Eq

>   instance Show Expr where
>       show (Val c)      = show c
>       show (Var n)      = n
>       show (Abs n t e)  = "(\\" ++ n ++ " : " ++ show t ++ "." ++ show e ++ ")"
>       show (Succ e)     = "succ " ++ show e
>       show (Pred e)     = "pred " ++ show e
>       show (IsZero e)   = "iszero " ++ show e
>       show (Fix e)      = "fix " ++ show e
>       show (App f a)    = "(" ++ show f ++ " " ++ show a ++ ")"
>       show (Cond c t f) = "if " ++ show c ++ " then " ++ show t ++ " else " ++ show f

    {----------------------------------------------------------------------}
    {-- Free Variables                                                    -}
    {----------------------------------------------------------------------}

    Finds the free variables of an expression.

>   fvs :: Expr -> [Variable]
>   fvs (Val _)      = []
>   fvs (Var n)      = [n]
>   fvs (Abs n _ e)  = filter (/= n) (fvs e)
>   fvs (Succ e)     = fvs e
>   fvs (Pred e)     = fvs e
>   fvs (IsZero e)   = fvs e
>   fvs (Fix e)      = fvs e
>   fvs (App f a)    = fvs f `union` fvs a
>   fvs (Cond c t f) = fvs c `union` fvs t `union` fvs f

    {----------------------------------------------------------------------}
    {-- Capture-avoiding Substitution                                     -}
    {----------------------------------------------------------------------}
    
>   fresh :: String -> [Variable] -> String
>   fresh n fs | n `elem` fs = fresh (n ++ "'") fs
>              | otherwise   = n 

    Performs capture-avoiding substitution. We want to replace a variable v
    with an expression e. Most cases are trivial, except for abstractions:
    
    1. If an abstraction introduces a variable with the same name we are
       trying to replace, then we don't change the abstraction.
    2. If the variable introduced by the abstraction has a different name
       and it is a free variable in expression e, then we rename the
       variable to 
    3. Otherwise, we replace occurrences of v in e' with e.

>   cas :: Expr -> Variable -> Expr -> Expr
>   cas (Var n)      v e | n == v         = e
>   cas (Abs n t e') v e | n == v         = Abs n t e'
>                        | n `elem` fvs e = let n' = fresh (n ++ "'") (fvs e) in Abs n' t (cas (cas e' n (Var n')) v e)
>                        | otherwise      = Abs n t (cas e' v e)
>   cas (Succ e')    v e                  = Succ (cas e' v e)
>   cas (Pred e')    v e                  = Pred (cas e' v e)
>   cas (IsZero e')  v e                  = IsZero (cas e' v e)
>   cas (Fix e')     v e                  = Fix (cas e' v e)
>   cas (App f a)    v e                  = App (cas f v e) (cas a v e)
>   cas (Cond c t f) v e                  = Cond (cas c v e) (cas t v e) (cas f v e)
>   cas e            _ _                  = e

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  