{
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
}

%name parseDef Def
%name parseProg Defs
%name parseExpr Exp
%name parseType Type
%name parseKind Kind
%tokentype { Token }
%error { parseError }

%token
    '='     { TEquals }
    ':'     { TColon }
    '/\\'   { TTyAbs }
    '\\'    { TAbs }
    '.'     { TDot }
    ','     { TComma }
    '('     { TOpen }
    ')'     { TClose }
    '['     { TAngLeft }
    ']'     { TAngRight }
    '{'     { TCurlyLeft }
    '}'     { TCurlyRight }
    '*'     { TStar }
    '_'     { THole }
    '->'    { TArrow }
    '~>'    { TKindArrow }
    VAL     { TVal $$ }
    VAR     { TVar $$ }
    CON     { TCon $$ }
    LET     { TLet }
    SUCC    { TSucc }
    PRED    { TPred }
    ISZERO  { TIsZero }
    IF      { TIf }
    THEN    { TThen }
    ELSE    { TElse }
    FIX     { TFix }
    TYPE    { TType }
    KIND    { TKind }
    FORALL  { TForAll }
    WITH    { TWith }
    
%right VAR
%left '=' 
%right '->'

%%

KVarList :: { [String] }
 : VAR                              { [$1] }
 | KVarList VAR                     { $1 ++ [$2] } 

Kind :: { Kind }
 : FORALL KVarList '.' Kind         { mkKForAll $2 $4 }
 | Kind1                            { $1 }

Kind1 :: { Kind } 
 : Kind0 '~>' Kind1                 { KArrow $1 $3 }
 | Kind0                            { $1 }
Kind0 :: { Kind }
 : '*'                              { KStar }
 | CON                              { KName $1 }
 | VAR                              { KVar $1 }
 | '(' Kind ')'                     { $2 }

OptKinding :: { Maybe Kind }
 : ':' Kind                         { Just $2 }
 |                                  { Nothing }

BrTyping :: { (String, Kind) }
 : '(' VAR ':' Kind ')'             { ($2, $4 ) }
 | VAR                              { ($1, KStar) }

TyVarList :: { [(String, Kind)] }
 : BrTyping                         { [$1] }
 | TyVarList BrTyping               { $1 ++ [$2] }

Type :: { Type }
 : Type1                            { $1 }
 | FORALL VAR ':' Kind '.' Type     { ForAllTy $2 $4 $6 }
 | FORALL TyVarList '.' Type        { mkForAllTy $2 $4 }
 | WITH VAR '.' Type                { KindAbsTy $2 $4 }
Type1 : Type2 '->' Type1            { FunTy $1 $3 }
      | Type2                       { $1 }
Type2 : Type2 SType                 { AppTy $1 $2 }
      | Type2 '{' Kind '}'          { KindAppTy $1 $3 }
      | SType                       { $1 }
SType : CON                         { ConTy $1 }
      | VAR                       { VarTy $1 }
      | '(' Type ')'                { $2 }

OptTyping :: { Maybe Type }
 : ':' Type                         { Just $2 }
 |                                  { Nothing }

Exp  :: { Expr }
     : '\\' VAR ':' Type '.' Exp    { Abs $2 $4 $6 }
     | '/\\' VAR ':' Kind '.' Exp   { TyAbs $2 $4 $6 }
     | WITH VAR '.' Exp             { KindAbs $2 $4 }
     | Exp1                         { $1 }
Exp1 :: { Expr }
     : Exp1 Atom                    { App $1 $2 }
     | Exp1 '[' TyArgList ']'           { mkTyApp $1 $3 }
     | Atom                         { $1 }
Atom :: { Expr }
     : VAR                          { Var $1 }
     | '_'                          { TyHole }
     | '(' Exp ')'                  { $2 }

TyArgList :: { [Type] }
 : Type                             { [$1] }
 | TyArgList ',' Type               { $1 ++ [$3] }

Def  : LET VAR OptTyping '=' Exp    { Def $2 $3 $5 }
     | TYPE CON OptKinding '=' Type { TypeDec $2 $3 $5 } 
     | KIND CON '=' Kind            { KindDec $2 $4 }
Defs : Def Defs                     { $1 : $2 }
     |                              { [] }
     
{
parseError :: [Token] -> a
parseError ts = error "parser error"

mkKForAll :: [String] -> Kind -> Kind
mkKForAll ns k = foldr (\n k' -> KForAll n k') k ns

mkForAllTy :: [(String, Kind)] -> Type -> Type
mkForAllTy ns t = foldr (\(n,k) t' -> ForAllTy n k t') t ns

mkTyApp :: Expr -> [Type] -> Expr 
mkTyApp = foldl (\e t -> TyApp e t)
}
