{--------------------------------------------------------------------------------------------------
                                Simply-kinded (polymorphic) \-calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

{-# LANGUAGE MultiParamTypeClasses, TypeFamilies #-}

module Kinds where

import qualified Data.Map as M
import qualified Data.Set as S

import FreeVars
import Subst

data Kind = KStar 
          | KVar String
          | KArrow Kind Kind
          | KForAll String Kind  
          | KName String 
          deriving Eq

instance Show Kind where
    show KStar         = "*"
    show (KVar n)      = n
    show (KArrow k k') = "(" ++ show k ++ " ~> " ++ show k' ++ ")"
    show (KForAll n k) = "(forall " ++ n ++ "." ++ show k ++ ")" 
    show (KName n)     = n

instance HasFVS Kind where
    type VarType Kind = String 

    fvs KStar          = S.empty
    fvs (KVar n)       = S.singleton n
    fvs (KArrow ak rk) = fvs ak `S.union` fvs rk
    fvs (KForAll n k)  = n `S.delete` fvs k
    fvs (KName n)      = S.empty

instance Substitutable Kind Kind where 
    type Of Kind = String

    subst KStar _ = KStar
    subst (KVar n) s 
        | n == what s = with s 
        | otherwise   = KVar n
    subst (KArrow at rt) s = KArrow (subst at s) (subst rt s)
    subst (KForAll n k) s
        | n == what s = KForAll n k 
        | n `S.member` fvs (with s) = subst (KForAll n' k') s
        | otherwise = KForAll n (subst k s)
            where
                n' = n ++ "'"
                k' = subst k (Sub n (KVar n'))
    subst (KName n) s = KName n

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  
