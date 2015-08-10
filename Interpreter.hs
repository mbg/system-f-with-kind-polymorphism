{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

module Interpreter (
    GlDef(..),
    GlEnv(..),
    emptyGlEnv,
    Env,
    eval,
    fix,
    fixM,
    reduceBNF
) where

{----------------------------------------------------------------------}
{-- Module Imports                                                    -}
{----------------------------------------------------------------------}
    
import Prelude hiding (succ, pred)
import Debug.Trace

import Control.Applicative
import Control.Monad.Error hiding (fix)
import Control.Monad.State hiding (fix)

import qualified Data.Map as M

import Kinds
import Types
import TypeCheck
import AST
import Env
    
{----------------------------------------------------------------------}
{-- Interpreter                                                       -}
{----------------------------------------------------------------------}

type Interpreter = ErrorT String (State GlEnv)
    
{----------------------------------------------------------------------}
{-- Evaluation                                                        -}
{----------------------------------------------------------------------}
    
fixM :: (Eq a, Monad m) => (a -> m a) -> a -> m a
fixM f x = do x' <- f x
              if x == x' then return x else fixM f x' 
    
succ :: Expr -> Expr
succ (Val n) = Val (n+1)
succ e       = Succ e
    
pred :: Expr -> Expr
pred (Val n) | n > 0     = Val (n-1)
             | otherwise = Val 0
pred e                   = Pred e
    
iszero :: Expr -> Expr
iszero (Val n) | n == 0 = Val 1
               | n /= 0 = Val 0
iszero e                = IsZero e

istrue :: Expr -> Bool
istrue (Val n) | n /= 0 = True
istrue e                = False
    
eval' :: Expr -> Interpreter Expr
--eval' (Succ n)     = succ <$> fixM eval' n
--eval' (Pred n)     = pred <$> fixM eval' n
--eval' (IsZero n)   = iszero <$> fixM eval' n
--eval' (Fix f)      = fixM eval' (App f (Fix f))
eval' (App (Abs n t e) a) = bind (Abs n t e) a
eval' (App f a)    = do
    f' <- eval' f
    return $ App f' a 
{-eval' (Cond c t f) = do 
    r <- fixM eval' c
    if istrue r
    then fixM eval' t
    else fixM eval' f-}
eval' (Var n)      = do
    env <- gets valEnv
    case M.lookup n env of
        Nothing            -> throwError $ "Cannot evaluate: " ++ n ++ " is undefined in\n" ++ show (M.keys env)
        (Just (GlDef e t)) -> return e
--eval' (TyAbs x k e)  = return e
eval' (TyApp (TyAbs x k e) t) = return $ subst e (Sub x t)
eval' (TyApp e t)  = do
    e' <- eval' e
    return $ TyApp e' t
eval' e            = return e
    
fix :: (Eq a) => (a -> a) -> a -> a
fix f x = if x == x' then x else fix f x' 
          where x' = f x
    
bind :: Expr -> Expr -> Interpreter Expr
bind (Abs n _ e) a = return $ subst e (Sub n a)
bind f           a = throwError $ "trying to apply " ++ show f ++ " to " ++ show a

bindBNF :: Expr -> Expr -> Expr
bindBNF (Abs n _ e) a = subst e (Sub n a)
bindBNF f           a = App f a
  
{-  
    Performs beta-reduction on an expression.
-}

reduceBNF :: Expr -> Expr
reduceBNF (App f a)   = bindBNF (reduceBNF f) (reduceBNF a)
reduceBNF (Abs n t e) = Abs n t (reduceBNF e)
reduceBNF expr        = expr
    
{----------------------------------------------------------------------}
{-- External Interface                                                -}
{----------------------------------------------------------------------}
    
eval :: GlEnv -> Expr -> Either String Expr
eval env e = evalState (runErrorT (eval' e)) env

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  
