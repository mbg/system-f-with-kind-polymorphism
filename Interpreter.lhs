{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

> module Interpreter (
>   GlDef(..),
>   GlEnv,
>   Env,
>   toTyEnv,
>   eval,fix,fixM,reduceBNF
> ) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import Prelude hiding (succ, pred)
>   import Debug.Trace

>   import Control.Applicative
>   import Control.Monad.Error hiding (fix)
>   import Control.Monad.State hiding (fix)

>   import Types
>   import TypeInference
>   import AST
    
    {----------------------------------------------------------------------}
    {-- Global Environment                                                -}
    {----------------------------------------------------------------------}
    
>   data GlDef = GlDef {
>       glExpr :: Expr,
>       glType :: Type
>   }
    
    The global enviornment contains a list of all definitions and their
    inferred types.
    
>   type GlEnv = [(Variable, GlDef)]

    We use the global environment as state parameter for an instance of the
    state monad transformer on top of IO.
    
>   type Env = StateT GlEnv IO

    The type-inferrence algorithm expects a type environment rather than a
    global environment so that we need two little helper functions which
    remove the expressions from the environment.
   
>   toTyPair :: (Variable, GlDef) -> (Variable, Type)
>   toTyPair (n, GlDef _ t) = (n,t)
   
>   toTyEnv :: GlEnv -> TyEnv
>   toTyEnv = map toTyPair
    
    {----------------------------------------------------------------------}
    {-- Interpreter                                                       -}
    {----------------------------------------------------------------------}

>   type Interpreter = ErrorT String (State GlEnv)
    
    {----------------------------------------------------------------------}
    {-- Evaluation                                                        -}
    {----------------------------------------------------------------------}
    
>   fixM :: (Eq a, Monad m) => (a -> m a) -> a -> m a
>   fixM f x = do x' <- f x
>                 if x == x' then return x else fixM f x' 
    
>   succ :: Expr -> Expr
>   succ (Val n) = Val (n+1)
>   succ e       = Succ e
    
>   pred :: Expr -> Expr
>   pred (Val n) | n > 0     = Val (n-1)
>                | otherwise = Val 0
>   pred e                   = Pred e
    
>   iszero :: Expr -> Expr
>   iszero (Val n) | n == 0 = Val 1
>                  | n /= 0 = Val 0
>   iszero e                = IsZero e

>   istrue :: Expr -> Bool
>   istrue (Val n) | n /= 0 = True
>   istrue e                = False
    
>   eval' :: Expr -> Interpreter Expr
>   eval' (Succ n)     = succ <$> fixM eval' n
>   eval' (Pred n)     = pred <$> fixM eval' n
>   eval' (IsZero n)   = iszero <$> fixM eval' n
>   eval' (Fix f)      = fixM eval' (App f (Fix f))
>   eval' (App f a)    = fixM eval' f >>= \r -> bind r a
>   eval' (Cond c t f) = do 
>       r <- fixM eval' c
>       if istrue r
>       then fixM eval' t
>       else fixM eval' f
>   eval' (Var n)      = do
>       env <- get
>       case lookup n env of
>           Nothing            -> throwError $ n ++ " is undefined"
>           (Just (GlDef e t)) -> fixM eval' e
>   eval' e            = return e
    
>   fix :: (Eq a) => (a -> a) -> a -> a
>   fix f x = if x == x' then x else fix f x' 
>             where x' = f x
    
>   bind :: Expr -> Expr -> Interpreter Expr
>   bind (Abs n _ e) a = return $ cas e n a
>   bind f           a = throwError $ "trying to apply " ++ show f ++ " to " ++ show a

>   bindBNF :: Expr -> Expr -> Expr
>   bindBNF (Abs n _ e) a = cas e n a
>   bindBNF f           a = App f a
    
    Performs beta-reduction on an expression.
          
>   reduceBNF :: Expr -> Expr
>   reduceBNF (App f a)   = bindBNF (reduceBNF f) (reduceBNF a)
>   reduceBNF (Abs n t e) = Abs n t (reduceBNF e)
>   reduceBNF expr        = expr
    
    {----------------------------------------------------------------------}
    {-- External Interface                                                -}
    {----------------------------------------------------------------------}
    
>   eval :: GlEnv -> Expr -> Either String Expr
>   eval env e = evalState (runErrorT (eval' e)) env

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  
