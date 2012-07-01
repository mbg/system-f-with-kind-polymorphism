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
>             | App Expr Expr 
>             deriving Eq

>   instance Show Expr where
>       show (Val c)     = show c
>       show (Var n)     = n
>       show (Abs n t e) = "(\\" ++ n ++ " : " ++ show t ++ "." ++ show e ++ ")"
>       show (App f a)   = "(" ++ show f ++ " " ++ show a ++ ")"

    {----------------------------------------------------------------------}
    {-- Free Variables                                                    -}
    {----------------------------------------------------------------------}

    Finds the free variables of an expression.

>   fvs :: Expr -> [Variable]
>   fvs (Val _)     = []
>   fvs (Var n)     = [n]
>   fvs (Abs n _ e) = filter (/= n) (fvs e)
>   fvs (App f a)   = fvs f `union` fvs a

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
>   cas (App f a)    v e                  = App (cas f v e) (cas a v e)
>   cas e            _ _                  = e

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  