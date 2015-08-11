
-- class IsNat a where
--  isNat : forall a.IsNat a -> a -> Bool

-- data Dict a = MkDict (a -> Bool)
type Dict : TYPE ~> TYPE 
          = forall a : TYPE.with k.forall d : k.((a -> Bool) -> d) -> d

let mkDict : forall a : TYPE.(a -> Bool) -> Dict a
           = /\b : TYPE.\isNat : (b -> Bool).
             with k./\d : k.\ctr : ((b -> Bool) -> d).ctr isNat

-- instance IsNat Nat 
let natDict : Dict Nat 
            = mkDict [Nat] (\x : Nat.true)

-- instance IsNat Bool
let boolDict : Dict Bool
             = mkDict [Bool] (\x : Bool.false)

