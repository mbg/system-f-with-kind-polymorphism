{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

{-# LANGUAGE MultiParamTypeClasses, TypeFamilies #-}

module Expr (
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
    
data Expr = Var Variable
          | Abs Variable Type Expr
          | App Expr Expr 
          | TyAbs Variable Kind Expr
          | TyApp Expr Type
          | KindAbs Variable Expr
          | TyHole 

instance Show Expr where
    show (Var n)       = n
    show (Abs n t e)   = "(\\" ++ n ++ " : " ++ show t ++ "." ++ show e ++ ")"
    show (App f a)     = "(" ++ show f ++ " " ++ show a ++ ")"
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

    fvs (Var n)       = S.singleton n
    fvs (Abs n _ e)   = n `S.delete` fvs e
    fvs (App f a)     = fvs f `S.union` fvs a
    fvs (TyAbs n k e) = fvs e
    fvs (TyApp e t)   = fvs e
    fvs (KindAbs k e) = fvs e

{----------------------------------------------------------------------}
{-- Capture-avoiding Substitution                                     -}
{----------------------------------------------------------------------}
    
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
    subst (KindAbs k e) s = KindAbs k (subst e s)
    subst e             _ = e

instance Substitutable Expr Type where
    type Of Type = String 

    subst (Abs n t e) s   = Abs n (subst t s) (subst e s)
    subst (App f a)     s = App (subst f s) (subst a s)
    subst (TyApp e t)   s = TyApp (subst e s) (subst t s) 
    subst (TyAbs x k b) s 
        | x == what s = TyAbs x k b
        | otherwise   = TyAbs x k (subst b s)
    subst (KindAbs k e) s = KindAbs k (subst e s) 
    subst e             _ = e

instance Substitutable Expr Kind where
    type Of Kind = String 

    subst (Abs n t e) s   = Abs n (subst t s) (subst e s)
    subst (App f a)     s = App (subst f s) (subst a s)
    subst (TyApp e t)   s = TyApp (subst e s) (subst t s) 
    subst (TyAbs x k b) s = TyAbs x (subst k s) (subst b s)
    subst (KindAbs k e) s   
        | k == what s = KindAbs k e
        | otherwise   = KindAbs k (subst e s) 
    subst e             _ = e

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  