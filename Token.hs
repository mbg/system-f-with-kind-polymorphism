module Token (
    Token(..)
) where
    data Token = TDef String
               | TVar String
               | TType String
               | TVal Int
               | TAbs
               | TDot
               | TOpen
               | TClose 
               | TColon
               | TArrow
               | TEquals
               deriving Show