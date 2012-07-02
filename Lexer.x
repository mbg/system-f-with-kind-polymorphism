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