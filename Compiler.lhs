{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

> module Compiler (
>   compile
> ) where
  
    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import Control.Monad.State
    
>   import AST
>   import qualified STG.AST as STG

    {----------------------------------------------------------------------}
    {-- Compiler                                                          -}
    {----------------------------------------------------------------------}

>   data CompilerState = CS {
>       counter  :: Int,
>       bindings :: [STG.Binding]
>   }

>   type Compiler = State CompilerState

>   defaultState :: CompilerState
>   defaultState = CS 0 []

>   addBinding :: STG.Binding -> Compiler ()
>   addBinding b = modify $ \s -> s { bindings = b : bindings s }

>   freshB :: Compiler String
>   freshB = do
>       s <- get
>       put $ s { counter = counter s + 1 }
>       return $ "stg" ++ show (counter s)
       
    We want to group all abstractions which occur in sequence into one
    lambda form in the STG language.
       
>   collect :: Expr -> ([String], Expr)
>   collect (Abs n _ e) = let (xs, e') = collect e in (n : xs, e')
>   collect e           = ([], e)

>   collectArgs :: Expr -> [Expr] -> ([Expr], Expr)
>   collectArgs (App f a) as = collectArgs f (a : as)
>   collectArgs e         as = (as, e)

>   prepareArgs :: [Expr] -> Expr -> [STG.Atom] -> Compiler STG.Expr
>   prepareArgs []       f ps = do compileApp f ps
>   prepareArgs (x : xs) f ps = do
>       (p,w) <- fixArg x
>       prepareArgs xs f (p : ps) 

>   fixArg :: Expr -> Compiler (STG.Atom, STG.Expr -> STG.Expr)
>   fixArg (Val x)     = do return (STG.AL $ STG.IntLit (fromIntegral x), id)
>   fixArg (Var n)     = do return (STG.AN n, id)
>   fixArg (Abs n _ e) = do
>       b <- freshB
>       return (STG.AN b, \e -> STG.Let [] e)

>   compileApp :: Expr -> [STG.Atom] -> Compiler STG.Expr
>   compileApp (Var n)     ps = do return $ STG.App n ps
>   compileApp (Abs n _ e) ps = let (vs, e') = collect e in do
>       ce <- compileExpr e'
>       addBinding $ STG.B "labelme" (STG.L [] STG.Updatable (n : vs) ce)
>       return $ STG.App "labelme" ps 

>   compileExpr :: Expr -> Compiler STG.Expr
>   compileExpr (Val x)   = return $ STG.Lit $ STG.IntLit (fromIntegral x)
>   compileExpr (Var n)   = return $ STG.App n []
>   compileExpr (App f a) = let (as, e) = collectArgs f [a] in do
>       -- create let statements for arguments which require them
>       -- make sure as is updated
>       prepareArgs as e []
       
>   compileDef :: Definition -> Compiler ()
>   compileDef (Def n e) = let (vs, e') = collect e in do
>       ce <- compileExpr e'
>       addBinding $ STG.B n (STG.L [] STG.Updatable vs ce) 
       
>   compileSTG :: Program -> Compiler ()
>   compileSTG p = mapM_ compileDef p

    {----------------------------------------------------------------------}
    {-- External Interface                                                -}
    {----------------------------------------------------------------------}
    
>   compile :: Program -> STG.Program
>   compile p = STG.P $ bindings $ execState (compileSTG p) defaultState

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  