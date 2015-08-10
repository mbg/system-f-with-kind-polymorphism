{
module Lexer (alexScanTokens) where
import Token
}

%wrapper "basic"

$digit = 0-9
$lower = [a-z]
$upper = [A-Z]
$ctr   = [$lower $upper]

tokens :-

  $white+ ;
  "--".* ;
  "let"                 { \s -> TLet }
  "succ"                { \s -> TSucc }
  "pred"                { \s -> TPred }
  "iszero"              { \s -> TIsZero }
  "if"                  { \s -> TIf }
  "then"                { \s -> TThen }
  "else"                { \s -> TElse }
  "fix"                 { \s -> TFix }
  "type"                { \s -> TType }
  "kind"                { \s -> TKind }
  "forall"              { \s -> TForAll }
  "with"                { \s -> TWith }
  "'" $lower+           { \s -> TTyVar s }
  $lower+               { \s -> TVar s }
  $upper $ctr*          { \s -> TCon s }
  $digit+               { \s -> TVal (read s) }
  "/\"                  { \s -> TTyAbs }
  "\"                   { \s -> TAbs }
  "."                   { \s -> TDot }
  ","                   { \s -> TComma }
  "("                   { \s -> TOpen }
  ")"                   { \s -> TClose }
  "["                   { \s -> TAngLeft }
  "]"                   { \s -> TAngRight }
  "{"                   { \s -> TCurlyLeft }
  "}"                   { \s -> TCurlyRight }
  ":"                   { \s -> TColon }
  "->"                  { \s -> TArrow }
  "~>"                  { \s -> TKindArrow }
  "="                   { \s -> TEquals }
  "*"                   { \s -> TStar }
  "_"                   { \s -> THole }