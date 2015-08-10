------------------------------------------------------------------------------
-- type-level booleans
------------------------------------------------------------------------------
kind BOOL  = forall k . k ~> k ~> k

type True  : BOOL = with k.forall (t : k) (f : k).t
type False : BOOL = with k.forall (t : k) (f : k).f

type If : forall k . BOOL ~> k ~> k ~> k
        = with k.
          forall (b : BOOL).
          forall (t : k) (f : k).
          b {k} t f

------------------------------------------------------------------------------
-- type-level natural numbers
------------------------------------------------------------------------------
kind NAT  = forall k.k ~> (k ~> k) ~> k

type Zero : NAT = with k.forall (z : k) (s : k ~> k).z
type One  : NAT = with k.forall (z : k) (s : k ~> k).s z
type Two  : NAT = with k.forall (z : k) (s : k ~> k).s (s z)

type Succ : NAT ~> NAT 
          = forall n : NAT.
            with k.
            forall (z : k) (s : k ~> k).
            s (n {k} z s)

--type Pred : NAT ~> NAT 
--          = forall n : NAT.
--            with k.
--            forall z : k.
--            forall s : k ~> k.
--            n {(k ~> k) ~> k} 
--                (forall u : k ~> k.z) 
--                (forall g : (k ~> k) ~> k.forall h : k ~> k.h (g s)) 
--                (forall u : k ~> k.u)

type IsZero : NAT ~> BOOL 
            = forall n : NAT.
              n {BOOL} True (forall x : BOOL.False)

type Add : NAT ~> NAT ~> NAT 
         = forall n : NAT.
           forall m : NAT.
           with k.
           forall (z : k) (s : k ~> k).
           n {k} (m {k} z s) s

------------------------------------------------------------------------------
-- value-level booleans
------------------------------------------------------------------------------
type Bool = forall a : *.a -> a -> a
let true  : Bool = /\a : *.\t : a.\f : a.t 
let false : Bool = /\a : *.\t : a.\f : a.f 

let and : Bool -> Bool -> Bool 
        = \p : Bool.
          \q : Bool.
          p [Bool] q false
let or  : Bool -> Bool -> Bool 
        = \p : Bool.
          \q : Bool.
          p [Bool] true q

------------------------------------------------------------------------------
-- value-level pairs (not yet poly-kinded)
------------------------------------------------------------------------------
type Pair = forall a b c.(a -> b -> c) -> c

let pair = /\a : *./\b : *./\c : *.\x : a.\y : b.\p : a -> b -> c.p x y

let fst = /\a : *./\b : *.\p : Pair.p [a, b, a] (\x : a.\y : b.x)
let snd = /\a : *./\b : *.\p : Pair.p [a, b, b] (\x : a.\y : b.y)

------------------------------------------------------------------------------
-- value-level lists
------------------------------------------------------------------------------
type List = forall a : *.forall r : *.(a -> r -> r) -> r -> r

let nil  : forall a.List a 
         = /\a : *./\r : *.\c : a -> r -> r.\n : r.n
let cons : forall a : *.a -> List a -> List a
         = /\a : *.
            \h : a.
            \t : List a.
           /\r : *.
            \c : a -> r -> r.
            \n : r.
             c h (t [r] c n)

let foo : List Bool = cons [Bool] true (nil [Bool])
let bar : List Bool = cons [Bool] false foo

let head : forall a.List a -> a -> a
        = /\a : *.
           \l : List a.
           \z : a.
            l [a] (\h : a.\t : a.h) z  
let tail : forall a.List a -> List a -> List a
         = /\a : *.
            \l : List a.
            \zs : List a.
             l [List a] (\h : a.\t : List a.t) zs

------------------------------------------------------------------------------
-- indexed value-level lists
------------------------------------------------------------------------------

type IList : NAT ~> * ~> (NAT ~> *) ~> * = 
    forall n : NAT.                                    -- length
    forall a : *.                                      -- element type
    forall r : NAT ~> *.  
    (forall m : NAT.a -> r m -> r (Succ m)) ->    -- cons
    r Zero ->                                          -- nil
    r n                                               -- resulting list

let inil : forall a.IList Zero a = 
    /\a : *.                                           -- element type
    /\r : NAT ~> *.                                    -- 'self'
    \c : forall m : NAT.a -> r m -> r (Succ m).        -- cons constructor
    \n : r Zero.                                       -- nil constructor
    n                                                  -- nil

let icons : forall (n : NAT) (a : *).a -> IList n a -> IList (Succ n) a 
          = /\n : NAT.                                         -- length of the tail
            /\a : *.                                           -- element type
             \h : a.                                            -- head
             \t : IList n a.                                   -- tail
            /\r : NAT ~> *.                                    -- 'self'
             \c : forall m : NAT.a -> r m -> r (Succ m).   -- cons constructor
             \n : r Zero.                                       -- nil constructor
              c [n] h (t [r] c n)                                   -- cons cell

let ifoo : IList One Bool = icons [Zero, Bool] true (inil [Bool])
let ibar : IList Two Bool = icons [One, Bool] false ifoo

let ihead : forall (n : NAT) (a : *).IList (Succ n) a -> a -> a 
          = /\n : NAT.                      -- length of the list -1
            /\a : *.                        -- element type
             \l   : IList (Succ n) a.       -- list (needs at least one element)
             \z   : a.                      -- default value (we need to get rid of this)
              l [forall m : NAT.a] (/\m : NAT.\h : a.\t : a.h) z

let itail : forall (n : NAT) (a : *).IList (Succ n) a -> IList n a -> IList n a 
          = /\n : NAT.
            /\a : *.
             \l   : IList (Succ n) a.
             \z   : IList n a.
             l [forall m : NAT.IList n a] (/\m : NAT.\h : a.\t : IList n a.t) z

--let iappend : forall (n : NAT) (m : NAT) (a : *).IList n a -> IList m a -> IList (Add m n) a
--            = /\n : NAT.
--              /\m : NAT.
--              /\a : *.
--               \xs : IList n a.
--               \ys : IList m a.
--               xs [forall m : NAT.IList ] (/\m : NAT.\h : a.\t : ) ys




