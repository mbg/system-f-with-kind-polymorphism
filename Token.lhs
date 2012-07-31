{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

> module Token (
>   Token(..)
> ) where

>   data Token = TVar String
>              | TType String
>              | TVal Int
>              | TSucc
>              | TPred
>              | TIf
>              | TThen
>              | TElse
>              | TFix
>              | TIsZero
>              | TLet
>              | TAbs
>              | TDot
>              | TOpen
>              | TClose 
>              | TColon
>              | TArrow
>              | TEquals
>              deriving Show
               

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  
