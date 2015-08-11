{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

-- In this module we implement the type inference algorithm for the simply-typed lambda-calculus.

module TypeCheck (
    TyEnv,
    initialTyEnv,
    infer
) where

{----------------------------------------------------------------------}
{-- Module Imports                                                    -}
{----------------------------------------------------------------------}

import qualified Data.Map as M

import Text.Printf (printf)

import Subst
import Reductible
import Kinds
import Types
import Expr
import Env
import Inline
import KindCheck

{----------------------------------------------------------------------}
{-- Error Messages                                                    -}
{----------------------------------------------------------------------}

errFunTy :: String
errFunTy = "\n\tExpected function of type (%s -> t),\n\tbut found object of type %s instead.\n" 

errObjTy :: String
errObjTy = "\n\tExpected object of type %s,\n\tbut found object of type %s instead.\n"

errFixTy :: String
errFixTy = "\n\tExpected function of type (t -> t) as the argument of fix,\n\tbut found object of type %s instead.\n" 

errUndef :: String
errUndef = "\n\tUnable to infer the type of `%s' because it is not in scope.\n"
    
errTyApp :: String
errTyApp = "\n\tCannot apply object of type\n\n\t%s\n\nto\n\n\t%s\n\nbecause it is not a quantified type."

{----------------------------------------------------------------------}
{-- Type Inference                                                    -}
{----------------------------------------------------------------------}
    
--    A type environment associates variables with types.

data TyEnv = MkTyEnv {
    localEnv :: M.Map Variable Type,
    globalEnv :: GlEnv
} 

initialTyEnv :: GlEnv -> TyEnv
initialTyEnv env = MkTyEnv M.empty env 

addTyping :: Variable -> Type -> TyEnv -> TyEnv
addTyping n mt (MkTyEnv lc gl) = MkTyEnv (M.insert n mt lc) gl

addKinding :: Variable -> Kind -> TyEnv -> TyEnv 
addKinding n k (MkTyEnv lc gl) = MkTyEnv lc (gl { kindEnv = M.insert n k (kindEnv gl) })

-- | Tests if the domain of a function type matches the type of an argument.
unify :: GlEnv -> Type -> Type -> Either String Type
unify env ft at = case nf ft of
    (FunTy pt rt) -> do
        r <- compareTypes env pt at 
        if r 
        then Right rt 
        else Left $ printf errObjTy (show pt) (show at)
    ft'           -> Left $ printf errFunTy (show at) (show ft)

ensure :: Type -> Type -> Either String Type
ensure x y | x == y    = Right x
           | otherwise = Left $ printf errObjTy (show y) (show x)

tyApp :: Type -> Type -> Either String Type
tyApp tf ta = case nf tf of 
    (ForAllTy n k tb) -> Right (subst tb (Sub n ta))
    _                 -> Left $ printf errTyApp (show tf) (show ta)

typeLookup :: Variable -> TyEnv -> Either String Type
typeLookup x env = case M.lookup x (localEnv env) of
    (Just t) -> return t 
    Nothing  -> case M.lookup x (valEnv $ globalEnv env) of
        Nothing  -> fail $ printf errUndef x
        (Just t) -> return $ glAnn t

isHole :: Expr -> Bool
isHole TyHole = True
isHole _      = False

argHole :: Type -> Either String Type 
argHole (FunTy pt _) = fail $ "Type hole in argument position: expecting object of type:\n\t" ++ show pt
argHole _            = fail $ "Type hole in argument position: not applied to a value function!"

-- | Given an expression and a type environment, this function type checks
--   the given expression.
infer :: Expr -> TyEnv -> Either String Type
infer TyHole       _   = do 
    Left "Type hole in invalid position."
infer (Var x)      env = do 
    typeLookup x env
infer (Abs x t e)  env = case inlineTypes (globalEnv env) t of
    (Left err) -> fail err
    (Right t') -> case kindcheck (mkKindEnv (globalEnv env)) t' of 
        (Left err) -> fail err
        (Right k)  -> do
            t2 <- infer e (addTyping x ({-nf-} t') env)
            return (FunTy ({-nf-} t') t2)
infer (App f x) env 
    | isHole x  = do
        ft <- infer f env
        argHole ft
    | otherwise = do 
        ft <- infer f env
        xt <- infer x env
        ft' <- inlineTypesHNF (globalEnv env) ft
        xt' <- inlineTypes (globalEnv env) xt
        unify (globalEnv env) ft' xt'
infer (TyAbs x k e) env = do
    t <- infer e (addKinding x k env)
    return (ForAllTy x k t)
    {-case inlineKinds (kindEnv $ globalEnv env) k of
        (Left err) -> fail err
        (Right k') -> do  
            t <- infer e (addKinding x k' env)
            return (ForAllTy x k t)-}
infer (TyApp e t)  env  = do 
    t' <- infer e env
    --t2 <- inlineTypes (globalEnv env) t
    t3 <- inlineTypesHNF (globalEnv env) t'
    tyApp t3 t
infer (KindAbs k e) env = do 
    t <- infer e env 
    return (KindAbsTy k t)

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  
