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
    
%right '->' 

%%

Def  : VAR '=' Exp                  { Def $1 $3 }
Exp  : VAL                          { Val $1 }
     | VAR                          { Var $1 }
     | '\\' VAR ':' Type '.' Exp    { Abs $2 $4 $6 }
     | '(' Exp Exp ')'              { App $2 $3 }
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
