module Inline where

import qualified Data.Map as M

import Kinds
import Types
import AST
import Env
import Reductible

-- | Inlines kind aliases.
inlineKinds :: M.Map String Kind -> Kind -> Either String Kind 
inlineKinds env KStar          = return KStar 
inlineKinds env (KVar n)       = return $ KVar n
inlineKinds env (KArrow kf ka) = do
    kf' <- inlineKinds env kf
    ka' <- inlineKinds env ka
    return $ KArrow kf' ka'
inlineKinds env (KName n) = case M.lookup n env of
    Nothing  -> fail $ "Kind `" ++ n ++ "' is not defined"
    (Just d) -> inlineKinds env d
inlineKinds env (KForAll n k) = do
    k' <- inlineKinds env k
    return $ KForAll n k'

inlineKindsHNF :: M.Map String Kind -> Kind -> Either String Kind 
inlineKindsHNF env (KName n) = case M.lookup n env of
    Nothing  -> fail $ "Kind `" ++ n ++ "' is not defined"
    (Just d) -> inlineKindsHNF env d
inlineKindsHNF env k = return k

compareKinds :: M.Map String Kind -> Kind -> Kind -> Either String Bool
compareKinds env k1 k2 = do
    k1' <- inlineKinds env k1
    k2' <- inlineKinds env k2
    return $ k1' == k2'

-- | Inlines type aliases.
inlineTypes :: GlEnv -> Type -> Either String Type 
inlineTypes env (ConTy n) = case M.lookup n (typeEnv env) of
    Nothing  -> fail $ "Type `" ++ n ++ "' is not defined"
    (Just d) -> inlineTypes env (glDef d)
inlineTypes env (VarTy n) = return $ VarTy n 
inlineTypes env (FunTy tf ta) = do
    tf' <- inlineTypes env tf
    ta' <- inlineTypes env ta 
    return $ FunTy tf' ta'
inlineTypes env (AppTy tf ta) = do
    tf' <- inlineTypes env tf
    ta' <- inlineTypes env ta 
    return $ AppTy tf' ta'
inlineTypes env (ForAllTy n k t) = do 
    k' <- inlineKinds (kindEnv env) k 
    t' <- inlineTypes env t
    return $ ForAllTy n k' t'
inlineTypes env (KindAbsTy n t) = do
    t' <- inlineTypes env t
    return $ KindAbsTy n t'
inlineTypes env (KindAppTy t k) = do
    t' <- inlineTypes env t
    k' <- inlineKinds (kindEnv env) k
    return $ KindAppTy t' k'

inlineTypesHNF :: GlEnv -> Type -> Either String Type
inlineTypesHNF env (ConTy n) = case M.lookup n (typeEnv env) of
    Nothing  -> fail $ "Type `" ++ n ++ "' is not defined"
    (Just d) -> inlineTypesHNF env (glDef d)
inlineTypesHNF env t = return t

--inlineTypesFun :: GlEnv -> Type -> Either String Type 
--inlineTypesFun env ()

compareTypes :: GlEnv -> Type -> Type -> Either String Bool
compareTypes env t1 t2 = do
    t1' <- inlineTypes env t1
    t2' <- inlineTypes env t2
    return $ nf t1' == nf t2'

inlineExprs :: GlEnv -> Expr -> Either String Expr 
inlineExprs env e = return e 
{-inlineExprs env (Abs v t e) = do
    t' <- inlineTypes env t 
    e' <- inlineExprs env e
    return $ Abs v t' e'
inlineExprs env (App f a) = do
    f' <- inlineExprs env f
    a' <- inlineExprs env a
    return $ App f' a'
inlineExprs env (TyAbs v k e) = do
    k' <- inlineKinds (kindEnv env) k
    e' <- inlineExprs env e
    return $ TyAbs v k' e'
inlineExprs env (TyApp e t) = do
    e' <- inlineExprs env e
    t' <- inlineTypes env t
    return $ TyApp e' t'
inlineExprs env e = return e-}

