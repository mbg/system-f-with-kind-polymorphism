{--------------------------------------------------------------------------------------------------
                                Simply-kinded (polymorphic) \-calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

module Token (
  Token(..)
) where

data Token = TVar String
           | TTyVar String
           | TCon String
           | TVal Int
           | TSucc
           | TPred
           | TIf
           | TThen
           | TElse
           | TFix
           | TIsZero
           | TLet
           | TType
           | TKind
           | TForAll
           | TWith
           | TAbs
           | TTyAbs
           | TDot
           | TComma
           | TOpen
           | TClose 
           | TColon
           | TArrow
           | TKindArrow
           | TEquals
           | TStar
           | THole
           | TAngLeft
           | TAngRight
           | TCurlyLeft
           | TCurlyRight
           deriving Show

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  
