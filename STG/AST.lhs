{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

This module contains the data types used to construct abstract syntax trees for the STG language
and it is mainly based on SPJ92.

> module STG.AST (
>   Name,
>   Vars,
>   Literal(..),
>   Program(..),
>   Binding(..),
>   LambdaF(..),
>   Flag(..),
>   Expr(..),
>   Primitive(..),
>   Atom(..),
>   Expression(..),
>   freeVarsList
> ) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import Control.Monad.State
>   import Data.Set hiding (map)
>   import Data.Word (Word32)
>   import Text.Printf (printf)

    {----------------------------------------------------------------------}
    {-- STG Language                                                      -}
    {----------------------------------------------------------------------}
    
    We will represent variables using strings of characters.
    
>   type Name      = String
>   type Vars      = [Name]

>   data Literal   = IntLit Word32

    A program in the STG language consists of zero or more bindings.

>   data Program   = P [Binding]

    A binding is a \-form assigned to a name.

>   data Binding   = B Name LambdaF

    A \-form consits of four components. 

>   data LambdaF   = L Vars Flag Vars Expr

    A \-form or thunk can either be updatable (in which case STG is permitted
    to replace the thunk with an updated version or not-updatable (in which
    case a thunk cannot be modified).

>   data Flag      = Updatable | NotUpdatable

    

>   data Expr      = Let [Binding] Expr
>                  | LetRec [Binding] Expr
>                  | Case Expr Alts
>                  | App Name [Atom]
>                  | Constr Name [Atom]
>                  | Prim Primitive [Atom]
>                  | Lit Literal

>   data Alts      = AlgAlts [AlgAlt] DefAlt
>                  | PriAlts [PriAlt] DefAlt

>   data AlgAlt    = AlgAlt Name Expr
>   data PriAlt    = PriAlt Literal

>   data DefAlt    = VarAlt Name Expr
>                  | DefAlt Expr

    Primitive operations on unboxed values.

>   data Primitive = Add | Sub | Mul | Div

    An atom is either a name or a literal.

>   data Atom      = AN Name | AL Literal

    {----------------------------------------------------------------------}
    {-- Free Variables                                                    -}
    {----------------------------------------------------------------------}

    The free variables of an expression are those that have not been
    introduced by \-terms.  
    
>   class Expression e where
>       freeVars :: e -> Set Name

>   instance Expression e => Expression [e] where
>       freeVars = unions . map freeVars

>   instance Expression Atom where
>       freeVars (AN n) = singleton n
>       freeVars _      = empty

>   instance Expression Expr where
>       freeVars (Prim _ as) = freeVars as

>   instance Expression LambdaF where
>       freeVars (L fs _ vs e) = fromList fs

>   instance Expression Binding where
>       freeVars (B n lf) = freeVars lf

>   freeVarsList :: Binding -> [Name]
>   freeVarsList = toList . freeVars
    
    {----------------------------------------------------------------------}
    {-- Pretty Printing                                                   -}
    {----------------------------------------------------------------------}
    
>   showArgs :: (Show a) => [a] -> String
>   showArgs = unwords . map show
    
>   instance Show Literal where
>       show (IntLit w) = "#" ++ show w

>   instance Show Atom where
>       show (AN n) = n
>       show (AL l) = show l

>   instance Show Primitive where
>       show Add = "Prim.+"
>       show Sub = "Prim.-"
>       show Mul = "Prim.*"
>       show Div = "Prim./"

>   instance Show Expr where
>       show (App n ps)    = printf "%s %s" n (showArgs ps)
>       show (Constr n ps) = printf "%s %s" n (showArgs ps)
>       show (Prim p as)   = printf "%s %s" (show p) (showArgs as)
>       show (Lit l)       = show l

>   instance Show Flag where
>       show Updatable    = "u"
>       show NotUpdatable = "n"

>   instance Show LambdaF where
>       show (L fs u vs e) = printf "{%s} \\%s {%s} %s" (showArgs fs) (show u) (showArgs vs) (show e)

>   instance Show Binding where
>       show (B n lf) = n ++ " = " ++ show lf

>   instance Show Program where
>       show (P bs) = unlines $ map show bs
    
{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
