{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

In this module we define the type system of the simply-typed lambda-calculus.

> module Types (
>   TyName,
>   Type(..)
> )
> where

    {----------------------------------------------------------------------}
    {-- Type System                                                       -}
    {----------------------------------------------------------------------}
    
    A type name is just a string of characters.
    
>   type TyName = String

    Types can either be concrete types such as "Int" or they can be function
    types with a domain and codomain.
    
>   data Type = ConTy TyName
>             | FunTy Type Type
>             deriving Eq

    We create an instance of the Show type-class for the Type data type so
    that we can show the types of expressions.

>   instance Show Type where
>       show (ConTy n)   = n
>       show (FunTy d c) = "(" ++ show d ++ " -> " ++ show c ++ ")"

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  