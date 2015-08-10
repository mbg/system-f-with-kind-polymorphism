
module KindCheck (
    mkKindEnv,
    kindcheck
) where

{----------------------------------------------------------------------}
{-- Module Imports                                                    -}
{----------------------------------------------------------------------}

import Text.Printf (printf)

import qualified Data.Map as M
import qualified Data.Set as S

import Kinds
import Types
import Env
import Inline
import Subst

{----------------------------------------------------------------------}
{-- Error Messages                                                    -}
{----------------------------------------------------------------------}

errFunTy :: String
errFunTy = "\n\tExpected type function of kind `%s ~> k',\n\tbut found type of kind `%s' instead.\n" 

errFunArg :: String 
errFunArg = "\n\tFound a type function expecting a type argument of kind `%s',\n\tbut it is applied to a type of kind `%s'.\n"

data KindEnv = MkKindEnv {
    globalEnv :: GlEnv,
    localEnv  :: M.Map String Kind,
    kindVars  :: S.Set String
}

-- | Constructs a kind environment from a global environment
mkKindEnv :: GlEnv -> KindEnv 
mkKindEnv glEnv = MkKindEnv glEnv M.empty S.empty

-- | Adds a kind variable 
addKindVar :: String -> KindEnv -> KindEnv 
addKindVar n (MkKindEnv gl lc kv) = MkKindEnv gl lc (S.insert n kv)  

-- | Adds a kinding (type : kind) to the local kind environment
addKinding :: String -> Kind -> KindEnv -> KindEnv 
addKinding n k (MkKindEnv gl lc kv) = MkKindEnv gl (M.insert n k lc) kv

argSatCheck :: KindEnv -> Kind -> Kind -> Either String Kind 
{-argSatCheck env fk ak = do
    fk' <- inlineKinds (kindEnv $ globalEnv env) fk
    ak' <- inlineKinds (kindEnv $ globalEnv env) ak 
    case fk' of
        (KArrow pk rk) 
    return ak-}
argSatCheck env (KArrow pk rk) ak = do
    r <- compareKinds (kindEnv $ globalEnv env) pk ak
    if r 
    then return rk
    else fail $ printf errFunArg (show pk) (show ak)
argSatCheck env fk             ak             = fail $ printf errFunTy (show ak) (show fk)

findKinding :: KindEnv -> String -> Either String Kind 
findKinding env n = case M.lookup n (localEnv env) of
    (Just k) -> return k
    Nothing  -> case M.lookup n (kindEnv $ globalEnv env) of
        Nothing  -> fail $ "Type variable `" ++ n ++ "' not found"
        (Just k) -> return k

findTypeKind :: KindEnv -> String -> Either String Kind
findTypeKind env n = case M.lookup n (typeEnv $ globalEnv env) of
    Nothing  -> fail $ "Type `" ++ n ++ "' not found"
    (Just k) -> return $ glAnn k

kindApp :: Kind -> Kind -> Either String Kind 
kindApp qk k = case qk of 
    (KForAll n kb) -> do
        Right (subst kb (Sub n k))
    _              -> Left "boo" -- $ printf errTyApp (show tf) (show ta)

kindcheck :: KindEnv -> Type -> Either String Kind
kindcheck env (VarTy n) = findKinding env n
kindcheck env (ConTy n) = findTypeKind env n
kindcheck env (AppTy tf ta) = do
    fk <- kindcheck env tf
    ak <- kindcheck env ta
    argSatCheck env fk ak 
kindcheck env (ForAllTy n k t) = do
    rk <- kindcheck (addKinding n k env) t
    return $ KArrow k rk
kindcheck env (FunTy tf ta) = do
    fk <- kindcheck env tf
    ak <- kindcheck env ta 
    return KStar 
kindcheck env (KindAbsTy kv t) = do
    tk <- kindcheck (addKindVar kv env) t 
    return $ KForAll kv tk
kindcheck env (KindAppTy t k) = do
    tk  <- kindcheck env t 
    -- we want to inline as little as possible
    tk' <- inlineKindsHNF (kindEnv $ globalEnv env) tk 
    --k'  <- inlineKinds (kindEnv $ globalEnv env) k
    kindApp tk' k
