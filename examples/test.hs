
-- the identity function
let id = \x : Nat.x                   

-- we can use definitions as free variables
let app = \f : Nat -> Nat.\x : Nat.id

-- we can use definitions as aliases
let free = id
let x = free
let y = \free : Nat . x

-- simple function application
let simpl = \f : Nat -> Nat.\x : Nat.f x

-- this expression evaluates differently if the :! command is used
let bnf = (\f : (Nat -> Nat).\x : Nat.f 6) id

-- function application is left associative
let e = (\f : Nat -> Nat.\x : Nat.f x) id 1

-- addition on two natural numbers: we take three arguments:
--      r: the continuation 
--      x: the first operand
--      y: the second operand
-- if x is zero, then we simply return y
-- otherwise, we add 1 to the result of the continuation with x-1
let iadd = \r : Nat -> Nat -> Nat.\x : Nat.\y : Nat.if iszero x then y else succ r (pred x) y

-- add is simply the least fixed point of iadd
let add = fix iadd
