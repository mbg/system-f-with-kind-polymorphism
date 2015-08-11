{-# OPTIONS_GHC -w #-}
module Parser (
    parseDef,
    parseProg,
    parseExpr,
    parseType,
    parseKind
) where

import Token
import Kinds
import Types
import Expr
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn t16 t17 t18 t24 t25
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn8 ([String])
	| HappyAbsSyn9 (Kind)
	| HappyAbsSyn12 (Maybe Kind)
	| HappyAbsSyn13 ((String, Kind))
	| HappyAbsSyn14 ([(String, Kind)])
	| HappyAbsSyn15 (Type)
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 (Maybe Type)
	| HappyAbsSyn20 (Expr)
	| HappyAbsSyn23 ([Type])
	| HappyAbsSyn24 t24
	| HappyAbsSyn25 t25

action_0 (45) = happyShift action_35
action_0 (53) = happyShift action_36
action_0 (54) = happyShift action_37
action_0 (24) = happyGoto action_38
action_0 _ = happyFail

action_1 (45) = happyShift action_35
action_1 (53) = happyShift action_36
action_1 (54) = happyShift action_37
action_1 (24) = happyGoto action_33
action_1 (25) = happyGoto action_34
action_1 _ = happyReduce_51

action_2 (28) = happyShift action_27
action_2 (29) = happyShift action_28
action_2 (32) = happyShift action_29
action_2 (39) = happyShift action_30
action_2 (43) = happyShift action_31
action_2 (56) = happyShift action_32
action_2 (20) = happyGoto action_24
action_2 (21) = happyGoto action_25
action_2 (22) = happyGoto action_26
action_2 _ = happyFail

action_3 (32) = happyShift action_19
action_3 (43) = happyShift action_20
action_3 (44) = happyShift action_21
action_3 (55) = happyShift action_22
action_3 (56) = happyShift action_23
action_3 (15) = happyGoto action_15
action_3 (16) = happyGoto action_16
action_3 (17) = happyGoto action_17
action_3 (18) = happyGoto action_18
action_3 _ = happyFail

action_4 (32) = happyShift action_10
action_4 (38) = happyShift action_11
action_4 (43) = happyShift action_12
action_4 (44) = happyShift action_13
action_4 (55) = happyShift action_14
action_4 (9) = happyGoto action_7
action_4 (10) = happyGoto action_8
action_4 (11) = happyGoto action_9
action_4 _ = happyFail

action_5 (43) = happyShift action_6
action_5 _ = happyFail

action_6 _ = happyReduce_5

action_7 (57) = happyAccept
action_7 _ = happyFail

action_8 _ = happyReduce_8

action_9 (41) = happyShift action_60
action_9 _ = happyReduce_10

action_10 (32) = happyShift action_10
action_10 (38) = happyShift action_11
action_10 (43) = happyShift action_12
action_10 (44) = happyShift action_13
action_10 (55) = happyShift action_14
action_10 (9) = happyGoto action_59
action_10 (10) = happyGoto action_8
action_10 (11) = happyGoto action_9
action_10 _ = happyFail

action_11 _ = happyReduce_11

action_12 _ = happyReduce_13

action_13 _ = happyReduce_12

action_14 (43) = happyShift action_6
action_14 (8) = happyGoto action_58
action_14 _ = happyFail

action_15 (57) = happyAccept
action_15 _ = happyFail

action_16 _ = happyReduce_21

action_17 (32) = happyShift action_19
action_17 (36) = happyShift action_56
action_17 (40) = happyShift action_57
action_17 (43) = happyShift action_20
action_17 (44) = happyShift action_21
action_17 (18) = happyGoto action_55
action_17 _ = happyReduce_26

action_18 _ = happyReduce_29

action_19 (32) = happyShift action_19
action_19 (43) = happyShift action_20
action_19 (44) = happyShift action_21
action_19 (55) = happyShift action_22
action_19 (56) = happyShift action_23
action_19 (15) = happyGoto action_54
action_19 (16) = happyGoto action_16
action_19 (17) = happyGoto action_17
action_19 (18) = happyGoto action_18
action_19 _ = happyFail

action_20 _ = happyReduce_31

action_21 _ = happyReduce_30

action_22 (32) = happyShift action_52
action_22 (43) = happyShift action_53
action_22 (13) = happyGoto action_50
action_22 (14) = happyGoto action_51
action_22 _ = happyFail

action_23 (43) = happyShift action_49
action_23 _ = happyFail

action_24 (57) = happyAccept
action_24 _ = happyFail

action_25 (32) = happyShift action_29
action_25 (34) = happyShift action_48
action_25 (39) = happyShift action_30
action_25 (43) = happyShift action_31
action_25 (22) = happyGoto action_47
action_25 _ = happyReduce_38

action_26 _ = happyReduce_41

action_27 (43) = happyShift action_46
action_27 _ = happyFail

action_28 (43) = happyShift action_45
action_28 _ = happyFail

action_29 (28) = happyShift action_27
action_29 (29) = happyShift action_28
action_29 (32) = happyShift action_29
action_29 (39) = happyShift action_30
action_29 (43) = happyShift action_31
action_29 (56) = happyShift action_32
action_29 (20) = happyGoto action_44
action_29 (21) = happyGoto action_25
action_29 (22) = happyGoto action_26
action_29 _ = happyFail

action_30 _ = happyReduce_43

action_31 _ = happyReduce_42

action_32 (43) = happyShift action_43
action_32 _ = happyFail

action_33 (45) = happyShift action_35
action_33 (53) = happyShift action_36
action_33 (54) = happyShift action_37
action_33 (24) = happyGoto action_33
action_33 (25) = happyGoto action_42
action_33 _ = happyReduce_51

action_34 (57) = happyAccept
action_34 _ = happyFail

action_35 (43) = happyShift action_41
action_35 _ = happyFail

action_36 (44) = happyShift action_40
action_36 _ = happyFail

action_37 (44) = happyShift action_39
action_37 _ = happyFail

action_38 (57) = happyAccept
action_38 _ = happyFail

action_39 (26) = happyShift action_84
action_39 _ = happyFail

action_40 (27) = happyShift action_83
action_40 (12) = happyGoto action_82
action_40 _ = happyReduce_16

action_41 (27) = happyShift action_81
action_41 (19) = happyGoto action_80
action_41 _ = happyReduce_34

action_42 _ = happyReduce_50

action_43 (30) = happyShift action_79
action_43 _ = happyFail

action_44 (33) = happyShift action_78
action_44 _ = happyFail

action_45 (27) = happyShift action_77
action_45 _ = happyFail

action_46 (27) = happyShift action_76
action_46 _ = happyFail

action_47 _ = happyReduce_39

action_48 (32) = happyShift action_19
action_48 (43) = happyShift action_20
action_48 (44) = happyShift action_21
action_48 (55) = happyShift action_22
action_48 (56) = happyShift action_23
action_48 (15) = happyGoto action_74
action_48 (16) = happyGoto action_16
action_48 (17) = happyGoto action_17
action_48 (18) = happyGoto action_18
action_48 (23) = happyGoto action_75
action_48 _ = happyFail

action_49 (30) = happyShift action_73
action_49 _ = happyFail

action_50 _ = happyReduce_19

action_51 (30) = happyShift action_71
action_51 (32) = happyShift action_52
action_51 (43) = happyShift action_72
action_51 (13) = happyGoto action_70
action_51 _ = happyFail

action_52 (43) = happyShift action_69
action_52 _ = happyFail

action_53 (27) = happyShift action_68
action_53 _ = happyReduce_18

action_54 (33) = happyShift action_67
action_54 _ = happyFail

action_55 _ = happyReduce_27

action_56 (32) = happyShift action_10
action_56 (38) = happyShift action_11
action_56 (43) = happyShift action_12
action_56 (44) = happyShift action_13
action_56 (55) = happyShift action_14
action_56 (9) = happyGoto action_66
action_56 (10) = happyGoto action_8
action_56 (11) = happyGoto action_9
action_56 _ = happyFail

action_57 (32) = happyShift action_19
action_57 (43) = happyShift action_20
action_57 (44) = happyShift action_21
action_57 (16) = happyGoto action_65
action_57 (17) = happyGoto action_17
action_57 (18) = happyGoto action_18
action_57 _ = happyFail

action_58 (30) = happyShift action_63
action_58 (43) = happyShift action_64
action_58 _ = happyFail

action_59 (33) = happyShift action_62
action_59 _ = happyFail

action_60 (32) = happyShift action_10
action_60 (38) = happyShift action_11
action_60 (43) = happyShift action_12
action_60 (44) = happyShift action_13
action_60 (10) = happyGoto action_61
action_60 (11) = happyGoto action_9
action_60 _ = happyFail

action_61 _ = happyReduce_9

action_62 _ = happyReduce_14

action_63 (32) = happyShift action_10
action_63 (38) = happyShift action_11
action_63 (43) = happyShift action_12
action_63 (44) = happyShift action_13
action_63 (55) = happyShift action_14
action_63 (9) = happyGoto action_100
action_63 (10) = happyGoto action_8
action_63 (11) = happyGoto action_9
action_63 _ = happyFail

action_64 _ = happyReduce_6

action_65 _ = happyReduce_25

action_66 (37) = happyShift action_99
action_66 _ = happyFail

action_67 _ = happyReduce_32

action_68 (32) = happyShift action_10
action_68 (38) = happyShift action_11
action_68 (43) = happyShift action_12
action_68 (44) = happyShift action_13
action_68 (55) = happyShift action_14
action_68 (9) = happyGoto action_98
action_68 (10) = happyGoto action_8
action_68 (11) = happyGoto action_9
action_68 _ = happyFail

action_69 (27) = happyShift action_97
action_69 _ = happyFail

action_70 _ = happyReduce_20

action_71 (32) = happyShift action_19
action_71 (43) = happyShift action_20
action_71 (44) = happyShift action_21
action_71 (55) = happyShift action_22
action_71 (56) = happyShift action_23
action_71 (15) = happyGoto action_96
action_71 (16) = happyGoto action_16
action_71 (17) = happyGoto action_17
action_71 (18) = happyGoto action_18
action_71 _ = happyFail

action_72 _ = happyReduce_18

action_73 (32) = happyShift action_19
action_73 (43) = happyShift action_20
action_73 (44) = happyShift action_21
action_73 (55) = happyShift action_22
action_73 (56) = happyShift action_23
action_73 (15) = happyGoto action_95
action_73 (16) = happyGoto action_16
action_73 (17) = happyGoto action_17
action_73 (18) = happyGoto action_18
action_73 _ = happyFail

action_74 _ = happyReduce_45

action_75 (31) = happyShift action_93
action_75 (35) = happyShift action_94
action_75 _ = happyFail

action_76 (32) = happyShift action_10
action_76 (38) = happyShift action_11
action_76 (43) = happyShift action_12
action_76 (44) = happyShift action_13
action_76 (55) = happyShift action_14
action_76 (9) = happyGoto action_92
action_76 (10) = happyGoto action_8
action_76 (11) = happyGoto action_9
action_76 _ = happyFail

action_77 (32) = happyShift action_19
action_77 (43) = happyShift action_20
action_77 (44) = happyShift action_21
action_77 (55) = happyShift action_22
action_77 (56) = happyShift action_23
action_77 (15) = happyGoto action_91
action_77 (16) = happyGoto action_16
action_77 (17) = happyGoto action_17
action_77 (18) = happyGoto action_18
action_77 _ = happyFail

action_78 _ = happyReduce_44

action_79 (28) = happyShift action_27
action_79 (29) = happyShift action_28
action_79 (32) = happyShift action_29
action_79 (39) = happyShift action_30
action_79 (43) = happyShift action_31
action_79 (56) = happyShift action_32
action_79 (20) = happyGoto action_90
action_79 (21) = happyGoto action_25
action_79 (22) = happyGoto action_26
action_79 _ = happyFail

action_80 (26) = happyShift action_89
action_80 _ = happyFail

action_81 (32) = happyShift action_19
action_81 (43) = happyShift action_20
action_81 (44) = happyShift action_21
action_81 (55) = happyShift action_22
action_81 (56) = happyShift action_23
action_81 (15) = happyGoto action_88
action_81 (16) = happyGoto action_16
action_81 (17) = happyGoto action_17
action_81 (18) = happyGoto action_18
action_81 _ = happyFail

action_82 (26) = happyShift action_87
action_82 _ = happyFail

action_83 (32) = happyShift action_10
action_83 (38) = happyShift action_11
action_83 (43) = happyShift action_12
action_83 (44) = happyShift action_13
action_83 (55) = happyShift action_14
action_83 (9) = happyGoto action_86
action_83 (10) = happyGoto action_8
action_83 (11) = happyGoto action_9
action_83 _ = happyFail

action_84 (32) = happyShift action_10
action_84 (38) = happyShift action_11
action_84 (43) = happyShift action_12
action_84 (44) = happyShift action_13
action_84 (55) = happyShift action_14
action_84 (9) = happyGoto action_85
action_84 (10) = happyGoto action_8
action_84 (11) = happyGoto action_9
action_84 _ = happyFail

action_85 _ = happyReduce_49

action_86 _ = happyReduce_15

action_87 (32) = happyShift action_19
action_87 (43) = happyShift action_20
action_87 (44) = happyShift action_21
action_87 (55) = happyShift action_22
action_87 (56) = happyShift action_23
action_87 (15) = happyGoto action_107
action_87 (16) = happyGoto action_16
action_87 (17) = happyGoto action_17
action_87 (18) = happyGoto action_18
action_87 _ = happyFail

action_88 _ = happyReduce_33

action_89 (28) = happyShift action_27
action_89 (29) = happyShift action_28
action_89 (32) = happyShift action_29
action_89 (39) = happyShift action_30
action_89 (43) = happyShift action_31
action_89 (56) = happyShift action_32
action_89 (20) = happyGoto action_106
action_89 (21) = happyGoto action_25
action_89 (22) = happyGoto action_26
action_89 _ = happyFail

action_90 _ = happyReduce_37

action_91 (30) = happyShift action_105
action_91 _ = happyFail

action_92 (30) = happyShift action_104
action_92 _ = happyFail

action_93 (32) = happyShift action_19
action_93 (43) = happyShift action_20
action_93 (44) = happyShift action_21
action_93 (55) = happyShift action_22
action_93 (56) = happyShift action_23
action_93 (15) = happyGoto action_103
action_93 (16) = happyGoto action_16
action_93 (17) = happyGoto action_17
action_93 (18) = happyGoto action_18
action_93 _ = happyFail

action_94 _ = happyReduce_40

action_95 _ = happyReduce_24

action_96 _ = happyReduce_23

action_97 (32) = happyShift action_10
action_97 (38) = happyShift action_11
action_97 (43) = happyShift action_12
action_97 (44) = happyShift action_13
action_97 (55) = happyShift action_14
action_97 (9) = happyGoto action_102
action_97 (10) = happyGoto action_8
action_97 (11) = happyGoto action_9
action_97 _ = happyFail

action_98 (30) = happyShift action_101
action_98 _ = happyFail

action_99 _ = happyReduce_28

action_100 _ = happyReduce_7

action_101 (32) = happyShift action_19
action_101 (43) = happyShift action_20
action_101 (44) = happyShift action_21
action_101 (55) = happyShift action_22
action_101 (56) = happyShift action_23
action_101 (15) = happyGoto action_111
action_101 (16) = happyGoto action_16
action_101 (17) = happyGoto action_17
action_101 (18) = happyGoto action_18
action_101 _ = happyFail

action_102 (33) = happyShift action_110
action_102 _ = happyFail

action_103 _ = happyReduce_46

action_104 (28) = happyShift action_27
action_104 (29) = happyShift action_28
action_104 (32) = happyShift action_29
action_104 (39) = happyShift action_30
action_104 (43) = happyShift action_31
action_104 (56) = happyShift action_32
action_104 (20) = happyGoto action_109
action_104 (21) = happyGoto action_25
action_104 (22) = happyGoto action_26
action_104 _ = happyFail

action_105 (28) = happyShift action_27
action_105 (29) = happyShift action_28
action_105 (32) = happyShift action_29
action_105 (39) = happyShift action_30
action_105 (43) = happyShift action_31
action_105 (56) = happyShift action_32
action_105 (20) = happyGoto action_108
action_105 (21) = happyGoto action_25
action_105 (22) = happyGoto action_26
action_105 _ = happyFail

action_106 _ = happyReduce_47

action_107 _ = happyReduce_48

action_108 _ = happyReduce_35

action_109 _ = happyReduce_36

action_110 _ = happyReduce_17

action_111 _ = happyReduce_22

happyReduce_5 = happySpecReduce_1  8 happyReduction_5
happyReduction_5 (HappyTerminal (TVar happy_var_1))
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_5 _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  8 happyReduction_6
happyReduction_6 (HappyTerminal (TVar happy_var_2))
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happyReduce 4 9 happyReduction_7
happyReduction_7 ((HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (mkKForAll happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_1  9 happyReduction_8
happyReduction_8 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  10 happyReduction_9
happyReduction_9 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (KArrow happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  10 happyReduction_10
happyReduction_10 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  11 happyReduction_11
happyReduction_11 _
	 =  HappyAbsSyn9
		 (KStar
	)

happyReduce_12 = happySpecReduce_1  11 happyReduction_12
happyReduction_12 (HappyTerminal (TCon happy_var_1))
	 =  HappyAbsSyn9
		 (KName happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  11 happyReduction_13
happyReduction_13 (HappyTerminal (TVar happy_var_1))
	 =  HappyAbsSyn9
		 (KVar happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  11 happyReduction_14
happyReduction_14 _
	(HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn9
		 (happy_var_2
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_2  12 happyReduction_15
happyReduction_15 (HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Just happy_var_2
	)
happyReduction_15 _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_0  12 happyReduction_16
happyReduction_16  =  HappyAbsSyn12
		 (Nothing
	)

happyReduce_17 = happyReduce 5 13 happyReduction_17
happyReduction_17 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 ((happy_var_2, happy_var_4 )
	) `HappyStk` happyRest

happyReduce_18 = happySpecReduce_1  13 happyReduction_18
happyReduction_18 (HappyTerminal (TVar happy_var_1))
	 =  HappyAbsSyn13
		 ((happy_var_1, KStar)
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  14 happyReduction_19
happyReduction_19 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn14
		 ([happy_var_1]
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_2  14 happyReduction_20
happyReduction_20 (HappyAbsSyn13  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  15 happyReduction_21
happyReduction_21 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happyReduce 6 15 happyReduction_22
happyReduction_22 ((HappyAbsSyn15  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (ForAllTy happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_23 = happyReduce 4 15 happyReduction_23
happyReduction_23 ((HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn14  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (mkForAllTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_24 = happyReduce 4 15 happyReduction_24
happyReduction_24 ((HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn15
		 (KindAbsTy happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_25 = happySpecReduce_3  16 happyReduction_25
happyReduction_25 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 (FunTy happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  16 happyReduction_26
happyReduction_26 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  17 happyReduction_27
happyReduction_27 (HappyAbsSyn18  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn17
		 (AppTy happy_var_1 happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happyReduce 4 17 happyReduction_28
happyReduction_28 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (KindAppTy happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_29 = happySpecReduce_1  17 happyReduction_29
happyReduction_29 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  18 happyReduction_30
happyReduction_30 (HappyTerminal (TCon happy_var_1))
	 =  HappyAbsSyn18
		 (ConTy happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  18 happyReduction_31
happyReduction_31 (HappyTerminal (TVar happy_var_1))
	 =  HappyAbsSyn18
		 (VarTy happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_3  18 happyReduction_32
happyReduction_32 _
	(HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn18
		 (happy_var_2
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_2  19 happyReduction_33
happyReduction_33 (HappyAbsSyn15  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Just happy_var_2
	)
happyReduction_33 _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_0  19 happyReduction_34
happyReduction_34  =  HappyAbsSyn19
		 (Nothing
	)

happyReduce_35 = happyReduce 6 20 happyReduction_35
happyReduction_35 ((HappyAbsSyn20  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Abs happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_36 = happyReduce 6 20 happyReduction_36
happyReduction_36 ((HappyAbsSyn20  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (TyAbs happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_37 = happyReduce 4 20 happyReduction_37
happyReduction_37 ((HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (KindAbs happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_2  21 happyReduction_39
happyReduction_39 (HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (App happy_var_1 happy_var_2
	)
happyReduction_39 _ _  = notHappyAtAll 

happyReduce_40 = happyReduce 4 21 happyReduction_40
happyReduction_40 (_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (mkTyApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_41 = happySpecReduce_1  21 happyReduction_41
happyReduction_41 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  22 happyReduction_42
happyReduction_42 (HappyTerminal (TVar happy_var_1))
	 =  HappyAbsSyn20
		 (Var happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  22 happyReduction_43
happyReduction_43 _
	 =  HappyAbsSyn20
		 (TyHole
	)

happyReduce_44 = happySpecReduce_3  22 happyReduction_44
happyReduction_44 _
	(HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (happy_var_2
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  23 happyReduction_45
happyReduction_45 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn23
		 ([happy_var_1]
	)
happyReduction_45 _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  23 happyReduction_46
happyReduction_46 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happyReduce 5 24 happyReduction_47
happyReduction_47 ((HappyAbsSyn20  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (Def happy_var_2 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_48 = happyReduce 5 24 happyReduction_48
happyReduction_48 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	(HappyTerminal (TCon happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (TypeDec happy_var_2 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_49 = happyReduce 4 24 happyReduction_49
happyReduction_49 ((HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCon happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (KindDec happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_50 = happySpecReduce_2  25 happyReduction_50
happyReduction_50 (HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1 : happy_var_2
	)
happyReduction_50 _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_0  25 happyReduction_51
happyReduction_51  =  HappyAbsSyn25
		 ([]
	)

happyNewToken action sts stk [] =
	action 57 57 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TEquals -> cont 26;
	TColon -> cont 27;
	TTyAbs -> cont 28;
	TAbs -> cont 29;
	TDot -> cont 30;
	TComma -> cont 31;
	TOpen -> cont 32;
	TClose -> cont 33;
	TAngLeft -> cont 34;
	TAngRight -> cont 35;
	TCurlyLeft -> cont 36;
	TCurlyRight -> cont 37;
	TStar -> cont 38;
	THole -> cont 39;
	TArrow -> cont 40;
	TKindArrow -> cont 41;
	TVal happy_dollar_dollar -> cont 42;
	TVar happy_dollar_dollar -> cont 43;
	TCon happy_dollar_dollar -> cont 44;
	TLet -> cont 45;
	TSucc -> cont 46;
	TPred -> cont 47;
	TIsZero -> cont 48;
	TIf -> cont 49;
	TThen -> cont 50;
	TElse -> cont 51;
	TFix -> cont 52;
	TType -> cont 53;
	TKind -> cont 54;
	TForAll -> cont 55;
	TWith -> cont 56;
	_ -> happyError' (tk:tks)
	}

happyError_ 57 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = return
    (<*>) = ap
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
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn24 z -> happyReturn z; _other -> notHappyAtAll })

parseProg tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_1 tks) (\x -> case x of {HappyAbsSyn25 z -> happyReturn z; _other -> notHappyAtAll })

parseExpr tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_2 tks) (\x -> case x of {HappyAbsSyn20 z -> happyReturn z; _other -> notHappyAtAll })

parseType tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_3 tks) (\x -> case x of {HappyAbsSyn15 z -> happyReturn z; _other -> notHappyAtAll })

parseKind tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_4 tks) (\x -> case x of {HappyAbsSyn9 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError ts = error "parser error"

mkKForAll :: [String] -> Kind -> Kind
mkKForAll ns k = foldr (\n k' -> KForAll n k') k ns

mkForAllTy :: [(String, Kind)] -> Type -> Type
mkForAllTy ns t = foldr (\(n,k) t' -> ForAllTy n k t') t ns

mkTyApp :: Expr -> [Type] -> Expr 
mkTyApp = foldl (\e t -> TyApp e t)
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 16 "<built-in>" #-}
{-# LINE 1 "/usr/local/lib/ghc-7.10.1/include/ghcversion.h" #-}


















{-# LINE 17 "<built-in>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 


{-# LINE 13 "templates/GenericTemplate.hs" #-}


{-# LINE 46 "templates/GenericTemplate.hs" #-}









{-# LINE 67 "templates/GenericTemplate.hs" #-}


{-# LINE 77 "templates/GenericTemplate.hs" #-}










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


{-# LINE 155 "templates/GenericTemplate.hs" #-}

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
     let i = (case x of { HappyErrorToken (i) -> i }) in
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
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
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
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









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

