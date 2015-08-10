{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

{- In this module we define the type system of the simply-typed lambda-calculus. -}

{-# LANGUAGE MultiParamTypeClasses, TypeFamilies #-}

module Types (
    TyName,
    Type(..),
    natType,
    funType
) where

import qualified Data.Set as S

import FreeVars
import Subst
import Reductible
import Kinds

{----------------------------------------------------------------------}
{-- Type System                                                       -}
{----------------------------------------------------------------------}
    
{-    
    A type name is just a string of characters.
-}   
type TyName = String

natType :: Type
natType = ConTy "Nat"

funType :: Type
funType = FunTy natType natType

{-
    Types can either be concrete types such as "Nat" or they can be function
    types with a domain and codomain.
-}

data Type = ConTy TyName
          | VarTy String
          | FunTy Type Type
          | ForAllTy String Kind Type
          | AppTy Type Type
          | KindAbsTy String Type
          | KindAppTy Type Kind
          deriving Eq

{-
    We create an instance of the Show type-class for the Type data type so
    that we can show the types of expressions.
-}

instance Show Type where
    show (ConTy n)        = n
    show (VarTy n)        = n
    show (FunTy d c)      = "(" ++ show d ++ " -> " ++ show c ++ ")"
    show (ForAllTy n k t) = "(forall " ++ n ++ " : " ++ show k ++ "." ++ show t ++ ")"
    show (AppTy tf ta)    = "(" ++ show tf ++ " " ++ show ta ++ ")"
    show (KindAbsTy n t)  = "(with " ++ n ++ "." ++ show t ++ ")"
    show (KindAppTy t k)  = "(" ++ show t ++ " {" ++ show k ++ "})"

instance HasFVS Type where
    type VarType Type = String 

    fvs (ConTy n)        = S.empty
    fvs (VarTy n)        = S.singleton n
    fvs (FunTy at rt)    = fvs at `S.union` fvs rt
    fvs (AppTy at rt)    = fvs at `S.union` fvs rt
    fvs (ForAllTy n k t) = n `S.delete` fvs t
    fvs (KindAbsTy n t)  = fvs t
    fvs (KindAppTy t k)  = fvs t

instance Substitutable Type Type where 
    type Of Type = String

    subst (ConTy n) _ = ConTy n
    subst (VarTy n) s 
        | n == what s = with s 
        | otherwise   = VarTy n
    subst (FunTy at rt) s = FunTy (subst at s) (subst rt s)
    subst (AppTy at rt) s = AppTy (subst at s) (subst rt s)
    subst (ForAllTy n k t) s
        | n == what s = ForAllTy n k t 
        | n `S.member` fvs (with s) = subst (ForAllTy n' k t') s
        | otherwise = ForAllTy n k (subst t s)
            where
                n' = n ++ "'"
                t' = subst t (Sub n (VarTy n'))
    subst (KindAbsTy n t) s = KindAbsTy n (subst t s)
    subst (KindAppTy t k) s = KindAppTy (subst t s) k

instance Substitutable Type Kind where
    type Of Kind = String 

    subst (ConTy n) _ = ConTy n
    subst (VarTy n) _ = VarTy n
    subst (FunTy at rt) s = FunTy (subst at s) (subst rt s)
    subst (AppTy at rt) s = AppTy (subst at s) (subst rt s)
    subst (ForAllTy n k t) s = ForAllTy n (subst k s) (subst t s) 
    subst (KindAbsTy n t) s 
        | n == what s = KindAbsTy n t 
        | otherwise   = KindAbsTy n (subst t s) 
    subst (KindAppTy t k) s = KindAppTy (subst t s) (subst k s)

instance Reductible Type where
    reduce (AppTy (ForAllTy n k tb) ta) 
        | n `S.member` fvs ta = reduce t'
        | otherwise           = subst tb (Sub n ta)
            where
                n'  = n ++ "'"
                tb' = subst tb $ Sub n (VarTy n')
                t'  = AppTy (ForAllTy n' k tb') ta
    reduce (KindAppTy (KindAbsTy n t) k) = subst t (Sub n k)
    reduce t = t

    reduceAnywhere (AppTy (ForAllTy n k tb) ta) = reduce $ AppTy (ForAllTy n k (reduceAnywhere tb)) (reduceAnywhere ta)
    reduceAnywhere (FunTy at rt) = FunTy (reduceAnywhere at) (reduceAnywhere rt)
    reduceAnywhere (AppTy at rt) = AppTy (reduceAnywhere at) (reduceAnywhere rt)
    reduceAnywhere (ForAllTy n k t) = ForAllTy n k (reduceAnywhere t)
    reduceAnywhere (KindAppTy (KindAbsTy n t) k) = reduce $ KindAppTy (KindAbsTy n (reduceAnywhere t)) k
    reduceAnywhere (KindAppTy t k) = KindAppTy (reduceAnywhere t) k
    reduceAnywhere (KindAbsTy n t) = KindAbsTy n (reduceAnywhere t)
    reduceAnywhere t = t

--reduceType :: Type -> Type 
--reduceType (AppTy (ForAllTy n k tb) ta) = inst 
--reduceType t = t

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  