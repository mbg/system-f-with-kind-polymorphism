{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

    In this module we implement the type inference algorithm for the simply-typed lambda-calculus.

> module TypeInference (
>   TyEnv,
>   infer
> ) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}

>   import Text.Printf (printf)
>   import Types
>   import AST

    {----------------------------------------------------------------------}
    {-- Type Inference                                                    -}
    {----------------------------------------------------------------------}
    
    A type environment associates variables with types.

>   type TyEnv = [(Variable, Type)]

    Tests if the domain of a function type matches the type of an argument.

>   unify :: Type -> Type -> Either String Type
>   unify (FunTy pt rt) at | pt == at = Right rt
>   unify t             at            = Left $ printf "Expected function of type (%s -> t), but found object of type %s instead." (show at) (show t)

>   ensure :: Type -> Type -> Either String Type
>   ensure x y | x == y    = Right x
>              | otherwise = Left $ printf "Expected object of type %s, but found object of type %s instead." (show y) (show x)

>   isFixFunction :: Type -> Either String Type
>   isFixFunction (FunTy pt rt) | pt == rt = Right pt
>   isFixFunction t                        = Left $ printf "Expected function of type (t -> t), but found object of type %s instead." (show t)

>   typeLookup :: Variable -> TyEnv -> Either String Type
>   typeLookup x env = case lookup x env of
>       (Just t) -> Right t
>       Nothing  -> Left $ "Unable to infer the type of `" ++ x ++ "' because it is undefined."

    Given an expression and a type environment, this function attempts to
    infer the type of the expression.
    
>   infer :: Expr -> TyEnv -> Either String Type
>   infer (Val _)      _   = do return natType
>   infer (Var x)      env = do typeLookup x env
>   infer (Abs x t e)  env = do t' <- infer e ((x,t) : env)
>                               return (FunTy t t')
>   infer (Succ e)     env = do t <- infer e env
>                               ensure t natType
>   infer (Pred e)     env = do t <- infer e env
>                               ensure t natType
>   infer (IsZero e)   env = do t <- infer e env
>                               ensure t natType
>   infer (Fix f)      env = do t <- infer f env
>                               isFixFunction t
>   infer (App f x)    env = do ft <- infer f env
>                               xt <- infer x env
>                               unify ft xt
>   infer (Cond c t f) env = do ct <- infer c env
>                               ensure ct natType
>                               tt <- infer t env
>                               ft <- infer f env
>                               ensure tt ft

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  