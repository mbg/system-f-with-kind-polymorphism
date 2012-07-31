{
module Parser (
    parseDef,
    parseProg,
    parseExpr
) where

import Token
import Types
import AST
}

%name parseDef Def
%name parseProg Defs
%name parseExpr Exp
%tokentype { Token }
%error { parseError }

%token
    '='     { TEquals }
    ':'     { TColon }
    '\\'    { TAbs }
    '.'     { TDot }
    '('     { TOpen }
    ')'     { TClose }
    '->'    { TArrow }
    VAL     { TVal $$ }
    VAR     { TVar $$ }
    TYPE    { TType $$ }
    LET     { TLet }
    SUCC    { TSucc }
    PRED    { TPred }
    ISZERO  { TIsZero }
    IF      { TIf }
    THEN    { TThen }
    ELSE    { TElse }
    FIX     { TFix }
    
%right VAR
%left '=' 
%right '->'

%%

Def  : LET VAR '=' Exp              { Def $2 $4 }

Exp  :: { Expr }
     : '\\' VAR ':' Type '.' Exp    { Abs $2 $4 $6 }
     | SUCC Exp                     { Succ $2 }
     | PRED Exp                     { Pred $2 }
     | ISZERO Exp                   { IsZero $2 }
     | FIX Exp                      { Fix $2 }
     | IF Exp THEN Exp ELSE Exp     { Cond $2 $4 $6 }
     | Exp1                         { $1 }
Exp1 :: { Expr }
     : Exp1 Atom                    { App $1 $2 }
     | Atom                         { $1 }
Atom :: { Expr }
     : VAL                          { Val $1 }
     | VAR                          { Var $1 }
     | '(' Exp ')'                  { $2 }
Type : TYPE                         { ConTy $1 }
     | Type '->' Type               { FunTy $1 $3 }
     | '(' Type ')'                 { $2 }
Defs : Def Defs                     { $1 : $2 }
     |                              { [] }
     
{
parseError :: [Token] -> a
parseError ts = error "parser error"
}
