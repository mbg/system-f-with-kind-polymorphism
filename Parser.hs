{-# OPTIONS_GHC -w #-}
module Parser (
    parseDef,
    parseProg,
    parseExpr
) where

import Token
import Types
import AST

-- parser produced by Happy Version 1.18.9

data HappyAbsSyn t6 t10 t11
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 (Expr)
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11

action_0 (22) = happyShift action_4
action_0 (6) = happyGoto action_19
action_0 _ = happyFail

action_1 (22) = happyShift action_4
action_1 (6) = happyGoto action_17
action_1 (11) = happyGoto action_18
action_1 _ = happyReduce_20

action_2 (14) = happyShift action_8
action_2 (16) = happyShift action_9
action_2 (19) = happyShift action_10
action_2 (20) = happyShift action_11
action_2 (23) = happyShift action_12
action_2 (24) = happyShift action_13
action_2 (25) = happyShift action_14
action_2 (26) = happyShift action_15
action_2 (29) = happyShift action_16
action_2 (7) = happyGoto action_5
action_2 (8) = happyGoto action_6
action_2 (9) = happyGoto action_7
action_2 _ = happyFail

action_3 (22) = happyShift action_4
action_3 _ = happyFail

action_4 (20) = happyShift action_29
action_4 _ = happyFail

action_5 (30) = happyAccept
action_5 _ = happyFail

action_6 (16) = happyShift action_9
action_6 (19) = happyShift action_10
action_6 (20) = happyShift action_11
action_6 (9) = happyGoto action_28
action_6 _ = happyReduce_10

action_7 _ = happyReduce_12

action_8 (20) = happyShift action_27
action_8 _ = happyFail

action_9 (14) = happyShift action_8
action_9 (16) = happyShift action_9
action_9 (19) = happyShift action_10
action_9 (20) = happyShift action_11
action_9 (23) = happyShift action_12
action_9 (24) = happyShift action_13
action_9 (25) = happyShift action_14
action_9 (26) = happyShift action_15
action_9 (29) = happyShift action_16
action_9 (7) = happyGoto action_26
action_9 (8) = happyGoto action_6
action_9 (9) = happyGoto action_7
action_9 _ = happyFail

action_10 _ = happyReduce_13

action_11 _ = happyReduce_14

action_12 (14) = happyShift action_8
action_12 (16) = happyShift action_9
action_12 (19) = happyShift action_10
action_12 (20) = happyShift action_11
action_12 (23) = happyShift action_12
action_12 (24) = happyShift action_13
action_12 (25) = happyShift action_14
action_12 (26) = happyShift action_15
action_12 (29) = happyShift action_16
action_12 (7) = happyGoto action_25
action_12 (8) = happyGoto action_6
action_12 (9) = happyGoto action_7
action_12 _ = happyFail

action_13 (14) = happyShift action_8
action_13 (16) = happyShift action_9
action_13 (19) = happyShift action_10
action_13 (20) = happyShift action_11
action_13 (23) = happyShift action_12
action_13 (24) = happyShift action_13
action_13 (25) = happyShift action_14
action_13 (26) = happyShift action_15
action_13 (29) = happyShift action_16
action_13 (7) = happyGoto action_24
action_13 (8) = happyGoto action_6
action_13 (9) = happyGoto action_7
action_13 _ = happyFail

action_14 (14) = happyShift action_8
action_14 (16) = happyShift action_9
action_14 (19) = happyShift action_10
action_14 (20) = happyShift action_11
action_14 (23) = happyShift action_12
action_14 (24) = happyShift action_13
action_14 (25) = happyShift action_14
action_14 (26) = happyShift action_15
action_14 (29) = happyShift action_16
action_14 (7) = happyGoto action_23
action_14 (8) = happyGoto action_6
action_14 (9) = happyGoto action_7
action_14 _ = happyFail

action_15 (14) = happyShift action_8
action_15 (16) = happyShift action_9
action_15 (19) = happyShift action_10
action_15 (20) = happyShift action_11
action_15 (23) = happyShift action_12
action_15 (24) = happyShift action_13
action_15 (25) = happyShift action_14
action_15 (26) = happyShift action_15
action_15 (29) = happyShift action_16
action_15 (7) = happyGoto action_22
action_15 (8) = happyGoto action_6
action_15 (9) = happyGoto action_7
action_15 _ = happyFail

action_16 (14) = happyShift action_8
action_16 (16) = happyShift action_9
action_16 (19) = happyShift action_10
action_16 (20) = happyShift action_11
action_16 (23) = happyShift action_12
action_16 (24) = happyShift action_13
action_16 (25) = happyShift action_14
action_16 (26) = happyShift action_15
action_16 (29) = happyShift action_16
action_16 (7) = happyGoto action_21
action_16 (8) = happyGoto action_6
action_16 (9) = happyGoto action_7
action_16 _ = happyFail

action_17 (22) = happyShift action_4
action_17 (6) = happyGoto action_17
action_17 (11) = happyGoto action_20
action_17 _ = happyReduce_20

action_18 (30) = happyAccept
action_18 _ = happyFail

action_19 (30) = happyAccept
action_19 _ = happyFail

action_20 _ = happyReduce_19

action_21 _ = happyReduce_8

action_22 (27) = happyShift action_33
action_22 _ = happyFail

action_23 _ = happyReduce_7

action_24 _ = happyReduce_6

action_25 _ = happyReduce_5

action_26 (17) = happyShift action_32
action_26 _ = happyFail

action_27 (13) = happyShift action_31
action_27 _ = happyFail

action_28 _ = happyReduce_11

action_29 (12) = happyShift action_30
action_29 _ = happyFail

action_30 (14) = happyShift action_8
action_30 (16) = happyShift action_9
action_30 (19) = happyShift action_10
action_30 (20) = happyShift action_11
action_30 (23) = happyShift action_12
action_30 (24) = happyShift action_13
action_30 (25) = happyShift action_14
action_30 (26) = happyShift action_15
action_30 (29) = happyShift action_16
action_30 (7) = happyGoto action_38
action_30 (8) = happyGoto action_6
action_30 (9) = happyGoto action_7
action_30 _ = happyFail

action_31 (16) = happyShift action_36
action_31 (21) = happyShift action_37
action_31 (10) = happyGoto action_35
action_31 _ = happyFail

action_32 _ = happyReduce_15

action_33 (14) = happyShift action_8
action_33 (16) = happyShift action_9
action_33 (19) = happyShift action_10
action_33 (20) = happyShift action_11
action_33 (23) = happyShift action_12
action_33 (24) = happyShift action_13
action_33 (25) = happyShift action_14
action_33 (26) = happyShift action_15
action_33 (29) = happyShift action_16
action_33 (7) = happyGoto action_34
action_33 (8) = happyGoto action_6
action_33 (9) = happyGoto action_7
action_33 _ = happyFail

action_34 (28) = happyShift action_42
action_34 _ = happyFail

action_35 (15) = happyShift action_40
action_35 (18) = happyShift action_41
action_35 _ = happyFail

action_36 (16) = happyShift action_36
action_36 (21) = happyShift action_37
action_36 (10) = happyGoto action_39
action_36 _ = happyFail

action_37 _ = happyReduce_16

action_38 _ = happyReduce_3

action_39 (17) = happyShift action_46
action_39 (18) = happyShift action_41
action_39 _ = happyFail

action_40 (14) = happyShift action_8
action_40 (16) = happyShift action_9
action_40 (19) = happyShift action_10
action_40 (20) = happyShift action_11
action_40 (23) = happyShift action_12
action_40 (24) = happyShift action_13
action_40 (25) = happyShift action_14
action_40 (26) = happyShift action_15
action_40 (29) = happyShift action_16
action_40 (7) = happyGoto action_45
action_40 (8) = happyGoto action_6
action_40 (9) = happyGoto action_7
action_40 _ = happyFail

action_41 (16) = happyShift action_36
action_41 (21) = happyShift action_37
action_41 (10) = happyGoto action_44
action_41 _ = happyFail

action_42 (14) = happyShift action_8
action_42 (16) = happyShift action_9
action_42 (19) = happyShift action_10
action_42 (20) = happyShift action_11
action_42 (23) = happyShift action_12
action_42 (24) = happyShift action_13
action_42 (25) = happyShift action_14
action_42 (26) = happyShift action_15
action_42 (29) = happyShift action_16
action_42 (7) = happyGoto action_43
action_42 (8) = happyGoto action_6
action_42 (9) = happyGoto action_7
action_42 _ = happyFail

action_43 _ = happyReduce_9

action_44 (18) = happyShift action_41
action_44 _ = happyReduce_17

action_45 _ = happyReduce_4

action_46 _ = happyReduce_18

happyReduce_3 = happyReduce 4 6 happyReduction_3
happyReduction_3 ((HappyAbsSyn7  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Def happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_4 = happyReduce 6 7 happyReduction_4
happyReduction_4 ((HappyAbsSyn7  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Abs happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_5 = happySpecReduce_2  7 happyReduction_5
happyReduction_5 (HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (Succ happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  7 happyReduction_6
happyReduction_6 (HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (Pred happy_var_2
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_2  7 happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (IsZero happy_var_2
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  7 happyReduction_8
happyReduction_8 (HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (Fix happy_var_2
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happyReduce 6 7 happyReduction_9
happyReduction_9 ((HappyAbsSyn7  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Cond happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_10 = happySpecReduce_1  7 happyReduction_10
happyReduction_10 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_2  8 happyReduction_11
happyReduction_11 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (App happy_var_1 happy_var_2
	)
happyReduction_11 _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  8 happyReduction_12
happyReduction_12 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  9 happyReduction_13
happyReduction_13 (HappyTerminal (TVal happy_var_1))
	 =  HappyAbsSyn7
		 (Val happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  9 happyReduction_14
happyReduction_14 (HappyTerminal (TVar happy_var_1))
	 =  HappyAbsSyn7
		 (Var happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  9 happyReduction_15
happyReduction_15 _
	(HappyAbsSyn7  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (happy_var_2
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  10 happyReduction_16
happyReduction_16 (HappyTerminal (TType happy_var_1))
	 =  HappyAbsSyn10
		 (ConTy happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  10 happyReduction_17
happyReduction_17 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (FunTy happy_var_1 happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  10 happyReduction_18
happyReduction_18 _
	(HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (happy_var_2
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_2  11 happyReduction_19
happyReduction_19 (HappyAbsSyn11  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1 : happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_0  11 happyReduction_20
happyReduction_20  =  HappyAbsSyn11
		 ([]
	)

happyNewToken action sts stk [] =
	action 30 30 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TEquals -> cont 12;
	TColon -> cont 13;
	TAbs -> cont 14;
	TDot -> cont 15;
	TOpen -> cont 16;
	TClose -> cont 17;
	TArrow -> cont 18;
	TVal happy_dollar_dollar -> cont 19;
	TVar happy_dollar_dollar -> cont 20;
	TType happy_dollar_dollar -> cont 21;
	TLet -> cont 22;
	TSucc -> cont 23;
	TPred -> cont 24;
	TIsZero -> cont 25;
	TIf -> cont 26;
	TThen -> cont 27;
	TElse -> cont 28;
	TFix -> cont 29;
	_ -> happyError' (tk:tks)
	}

happyError_ 30 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Monad HappyIdentity where
    return = HappyIdentity
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Token)] -> HappyIdentity a
happyError' = HappyIdentity . parseError

parseDef tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn6 z -> happyReturn z; _other -> notHappyAtAll })

parseProg tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_1 tks) (\x -> case x of {HappyAbsSyn11 z -> happyReturn z; _other -> notHappyAtAll })

parseExpr tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_2 tks) (\x -> case x of {HappyAbsSyn7 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError ts = error "parser error"
{-# LINE 1 "templates\GenericTemplate.hs" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
{-# LINE 1 "<inbyggd>" #-}
{-# LINE 1 "<kommandorad>" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 30 "templates\\GenericTemplate.hs" #-}








{-# LINE 51 "templates\\GenericTemplate.hs" #-}

{-# LINE 61 "templates\\GenericTemplate.hs" #-}

{-# LINE 70 "templates\\GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
	happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
	 (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 148 "templates\\GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
	 sts1@(((st1@(HappyState (action))):(_))) ->
        	let r = fn stk in  -- it doesn't hurt to always seq here...
       		happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
        happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
       happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))
       where (sts1@(((st1@(HappyState (action))):(_)))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk





             new_state = action


happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 246 "templates\\GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let (i) = (case x of { HappyErrorToken (i) -> i }) in
--	trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
						(saved_tok `HappyStk` _ `HappyStk` stk) =
--	trace ("discarding state, depth " ++ show (length stk))  $
	action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
	action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--	happySeq = happyDoSeq
-- otherwise it emits
-- 	happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 312 "templates\\GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
