{-# LANGUAGE TypeFamilies #-}

module FreeVars where

import qualified Data.Set as S 

class HasFVS t where 
    type VarType t :: *
    fvs :: t -> S.Set (VarType t) 