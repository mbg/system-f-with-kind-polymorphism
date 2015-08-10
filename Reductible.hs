module Reductible where 

class Reductible a where
    reduce :: a -> a
    reduceAnywhere :: a -> a

    hnf :: Eq a => a -> a
    hnf x
        | x' == x   = x
        | otherwise = hnf x'
            where
                x' = reduce x

    nf :: Eq a => a -> a
    nf x
        | x' == x   = x
        | otherwise = nf x'
            where
                x' = reduceAnywhere x