
-- the identity function
let id = \x : Int.x                   

-- we can use definitions as free variables
let app = \f : Int -> Int.\x : Int.id

-- we can use definitions as aliases
let free = id
let x = free
let y = \free : Int . x

-- simple function application
let simpl = \f : Int -> Int.\x : Int.f x

-- this expression evaluates differently if the :! command is used
let bnf = (\f : (Int -> Int).\x : Int.f 6) id

-- function application is left associative
let e = (\f : Int -> Int.\x : Int.f x) id 1