{-# LANGUAGE MultiParamTypeClasses, TypeFamilies #-}

module Subst where

data Subst a b = Sub {
    what :: a,
    with :: b
}

class Substitutable a b where 
    type Of b :: *
    subst :: a -> Subst (Of b) b -> a

