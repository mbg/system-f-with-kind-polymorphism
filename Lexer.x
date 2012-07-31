{
module Lexer (alexScanTokens) where
import Token
}

%wrapper "basic"

$digit = 0-9
$lower = [a-z]
$upper = [A-Z]

tokens :-

  $white+				;
  "--".*				;
  "let"                 { \s -> TLet }
  "succ"                { \s -> TSucc }
  "pred"                { \s -> TPred }
  "iszero"              { \s -> TIsZero }
  "if"                  { \s -> TIf }
  "then"                { \s -> TThen }
  "else"                { \s -> TElse }
  "fix"                 { \s -> TFix }
  $lower+               { \s -> TVar s }
  $upper $lower*        { \s -> TType s }
  $digit+               { \s -> TVal (read s) }
  "\"                   { \s -> TAbs }
  "."                   { \s -> TDot }
  "("                   { \s -> TOpen }
  ")"                   { \s -> TClose }
  ":"                   { \s -> TColon }
  "->"                  { \s -> TArrow }
  "="                   { \s -> TEquals }