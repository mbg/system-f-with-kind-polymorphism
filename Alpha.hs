module Alpha where

import Control.Monad.State

import Subst
import Kinds
import Types
import Expr 

type Counter = State Int

-- | `fresh p' computes a fresh name for something, prefixed by `p'.
fresh :: Char -> Counter String 
fresh s = do
    n <- get
    put (n+1)
    return $ s : show n

-- | The class of types whose equivalence is up to renaming 
class Alpha a where 
    alphaEq :: a -> a -> Counter Bool

-- | This is a fairly inefficient implementation of alpha equivalence
--   since we traverse the abstract syntax tree many more times than
--   we need to. Instead of calling `subst', we should really just keep
--   track of the new mappings when traversing the tree. This implementation
--   is simpler, however, and will do for this toy interpreter.
instance Alpha Kind where 
    -- for the forall case, we generate a new name and replace both names
    -- with the same, new one 
    alphaEq (KForAll n1 k1) (KForAll n2 k2) = do
        n <- fresh 'k'
        let 
            s1 = Sub n1 (KVar n)
            s2 = Sub n2 (KVar n)
        alphaEq (subst k1 s1) (subst k2 s2)
    -- all other cases are straight-forward structural equivalence
    alphaEq (KArrow k1 k2) (KArrow k3 k4) = do
        r1 <- alphaEq k1 k3
        r2 <- alphaEq k2 k4
        return $ r1 && r2
    alphaEq (KName n1) (KName n2)         = return $ n1 == n2
    alphaEq (KVar v1) (KVar v2)           = return $ v1 == v2
    alphaEq KStar KStar                   = return True
    alphaEq _ _                           = return False

instance Eq Kind where 
    k1 == k2 = evalState (alphaEq k1 k2) 0

instance Alpha Type where 
    -- for the forall case, we generate a new name and replace both names
    -- with the same, new one 
    alphaEq (ForAllTy n1 k1 t1) (ForAllTy n2 k2 t2) 
        | k1 == k2 = do 
            n <- fresh 't'
            let
                s1 = Sub n1 (VarTy n)
                s2 = Sub n2 (VarTy n)
            alphaEq (subst t1 s1) (subst t2 s2)
    -- for kind abstraction, we generate a new name for the kinds and replace
    -- both names with the same, new one
    alphaEq (KindAbsTy n1 t1) (KindAbsTy n2 t2) = do
        n <- fresh 'k'
        let
            s1 = Sub n1 (KVar n)
            s2 = Sub n2 (KVar n)
        alphaEq (subst t1 s1) (subst t2 s2)
    -- all other cases are straight-forward structural equivalence
    alphaEq (KindAppTy t1 k1) (KindAppTy t2 k2)
        | k1 == k2 = alphaEq t1 t2
    alphaEq (AppTy t1 t2) (AppTy t3 t4) = do
        r1 <- alphaEq t1 t3
        r2 <- alphaEq t2 t4
        return $ r1 && r2
    alphaEq (FunTy t1 t2) (FunTy t3 t4) = do
        r1 <- alphaEq t1 t3
        r2 <- alphaEq t2 t4
        return $ r1 && r2
    alphaEq (ConTy n1) (ConTy n2) = return $ n1 == n2 
    alphaEq (VarTy v1) (VarTy v2) = return $ v1 == v2
    alphaEq _          _          = return False

instance Eq Type where
    t1 == t2 = evalState (alphaEq t1 t2) 0

instance Alpha Expr where 
    -- for the forall case, we generate a new name and replace both names
    -- with the same, new one 
    alphaEq (Abs n1 t1 e1) (Abs n2 t2 e2)
        | t1 == t2 = do
            n <- fresh 'x'
            let
                s1 = Sub n1 (Var n)
                s2 = Sub n2 (Var n)
            alphaEq (subst e1 s1) (subst e2 s2)
    alphaEq (TyAbs n1 k1 e1) (TyAbs n2 k2 e2)
        | k1 == k2 = do
            n <- fresh 't'
            let
                s1 = Sub n1 (VarTy n)
                s2 = Sub n2 (VarTy n)
            alphaEq (subst e1 s1) (subst e2 s2)
    alphaEq (KindAbs n1 e1) (KindAbs n2 e2) = do
        n <- fresh 'k'
        let
            s1 = Sub n1 (KVar n)
            s2 = Sub n2 (KVar n)
        alphaEq (subst e1 s1) (subst e2 s2)
    -- all other cases are straight-forward structural equivalence
    alphaEq (TyApp e1 t1) (TyApp e2 t2)
        | t1 == t2 = alphaEq e1 e2
    alphaEq (App e1 e2) (App e3 e4) = do
        r1 <- alphaEq e1 e3
        r2 <- alphaEq e2 e4
        return $ r1 && r2
    alphaEq (Var v1) (Var v2) = return $ v1 == v2
    alphaEq TyHole   TyHole   = return True 
    alphaEq _        _        = return False 

instance Eq Expr where
    e1 == e2 = evalState (alphaEq e1 e2) 0

    