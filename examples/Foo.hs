kind TYPE = forall k.k ~> * 

type ColourAndBool : TYPE 
                   = with k.forall a : k.a -> a -> a 

let redOrTrue    : ColourAndBool = with k./\a : k.\t : a.\f : a.t
let greenOrFalse : ColourAndBool = with k./\a : k.\t : a.\f : a.f

type Nat : TYPE
         = with k.forall n : k.n -> (n -> n) -> n

let zero : Nat = with k./\n : k.\z : n.\s : n -> n.z
let one  : Nat = with k./\n : k.\z : n.\s : n -> n.s z

type Foo : TYPE ~> TYPE
         = forall arg : TYPE.Nat