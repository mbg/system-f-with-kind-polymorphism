
module Env (
    GlDef(..),
    GlEnv(..),
    emptyGlEnv,
    Env
) where

import Control.Monad.State

import qualified Data.Map as M

import Kinds
import Types
import Expr 

{----------------------------------------------------------------------}
{-- Global Environment                                                -}
{----------------------------------------------------------------------}
    
data GlDef a b = GlDef {
    glDef :: a,
    glAnn :: b
} deriving Show
 
{-   
    The global enviornment contains a list of all definitions and their
    inferred types.
-}

data GlEnv = MkGlEnv {
    kindEnv :: M.Map String Kind,
    typeEnv :: M.Map String (GlDef Type Kind),
    valEnv  :: M.Map Variable (GlDef Expr Type)
} deriving Show

emptyGlEnv :: GlEnv 
emptyGlEnv = MkGlEnv M.empty M.empty M.empty

{-
    We use the global environment as state parameter for an instance of the
    state monad transformer on top of IO.
-}

type Env = StateT GlEnv IO



