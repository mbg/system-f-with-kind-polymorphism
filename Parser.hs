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
import AST
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

action_0 (45) = happyShift action_41
action_0 (53) = happyShift action_42
action_0 (54) = happyShift action_43
action_0 (24) = happyGoto action_44
action_0 _ = happyFail

action_1 (45) = happyShift action_41
action_1 (53) = happyShift action_42
action_1 (54) = happyShift action_43
action_1 (24) = happyGoto action_39
action_1 (25) = happyGoto action_40
action_1 _ = happyReduce_57

action_2 (28) = happyShift action_27
action_2 (29) = happyShift action_28
action_2 (32) = happyShift action_29
action_2 (39) = happyShift action_30
action_2 (42) = happyShift action_31
action_2 (43) = happyShift action_32
action_2 (46) = happyShift action_33
action_2 (47) = happyShift action_34
action_2 (48) = happyShift action_35
action_2 (49) = happyShift action_36
action_2 (52) = happyShift action_37
action_2 (56) = happyShift action_38
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

action_9 (41) = happyShift action_71
action_9 _ = happyReduce_10

action_10 (32) = happyShift action_10
action_10 (38) = happyShift action_11
action_10 (43) = happyShift action_12
action_10 (44) = happyShift action_13
action_10 (55) = happyShift action_14
action_10 (9) = happyGoto action_70
action_10 (10) = happyGoto action_8
action_10 (11) = happyGoto action_9
action_10 _ = happyFail

action_11 _ = happyReduce_11

action_12 _ = happyReduce_13

action_13 _ = happyReduce_12

action_14 (43) = happyShift action_6
action_14 (8) = happyGoto action_69
action_14 _ = happyFail

action_15 (57) = happyAccept
action_15 _ = happyFail

action_16 _ = happyReduce_21

action_17 (32) = happyShift action_19
action_17 (36) = happyShift action_67
action_17 (40) = happyShift action_68
action_17 (43) = happyShift action_20
action_17 (44) = happyShift action_21
action_17 (18) = happyGoto action_66
action_17 _ = happyReduce_26

action_18 _ = happyReduce_29

action_19 (32) = happyShift action_19
action_19 (43) = happyShift action_20
action_19 (44) = happyShift action_21
action_19 (55) = happyShift action_22
action_19 (56) = happyShift action_23
action_19 (15) = happyGoto action_65
action_19 (16) = happyGoto action_16
action_19 (17) = happyGoto action_17
action_19 (18) = happyGoto action_18
action_19 _ = happyFail

action_20 _ = happyReduce_31

action_21 _ = happyReduce_30

action_22 (32) = happyShift action_63
action_22 (43) = happyShift action_64
action_22 (13) = happyGoto action_61
action_22 (14) = happyGoto action_62
action_22 _ = happyFail

action_23 (43) = happyShift action_60
action_23 _ = happyFail

action_24 (57) = happyAccept
action_24 _ = happyFail

action_25 (32) = happyShift action_29
action_25 (34) = happyShift action_59
action_25 (39) = happyShift action_30
action_25 (42) = happyShift action_31
action_25 (43) = happyShift action_32
action_25 (22) = happyGoto action_58
action_25 _ = happyReduce_43

action_26 _ = happyReduce_46

action_27 (43) = happyShift action_57
action_27 _ = happyFail

action_28 (43) = happyShift action_56
action_28 _ = happyFail

action_29 (28) = happyShift action_27
action_29 (29) = happyShift action_28
action_29 (32) = happyShift action_29
action_29 (39) = happyShift action_30
action_29 (42) = happyShift action_31
action_29 (43) = happyShift action_32
action_29 (46) = happyShift action_33
action_29 (47) = happyShift action_34
action_29 (48) = happyShift action_35
action_29 (49) = happyShift action_36
action_29 (52) = happyShift action_37
action_29 (56) = happyShift action_38
action_29 (20) = happyGoto action_55
action_29 (21) = happyGoto action_25
action_29 (22) = happyGoto action_26
action_29 _ = happyFail

action_30 _ = happyReduce_49

action_31 _ = happyReduce_47

action_32 _ = happyReduce_48

action_33 (28) = happyShift action_27
action_33 (29) = happyShift action_28
action_33 (32) = happyShift action_29
action_33 (39) = happyShift action_30
action_33 (42) = happyShift action_31
action_33 (43) = happyShift action_32
action_33 (46) = happyShift action_33
action_33 (47) = happyShift action_34
action_33 (48) = happyShift action_35
action_33 (49) = happyShift action_36
action_33 (52) = happyShift action_37
action_33 (56) = happyShift action_38
action_33 (20) = happyGoto action_54
action_33 (21) = happyGoto action_25
action_33 (22) = happyGoto action_26
action_33 _ = happyFail

action_34 (28) = happyShift action_27
action_34 (29) = happyShift action_28
action_34 (32) = happyShift action_29
action_34 (39) = happyShift action_30
action_34 (42) = happyShift action_31
action_34 (43) = happyShift action_32
action_34 (46) = happyShift action_33
action_34 (47) = happyShift action_34
action_34 (48) = happyShift action_35
action_34 (49) = happyShift action_36
action_34 (52) = happyShift action_37
action_34 (56) = happyShift action_38
action_34 (20) = happyGoto action_53
action_34 (21) = happyGoto action_25
action_34 (22) = happyGoto action_26
action_34 _ = happyFail

action_35 (28) = happyShift action_27
action_35 (29) = happyShift action_28
action_35 (32) = happyShift action_29
action_35 (39) = happyShift action_30
action_35 (42) = happyShift action_31
action_35 (43) = happyShift action_32
action_35 (46) = happyShift action_33
action_35 (47) = happyShift action_34
action_35 (48) = happyShift action_35
action_35 (49) = happyShift action_36
action_35 (52) = happyShift action_37
action_35 (56) = happyShift action_38
action_35 (20) = happyGoto action_52
action_35 (21) = happyGoto action_25
action_35 (22) = happyGoto action_26
action_35 _ = happyFail

action_36 (28) = happyShift action_27
action_36 (29) = happyShift action_28
action_36 (32) = happyShift action_29
action_36 (39) = happyShift action_30
action_36 (42) = happyShift action_31
action_36 (43) = happyShift action_32
action_36 (46) = happyShift action_33
action_36 (47) = happyShift action_34
action_36 (48) = happyShift action_35
action_36 (49) = happyShift action_36
action_36 (52) = happyShift action_37
action_36 (56) = happyShift action_38
action_36 (20) = happyGoto action_51
action_36 (21) = happyGoto action_25
action_36 (22) = happyGoto action_26
action_36 _ = happyFail

action_37 (28) = happyShift action_27
action_37 (29) = happyShift action_28
action_37 (32) = happyShift action_29
action_37 (39) = happyShift action_30
action_37 (42) = happyShift action_31
action_37 (43) = happyShift action_32
action_37 (46) = happyShift action_33
action_37 (47) = happyShift action_34
action_37 (48) = happyShift action_35
action_37 (49) = happyShift action_36
action_37 (52) = happyShift action_37
action_37 (56) = happyShift action_38
action_37 (20) = happyGoto action_50
action_37 (21) = happyGoto action_25
action_37 (22) = happyGoto action_26
action_37 _ = happyFail

action_38 (43) = happyShift action_49
action_38 _ = happyFail

action_39 (45) = happyShift action_41
action_39 (53) = happyShift action_42
action_39 (54) = happyShift action_43
action_39 (24) = happyGoto action_39
action_39 (25) = happyGoto action_48
action_39 _ = happyReduce_57

action_40 (57) = happyAccept
action_40 _ = happyFail

action_41 (43) = happyShift action_47
action_41 _ = happyFail

action_42 (44) = happyShift action_46
action_42 _ = happyFail

action_43 (44) = happyShift action_45
action_43 _ = happyFail

action_44 (57) = happyAccept
action_44 _ = happyFail

action_45 (26) = happyShift action_96
action_45 _ = happyFail

action_46 (27) = happyShift action_95
action_46 (12) = happyGoto action_94
action_46 _ = happyReduce_16

action_47 (27) = happyShift action_93
action_47 (19) = happyGoto action_92
action_47 _ = happyReduce_34

action_48 _ = happyReduce_56

action_49 (30) = happyShift action_91
action_49 _ = happyFail

action_50 _ = happyReduce_41

action_51 (50) = happyShift action_90
action_51 _ = happyFail

action_52 _ = happyReduce_40

action_53 _ = happyReduce_39

action_54 _ = happyReduce_38

action_55 (33) = happyShift action_89
action_55 _ = happyFail

action_56 (27) = happyShift action_88
action_56 _ = happyFail

action_57 (27) = happyShift action_87
action_57 _ = happyFail

action_58 _ = happyReduce_44

action_59 (32) = happyShift action_19
action_59 (43) = happyShift action_20
action_59 (44) = happyShift action_21
action_59 (55) = happyShift action_22
action_59 (56) = happyShift action_23
action_59 (15) = happyGoto action_85
action_59 (16) = happyGoto action_16
action_59 (17) = happyGoto action_17
action_59 (18) = happyGoto action_18
action_59 (23) = happyGoto action_86
action_59 _ = happyFail

action_60 (30) = happyShift action_84
action_60 _ = happyFail

action_61 _ = happyReduce_19

action_62 (30) = happyShift action_82
action_62 (32) = happyShift action_63
action_62 (43) = happyShift action_83
action_62 (13) = happyGoto action_81
action_62 _ = happyFail

action_63 (43) = happyShift action_80
action_63 _ = happyFail

action_64 (27) = happyShift action_79
action_64 _ = happyReduce_18

action_65 (33) = happyShift action_78
action_65 _ = happyFail

action_66 _ = happyReduce_27

action_67 (32) = happyShift action_10
action_67 (38) = happyShift action_11
action_67 (43) = happyShift action_12
action_67 (44) = happyShift action_13
action_67 (55) = happyShift action_14
action_67 (9) = happyGoto action_77
action_67 (10) = happyGoto action_8
action_67 (11) = happyGoto action_9
action_67 _ = happyFail

action_68 (32) = happyShift action_19
action_68 (43) = happyShift action_20
action_68 (44) = happyShift action_21
action_68 (16) = happyGoto action_76
action_68 (17) = happyGoto action_17
action_68 (18) = happyGoto action_18
action_68 _ = happyFail

action_69 (30) = happyShift action_74
action_69 (43) = happyShift action_75
action_69 _ = happyFail

action_70 (33) = happyShift action_73
action_70 _ = happyFail

action_71 (32) = happyShift action_10
action_71 (38) = happyShift action_11
action_71 (43) = happyShift action_12
action_71 (44) = happyShift action_13
action_71 (10) = happyGoto action_72
action_71 (11) = happyGoto action_9
action_71 _ = happyFail

action_72 _ = happyReduce_9

action_73 _ = happyReduce_14

action_74 (32) = happyShift action_10
action_74 (38) = happyShift action_11
action_74 (43) = happyShift action_12
action_74 (44) = happyShift action_13
action_74 (55) = happyShift action_14
action_74 (9) = happyGoto action_113
action_74 (10) = happyGoto action_8
action_74 (11) = happyGoto action_9
action_74 _ = happyFail

action_75 _ = happyReduce_6

action_76 _ = happyReduce_25

action_77 (37) = happyShift action_112
action_77 _ = happyFail

action_78 _ = happyReduce_32

action_79 (32) = happyShift action_10
action_79 (38) = happyShift action_11
action_79 (43) = happyShift action_12
action_79 (44) = happyShift action_13
action_79 (55) = happyShift action_14
action_79 (9) = happyGoto action_111
action_79 (10) = happyGoto action_8
action_79 (11) = happyGoto action_9
action_79 _ = happyFail

action_80 (27) = happyShift action_110
action_80 _ = happyFail

action_81 _ = happyReduce_20

action_82 (32) = happyShift action_19
action_82 (43) = happyShift action_20
action_82 (44) = happyShift action_21
action_82 (55) = happyShift action_22
action_82 (56) = happyShift action_23
action_82 (15) = happyGoto action_109
action_82 (16) = happyGoto action_16
action_82 (17) = happyGoto action_17
action_82 (18) = happyGoto action_18
action_82 _ = happyFail

action_83 _ = happyReduce_18

action_84 (32) = happyShift action_19
action_84 (43) = happyShift action_20
action_84 (44) = happyShift action_21
action_84 (55) = happyShift action_22
action_84 (56) = happyShift action_23
action_84 (15) = happyGoto action_108
action_84 (16) = happyGoto action_16
action_84 (17) = happyGoto action_17
action_84 (18) = happyGoto action_18
action_84 _ = happyFail

action_85 _ = happyReduce_51

action_86 (31) = happyShift action_106
action_86 (35) = happyShift action_107
action_86 _ = happyFail

action_87 (32) = happyShift action_10
action_87 (38) = happyShift action_11
action_87 (43) = happyShift action_12
action_87 (44) = happyShift action_13
action_87 (55) = happyShift action_14
action_87 (9) = happyGoto action_105
action_87 (10) = happyGoto action_8
action_87 (11) = happyGoto action_9
action_87 _ = happyFail

action_88 (32) = happyShift action_19
action_88 (43) = happyShift action_20
action_88 (44) = happyShift action_21
action_88 (55) = happyShift action_22
action_88 (56) = happyShift action_23
action_88 (15) = happyGoto action_104
action_88 (16) = happyGoto action_16
action_88 (17) = happyGoto action_17
action_88 (18) = happyGoto action_18
action_88 _ = happyFail

action_89 _ = happyReduce_50

action_90 (28) = happyShift action_27
action_90 (29) = happyShift action_28
action_90 (32) = happyShift action_29
action_90 (39) = happyShift action_30
action_90 (42) = happyShift action_31
action_90 (43) = happyShift action_32
action_90 (46) = happyShift action_33
action_90 (47) = happyShift action_34
action_90 (48) = happyShift action_35
action_90 (49) = happyShift action_36
action_90 (52) = happyShift action_37
action_90 (56) = happyShift action_38
action_90 (20) = happyGoto action_103
action_90 (21) = happyGoto action_25
action_90 (22) = happyGoto action_26
action_90 _ = happyFail

action_91 (28) = happyShift action_27
action_91 (29) = happyShift action_28
action_91 (32) = happyShift action_29
action_91 (39) = happyShift action_30
action_91 (42) = happyShift action_31
action_91 (43) = happyShift action_32
action_91 (46) = happyShift action_33
action_91 (47) = happyShift action_34
action_91 (48) = happyShift action_35
action_91 (49) = happyShift action_36
action_91 (52) = happyShift action_37
action_91 (56) = happyShift action_38
action_91 (20) = happyGoto action_102
action_91 (21) = happyGoto action_25
action_91 (22) = happyGoto action_26
action_91 _ = happyFail

action_92 (26) = happyShift action_101
action_92 _ = happyFail

action_93 (32) = happyShift action_19
action_93 (43) = happyShift action_20
action_93 (44) = happyShift action_21
action_93 (55) = happyShift action_22
action_93 (56) = happyShift action_23
action_93 (15) = happyGoto action_100
action_93 (16) = happyGoto action_16
action_93 (17) = happyGoto action_17
action_93 (18) = happyGoto action_18
action_93 _ = happyFail

action_94 (26) = happyShift action_99
action_94 _ = happyFail

action_95 (32) = happyShift action_10
action_95 (38) = happyShift action_11
action_95 (43) = happyShift action_12
action_95 (44) = happyShift action_13
action_95 (55) = happyShift action_14
action_95 (9) = happyGoto action_98
action_95 (10) = happyGoto action_8
action_95 (11) = happyGoto action_9
action_95 _ = happyFail

action_96 (32) = happyShift action_10
action_96 (38) = happyShift action_11
action_96 (43) = happyShift action_12
action_96 (44) = happyShift action_13
action_96 (55) = happyShift action_14
action_96 (9) = happyGoto action_97
action_96 (10) = happyGoto action_8
action_96 (11) = happyGoto action_9
action_96 _ = happyFail

action_97 _ = happyReduce_55

action_98 _ = happyReduce_15

action_99 (32) = happyShift action_19
action_99 (43) = happyShift action_20
action_99 (44) = happyShift action_21
action_99 (55) = happyShift action_22
action_99 (56) = happyShift action_23
action_99 (15) = happyGoto action_121
action_99 (16) = happyGoto action_16
action_99 (17) = happyGoto action_17
action_99 (18) = happyGoto action_18
action_99 _ = happyFail

action_100 _ = happyReduce_33

action_101 (28) = happyShift action_27
action_101 (29) = happyShift action_28
action_101 (32) = happyShift action_29
action_101 (39) = happyShift action_30
action_101 (42) = happyShift action_31
action_101 (43) = happyShift action_32
action_101 (46) = happyShift action_33
action_101 (47) = happyShift action_34
action_101 (48) = happyShift action_35
action_101 (49) = happyShift action_36
action_101 (52) = happyShift action_37
action_101 (56) = happyShift action_38
action_101 (20) = happyGoto action_120
action_101 (21) = happyGoto action_25
action_101 (22) = happyGoto action_26
action_101 _ = happyFail

action_102 _ = happyReduce_37

action_103 (51) = happyShift action_119
action_103 _ = happyFail

action_104 (30) = happyShift action_118
action_104 _ = happyFail

action_105 (30) = happyShift action_117
action_105 _ = happyFail

action_106 (32) = happyShift action_19
action_106 (43) = happyShift action_20
action_106 (44) = happyShift action_21
action_106 (55) = happyShift action_22
action_106 (56) = happyShift action_23
action_106 (15) = happyGoto action_116
action_106 (16) = happyGoto action_16
action_106 (17) = happyGoto action_17
action_106 (18) = happyGoto action_18
action_106 _ = happyFail

action_107 _ = happyReduce_45

action_108 _ = happyReduce_24

action_109 _ = happyReduce_23

action_110 (32) = happyShift action_10
action_110 (38) = happyShift action_11
action_110 (43) = happyShift action_12
action_110 (44) = happyShift action_13
action_110 (55) = happyShift action_14
action_110 (9) = happyGoto action_115
action_110 (10) = happyGoto action_8
action_110 (11) = happyGoto action_9
action_110 _ = happyFail

action_111 (30) = happyShift action_114
action_111 _ = happyFail

action_112 _ = happyReduce_28

action_113 _ = happyReduce_7

action_114 (32) = happyShift action_19
action_114 (43) = happyShift action_20
action_114 (44) = happyShift action_21
action_114 (55) = happyShift action_22
action_114 (56) = happyShift action_23
action_114 (15) = happyGoto action_126
action_114 (16) = happyGoto action_16
action_114 (17) = happyGoto action_17
action_114 (18) = happyGoto action_18
action_114 _ = happyFail

action_115 (33) = happyShift action_125
action_115 _ = happyFail

action_116 _ = happyReduce_52

action_117 (28) = happyShift action_27
action_117 (29) = happyShift action_28
action_117 (32) = happyShift action_29
action_117 (39) = happyShift action_30
action_117 (42) = happyShift action_31
action_117 (43) = happyShift action_32
action_117 (46) = happyShift action_33
action_117 (47) = happyShift action_34
action_117 (48) = happyShift action_35
action_117 (49) = happyShift action_36
action_117 (52) = happyShift action_37
action_117 (56) = happyShift action_38
action_117 (20) = happyGoto action_124
action_117 (21) = happyGoto action_25
action_117 (22) = happyGoto action_26
action_117 _ = happyFail

action_118 (28) = happyShift action_27
action_118 (29) = happyShift action_28
action_118 (32) = happyShift action_29
action_118 (39) = happyShift action_30
action_118 (42) = happyShift action_31
action_118 (43) = happyShift action_32
action_118 (46) = happyShift action_33
action_118 (47) = happyShift action_34
action_118 (48) = happyShift action_35
action_118 (49) = happyShift action_36
action_118 (52) = happyShift action_37
action_118 (56) = happyShift action_38
action_118 (20) = happyGoto action_123
action_118 (21) = happyGoto action_25
action_118 (22) = happyGoto action_26
action_118 _ = happyFail

action_119 (28) = happyShift action_27
action_119 (29) = happyShift action_28
action_119 (32) = happyShift action_29
action_119 (39) = happyShift action_30
action_119 (42) = happyShift action_31
action_119 (43) = happyShift action_32
action_119 (46) = happyShift action_33
action_119 (47) = happyShift action_34
action_119 (48) = happyShift action_35
action_119 (49) = happyShift action_36
action_119 (52) = happyShift action_37
action_119 (56) = happyShift action_38
action_119 (20) = happyGoto action_122
action_119 (21) = happyGoto action_25
action_119 (22) = happyGoto action_26
action_119 _ = happyFail

action_120 _ = happyReduce_53

action_121 _ = happyReduce_54

action_122 _ = happyReduce_42

action_123 _ = happyReduce_35

action_124 _ = happyReduce_36

action_125 _ = happyReduce_17

action_126 _ = happyReduce_22

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

happyReduce_38 = happySpecReduce_2  20 happyReduction_38
happyReduction_38 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (Succ happy_var_2
	)
happyReduction_38 _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_2  20 happyReduction_39
happyReduction_39 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (Pred happy_var_2
	)
happyReduction_39 _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_2  20 happyReduction_40
happyReduction_40 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (IsZero happy_var_2
	)
happyReduction_40 _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_2  20 happyReduction_41
happyReduction_41 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (Fix happy_var_2
	)
happyReduction_41 _ _  = notHappyAtAll 

happyReduce_42 = happyReduce 6 20 happyReduction_42
happyReduction_42 ((HappyAbsSyn20  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (Cond happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_43 = happySpecReduce_1  20 happyReduction_43
happyReduction_43 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_2  21 happyReduction_44
happyReduction_44 (HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (App happy_var_1 happy_var_2
	)
happyReduction_44 _ _  = notHappyAtAll 

happyReduce_45 = happyReduce 4 21 happyReduction_45
happyReduction_45 (_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (mkTyApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_46 = happySpecReduce_1  21 happyReduction_46
happyReduction_46 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  22 happyReduction_47
happyReduction_47 (HappyTerminal (TVal happy_var_1))
	 =  HappyAbsSyn20
		 (Val happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  22 happyReduction_48
happyReduction_48 (HappyTerminal (TVar happy_var_1))
	 =  HappyAbsSyn20
		 (Var happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  22 happyReduction_49
happyReduction_49 _
	 =  HappyAbsSyn20
		 (TyHole
	)

happyReduce_50 = happySpecReduce_3  22 happyReduction_50
happyReduction_50 _
	(HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (happy_var_2
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  23 happyReduction_51
happyReduction_51 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn23
		 ([happy_var_1]
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  23 happyReduction_52
happyReduction_52 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1 ++ [happy_var_3]
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happyReduce 5 24 happyReduction_53
happyReduction_53 ((HappyAbsSyn20  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	(HappyTerminal (TVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (Def happy_var_2 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_54 = happyReduce 5 24 happyReduction_54
happyReduction_54 ((HappyAbsSyn15  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_3) `HappyStk`
	(HappyTerminal (TCon happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (TypeDec happy_var_2 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_55 = happyReduce 4 24 happyReduction_55
happyReduction_55 ((HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TCon happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn24
		 (KindDec happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_56 = happySpecReduce_2  25 happyReduction_56
happyReduction_56 (HappyAbsSyn25  happy_var_2)
	(HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn25
		 (happy_var_1 : happy_var_2
	)
happyReduction_56 _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_0  25 happyReduction_57
happyReduction_57  =  HappyAbsSyn25
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

