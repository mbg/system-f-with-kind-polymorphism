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

>   import Types
>   import AST

    {----------------------------------------------------------------------}
    {-- Type Inference                                                    -}
    {----------------------------------------------------------------------}
    
    A type environment associates variables with types.

>   type TyEnv = [(Variable, Type)]

>   unify :: Type -> Type -> Maybe Type
>   unify (FunTy pt rt) at | pt == at = Just rt
>   unify _             _             = Nothing

    Given an expression and a type environment, this function attempts to
    infer the type of the expression.
    
>   infer :: Expr -> TyEnv -> Maybe Type
>   infer (Val _)     _   = do return (ConTy "Int")
>   infer (Var x)     env = do lookup x env
>   infer (Abs x t e) env = do t' <- infer e ((x,t) : env)
>                              return (FunTy t t')
>   infer (App f x)   env = do ft <- infer f env
>                              xt <- infer x env
>                              unify ft xt

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  