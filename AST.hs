{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

{-# LANGUAGE MultiParamTypeClasses, TypeFamilies #-}

module AST (
    module Subst,

    Program,
    Variable,
    Definition(..),
    Expr(..),
    fvs
) where
  
{----------------------------------------------------------------------}
{-- Module Imports                                                    -}
{----------------------------------------------------------------------}
  
import qualified Data.Set as S
import Data.List (union)

import FreeVars
import Subst
import Kinds
import Types

{----------------------------------------------------------------------}
{-- Abstract Syntax Tree                                              -}
{----------------------------------------------------------------------}

type Program = [Definition]
type Variable = String
    
data Definition = Def String (Maybe Type) Expr 
                | TypeDec String (Maybe Kind) Type
                | KindDec String Kind
                deriving Show
    
data Expr = Val Int
          | Var Variable
          | Abs Variable Type Expr
          | Succ Expr
          | Pred Expr
          | IsZero Expr
          | Fix Expr 
          | App Expr Expr 
          | Cond Expr Expr Expr
          | TyAbs Variable Kind Expr
          | TyApp Expr Type
          | KindAbs Variable Expr

          | TyHole 
          deriving Eq

instance Show Expr where
    show (Val c)       = show c
    show (Var n)       = n
    show (Abs n t e)   = "(\\" ++ n ++ " : " ++ show t ++ "." ++ show e ++ ")"
    show (Succ e)      = "succ " ++ show e
    show (Pred e)      = "pred " ++ show e
    show (IsZero e)    = "iszero " ++ show e
    show (Fix e)       = "fix " ++ show e
    show (App f a)     = "(" ++ show f ++ " " ++ show a ++ ")"
    show (Cond c t f)  = "if " ++ show c ++ " then " ++ show t ++ " else " ++ show f
    show (TyAbs n k e) = "(/\\" ++ n ++ " : " ++ show k ++ "." ++ show e ++ ")"
    show (TyApp e t)   = "(" ++ show e ++ " " ++ show t ++ ")"
    show (KindAbs k e) = "with " ++ k ++ "." ++ show e
    show (TyHole)      = "_"

{----------------------------------------------------------------------}
{-- Free Variables                                                    -}
{----------------------------------------------------------------------}

{-
    Finds the free variables of an expression.
-}

instance HasFVS Expr where 
    type VarType Expr = String 

    fvs (Val _)       = S.empty
    fvs (Var n)       = S.singleton n
    fvs (Abs n _ e)   = n `S.delete` fvs e
    fvs (Succ e)      = fvs e
    fvs (Pred e)      = fvs e
    fvs (IsZero e)    = fvs e
    fvs (Fix e)       = fvs e
    fvs (App f a)     = fvs f `S.union` fvs a
    fvs (Cond c t f)  = fvs c `S.union` fvs t `S.union` fvs f
    fvs (TyAbs n k e) = fvs e
    fvs (TyApp e t)   = fvs e
    fbs (KindAbs k e) = fvs e

{----------------------------------------------------------------------}
{-- Capture-avoiding Substitution                                     -}
{----------------------------------------------------------------------}
    
fresh :: String -> [Variable] -> String
fresh n fs | n `elem` fs = fresh (n ++ "'") fs
           | otherwise   = n 

{-
    Performs capture-avoiding substitution. We want to replace a variable v
    with an expression e. Most cases are trivial, except for abstractions:
    
    1. If an abstraction introduces a variable with the same name we are
       trying to replace, then we don't change the abstraction.
    2. If the variable introduced by the abstraction has a different name
       and it is a free variable in expression e, then we rename the
       variable to 
    3. Otherwise, we replace occurrences of v in e' with e.
-}

instance Substitutable Expr Expr where
    type Of Expr = String 

    subst (Var n) s 
        | n == what s = with s
    subst (Abs n t e) s 
        | n == what s           = Abs n t e 
        | n `elem` fvs (with s) = subst (Abs n' t e') s
        | otherwise             = Abs n t (subst e s)
            where
                    n' = n ++ "'"
                    e' = subst e (Sub n (Var n'))
    subst (App f a)     s = App (subst f s) (subst a s)
    subst (TyApp e t)   s = TyApp (subst e s) t 
    subst (TyAbs x k b) s = TyAbs x k (subst b s) 
    subst e             _ = e

instance Substitutable Expr Type where
    type Of Type = String 

    subst (Abs n t e) s   = Abs n (subst t s) (subst e s)
    subst (App f a)     s = App (subst f s) (subst a s)
    subst (TyApp e t)   s = TyApp (subst e s) (subst t s) 
    subst (TyAbs x k b) s 
        | x == what s = TyAbs x k b
        | otherwise   = TyAbs x k (subst b s)
    subst e             _ = e

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  